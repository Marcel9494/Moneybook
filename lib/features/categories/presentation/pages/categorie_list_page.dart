import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../../shared/presentation/widgets/navigation_widgets/side_menu_drawer_widget.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../../budgets/presentation/bloc/budget_bloc.dart' as budget;
import '../../domain/entities/categorie.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../bloc/categorie_bloc.dart';

class CategorieListPage extends StatefulWidget {
  const CategorieListPage({super.key});

  @override
  State<CategorieListPage> createState() => _CategorieListPageState();
}

class _CategorieListPageState extends State<CategorieListPage> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _expenseKey = GlobalKey();
  final GlobalKey<AnimatedListState> _incomeKey = GlobalKey();
  final GlobalKey<AnimatedListState> _investmentKey = GlobalKey();
  final GlobalKey<FormState> _categorieFormKey = GlobalKey<FormState>();
  late final TabController _tabController;
  final TextEditingController _categorieNameController = TextEditingController();
  final RoundedLoadingButtonController _categorieBtnController = RoundedLoadingButtonController();
  CategorieType _selectedCategorieType = CategorieType.expense;
  List<bool> _selectedCategorieValue = [true, false, false];
  String _oldCategorieName = '';
  int _numberOfEventCalls = 0;
  int _tabIndex = 4;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: CategorieType.values.length, vsync: this);
    loadCategories(context);
  }

  void _onTabChange(int index) {
    setState(() {
      _tabIndex = index;
    });
    Navigator.pop(context);
    if (_tabIndex <= 3) {
      Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: _tabIndex));
    } else if (_tabIndex == 4) {
      Navigator.popAndPushNamed(context, categorieListRoute);
    } else if (_tabIndex == 5) {
      Navigator.popAndPushNamed(context, settingsRoute);
    }
  }

  void loadCategories(BuildContext context) {
    BlocProvider.of<CategorieBloc>(context).add(
      const LoadAllCategories(),
    );
  }

  void _addCategorie() {
    _changeCategorieType(_tabController.index);
    _categorieNameController.text = '';
    _editMode = false;
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            child: Wrap(
              children: [
                Form(
                  key: _categorieFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BottomSheetHeader(title: 'Kategorie erstellen'),
                      StatefulBuilder(builder: (BuildContext context, StateSetter setModalBottomState) {
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Wrap(
                                spacing: 6.0,
                                children: List<Widget>.generate(
                                  CategorieType.values.length,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(CategorieType.values[index].name),
                                      selected: _selectedCategorieValue[index],
                                      onSelected: (_) => setModalBottomState(() {
                                        _changeCategorieType(index);
                                      }),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                      TitleTextField(
                        hintText: 'Kategoriename...',
                        titleController: _categorieNameController,
                        autofocus: true,
                      ),
                      const SizedBox(height: 8.0),
                      SaveButton(
                        text: 'Erstellen',
                        saveBtnController: _categorieBtnController,
                        onPressed: () {
                          BlocProvider.of<CategorieBloc>(context).add(
                            CheckCategorieNameExists(
                              Categorie(
                                id: 0,
                                name: _categorieNameController.text.trim(),
                                type: _selectedCategorieType,
                              ),
                              _numberOfEventCalls,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _createCategorie(CheckedCategorieName state) {
    final FormState form = _categorieFormKey.currentState!;
    if (state.categorieNameExists) {
      _numberOfEventCalls++;
      _categorieBtnController.error();
      Flushbar(
        title: 'Kategoriename existiert bereits',
        message: 'Der Kategoriename ${_categorieNameController.text.trim()} existiert bereits. Bitte benennen Sie den Kategoriename um.',
        icon: const Icon(Icons.error_outline_rounded, color: Colors.yellowAccent),
        duration: const Duration(milliseconds: flushbarDurationInMs),
        leftBarIndicatorColor: Colors.yellowAccent,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      Timer(const Duration(milliseconds: durationInMs), () {
        _categorieBtnController.reset();
      });
    } else if (form.validate() == false) {
      _categorieBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _categorieBtnController.reset();
      });
    } else {
      _categorieBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<CategorieBloc>(context).add(
          CreateCategorie(
            Categorie(
              id: 0,
              type: _selectedCategorieType,
              name: _categorieNameController.text.trim(),
            ),
          ),
        );
      });
      _setTabControllerIndex(_selectedCategorieType);
      Navigator.pop(context);
      _showFlushbar('Kategorie ${_categorieNameController.text.trim()} wurde erfolgreich erstellt.');
    }
  }

  void _showEditCategorieBottomSheet(Categorie categorie) {
    _setSelectedCategorie(categorie.type);
    _categorieNameController.text = categorie.name;
    _oldCategorieName = categorie.name;
    _editMode = true;
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            child: Wrap(
              children: [
                Form(
                  key: _categorieFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BottomSheetHeader(title: 'Kategorie bearbeiten'),
                      StatefulBuilder(builder: (BuildContext context, StateSetter setModalBottomState) {
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Wrap(
                                spacing: 6.0,
                                children: List<Widget>.generate(
                                  CategorieType.values.length,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(CategorieType.values[index].name),
                                      selected: _selectedCategorieValue[index],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                      TitleTextField(
                        hintText: 'Kategoriename...',
                        titleController: _categorieNameController,
                        autofocus: true,
                      ),
                      const SizedBox(height: 8.0),
                      SaveButton(
                        text: 'Speichern',
                        saveBtnController: _categorieBtnController,
                        onPressed: () {
                          BlocProvider.of<CategorieBloc>(context).add(
                            CheckCategorieNameExists(
                              Categorie(
                                id: categorie.id,
                                name: _categorieNameController.text,
                                type: _selectedCategorieType,
                              ),
                              _numberOfEventCalls,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editCategorie(Categorie categorie, CheckedCategorieName state) {
    final FormState form = _categorieFormKey.currentState!;
    if (state.categorieNameExists && _oldCategorieName != _categorieNameController.text.trim()) {
      _numberOfEventCalls++;
      _categorieBtnController.error();
      Flushbar(
        title: 'Kategoriename existiert bereits',
        message: 'Der Kategoriename ${_categorieNameController.text.trim()} existiert bereits. Bitte benennen Sie den Kategoriename um.',
        icon: const Icon(Icons.error_outline_rounded, color: Colors.yellowAccent),
        duration: const Duration(milliseconds: flushbarDurationInMs),
        leftBarIndicatorColor: Colors.yellowAccent,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      Timer(const Duration(milliseconds: durationInMs), () {
        _categorieBtnController.reset();
      });
    } else if (form.validate() == false) {
      _categorieBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _categorieBtnController.reset();
      });
    } else {
      _categorieBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<CategorieBloc>(context).add(
          EditCategorie(
            Categorie(
              id: categorie.id,
              type: _selectedCategorieType,
              name: _categorieNameController.text.trim(),
            ),
          ),
        );
        BlocProvider.of<budget.BudgetBloc>(context).add(
          budget.UpdateBudgetsWithCategorie(
            _oldCategorieName,
            _categorieNameController.text,
          ),
        );
        BlocProvider.of<booking.BookingBloc>(context).add(
          booking.UpdateBookingsWithCategorie(
            _oldCategorieName,
            _categorieNameController.text,
            _selectedCategorieType,
          ),
        );
      });
      _setTabControllerIndex(_selectedCategorieType);
      Navigator.pop(context);
      _showFlushbar('Kategorie ${_categorieNameController.text.trim()} wurde erfolgreich bearbeitet.');
    }
  }

  void _deleteCategorie(BuildContext context, Categorie categorie, int index) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kategorie löschen?'),
          content: Text('Wollen Sie die Kategorie ${categorie.name} wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                GlobalKey<AnimatedListState> key = GlobalKey();
                if (categorie.type == CategorieType.expense) {
                  key = _expenseKey;
                } else if (categorie.type == CategorieType.income) {
                  key = _incomeKey;
                } else if (categorie.type == CategorieType.investment) {
                  key = _investmentKey;
                }
                key.currentState!.removeItem(
                  index,
                  (context, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: const Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: ListTile(
                          title: Text('Gelöscht'),
                        ),
                      ),
                    );
                  },
                  duration: const Duration(milliseconds: 1200),
                );
                BlocProvider.of<CategorieBloc>(context).add(
                  DeleteCategorie(categorie.id, context),
                );
                Navigator.of(context).pop();
                _showFlushbar('Kategorie ${_categorieNameController.text.trim()} wurde erfolgreich gelöscht.');
              },
            ),
            TextButton(
              child: const Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setSelectedCategorie(CategorieType categorieType) {
    if (categorieType == CategorieType.expense) {
      _selectedCategorieType = CategorieType.expense;
      _selectedCategorieValue = [true, false, false];
    } else if (categorieType == CategorieType.income) {
      _selectedCategorieType = CategorieType.income;
      _selectedCategorieValue = [false, true, false];
    } else if (categorieType == CategorieType.investment) {
      _selectedCategorieType = CategorieType.investment;
      _selectedCategorieValue = [false, false, true];
    }
  }

  void _setTabControllerIndex(CategorieType selectedCategorieType) {
    if (selectedCategorieType == CategorieType.expense) {
      _tabController.index = 0;
    } else if (selectedCategorieType == CategorieType.income) {
      _tabController.index = 1;
    } else if (selectedCategorieType == CategorieType.investment) {
      _tabController.index = 2;
    }
  }

  void _changeCategorieType(int index) {
    if (index == 0) {
      _selectedCategorieType = CategorieType.expense;
      _selectedCategorieValue = [true, false, false];
    } else if (index == 1) {
      _selectedCategorieType = CategorieType.income;
      _selectedCategorieValue = [false, true, false];
    } else if (index == 2) {
      _selectedCategorieType = CategorieType.investment;
      _selectedCategorieValue = [false, false, true];
    }
  }

  void _showFlushbar(String message) {
    Flushbar(
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.cyanAccent,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.cyanAccent,
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: false,
    )..show(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CategorieType.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kategorien'),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),
          bottom: TabBar(
            key: UniqueKey(),
            controller: _tabController,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: CategorieType.expense.pluralName),
              Tab(text: CategorieType.income.pluralName),
              Tab(text: CategorieType.investment.pluralName),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: TabBarView(
            key: UniqueKey(),
            controller: _tabController,
            children: [
              BlocListener<CategorieBloc, CategorieState>(
                listener: (context, state) {
                  if (state is Finished) {
                    _expenseKey.currentState!.insertItem(
                      0,
                      duration: const Duration(milliseconds: 100),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  } else if (state is CheckedCategorieName) {
                    if (_editMode) {
                      _editCategorie(state.categorie, state);
                    } else {
                      _createCategorie(state);
                    }
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is Loaded) {
                      if (state.expenseCategories.isEmpty) {
                        return Column(
                          children: [
                            // Muss vorhanden sein, damit _expenseKey.currentState nicht null ist
                            SizedBox(
                              height: 0.0,
                              child: AnimatedList(
                                key: _expenseKey,
                                initialItemCount: state.expenseCategories.length,
                                itemBuilder: (context, index, animation) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                            const Expanded(
                              child: EmptyList(
                                text: 'Keine Ausgabe Kategorien vorhanden',
                                icon: Icons.receipt_long_rounded,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return AnimatedList(
                          key: _expenseKey,
                          initialItemCount: state.expenseCategories.length,
                          itemBuilder: (context, index, animation) {
                            if (index < state.expenseCategories.length && state.expenseCategories[index].type == CategorieType.expense) {
                              return Card(
                                child: ListTile(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  title: Text(state.expenseCategories[index].name),
                                  leading: IconButton(
                                    onPressed: () => _deleteCategorie(context, state.expenseCategories[index], index),
                                    icon: const Icon(Icons.remove_circle_outline_rounded),
                                  ),
                                  onTap: () => _showEditCategorieBottomSheet(state.expenseCategories[index]),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ),
              BlocListener<CategorieBloc, CategorieState>(
                listener: (context, state) {
                  if (state is Finished) {
                    _incomeKey.currentState!.insertItem(
                      0,
                      duration: const Duration(milliseconds: 100),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  } else if (state is CheckedCategorieName) {
                    if (_editMode) {
                      _editCategorie(state.categorie, state);
                    } else {
                      _createCategorie(state);
                    }
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is Loaded) {
                      if (state.incomeCategories.isEmpty) {
                        return Column(
                          children: [
                            // Muss vorhanden sein, damit _incomeKey.currentState nicht null ist
                            SizedBox(
                              height: 0.0,
                              child: AnimatedList(
                                key: _incomeKey,
                                initialItemCount: state.incomeCategories.length,
                                itemBuilder: (context, index, animation) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                            const Expanded(
                              child: EmptyList(
                                text: 'Keine Einnahme Kategorien vorhanden',
                                icon: Icons.receipt_long_rounded,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return AnimatedList(
                          key: _incomeKey,
                          initialItemCount: state.incomeCategories.length,
                          itemBuilder: (context, index, animation) {
                            if (index < state.incomeCategories.length && state.incomeCategories[index].type == CategorieType.income) {
                              return Card(
                                child: ListTile(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  title: index < state.incomeCategories.length ? Text(state.incomeCategories[index].name) : null,
                                  leading: IconButton(
                                    onPressed: () => _deleteCategorie(context, state.incomeCategories[index], index),
                                    icon: const Icon(Icons.remove_circle_outline_rounded),
                                  ),
                                  onTap: () => _showEditCategorieBottomSheet(state.incomeCategories[index]),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ),
              BlocListener<CategorieBloc, CategorieState>(
                listener: (context, state) {
                  if (state is Finished) {
                    _investmentKey.currentState!.insertItem(
                      0,
                      duration: const Duration(milliseconds: 100),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  } else if (state is CheckedCategorieName) {
                    if (_editMode) {
                      _editCategorie(state.categorie, state);
                    } else {
                      _createCategorie(state);
                    }
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is Loaded) {
                      if (state.investmentCategories.isEmpty) {
                        return Column(
                          children: [
                            // Muss vorhanden sein, damit _investmentKey.currentState nicht null ist
                            SizedBox(
                              height: 0.0,
                              child: AnimatedList(
                                key: _investmentKey,
                                initialItemCount: state.investmentCategories.length,
                                itemBuilder: (context, index, animation) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                            const Expanded(
                              child: EmptyList(
                                text: 'Keine Investitions Kategorien vorhanden',
                                icon: Icons.receipt_long_rounded,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return AnimatedList(
                          key: _investmentKey,
                          initialItemCount: state.investmentCategories.length,
                          itemBuilder: (context, index, animation) {
                            if (index < state.investmentCategories.length && state.investmentCategories[index].type == CategorieType.investment) {
                              return Card(
                                child: ListTile(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  title: index < state.investmentCategories.length ? Text(state.investmentCategories[index].name) : null,
                                  leading: IconButton(
                                    onPressed: () => _deleteCategorie(context, state.investmentCategories[index], index),
                                    icon: const Icon(Icons.remove_circle_outline_rounded),
                                  ),
                                  onTap: () => _showEditCategorieBottomSheet(state.investmentCategories[index]),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: SideMenuDrawer(
          tabIndex: _tabIndex,
          onTabChange: (tabIndex) => _onTabChange(tabIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addCategorie(),
          shape: const CircleBorder(),
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.cyan.shade600],
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
