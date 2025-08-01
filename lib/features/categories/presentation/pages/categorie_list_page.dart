import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
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
  List<Categorie> _currentCategorieList = [];
  String _categorieNameForDb = '';
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
    _categorieNameForDb = '';
    _editMode = false;
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            color: Color(0xFF1c1b20),
            child: Wrap(
              children: [
                Form(
                  key: _categorieFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BottomSheetHeader(title: AppLocalizations.of(context).translate('kategorie_erstellen')),
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
                                      label: Text(AppLocalizations.of(context).translate(CategorieType.values[index].name)),
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
                        hintText: AppLocalizations.of(context).translate('kategoriename') + '...',
                        titleController: _categorieNameController,
                        autofocus: true,
                      ),
                      const SizedBox(height: 8.0),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('erstellen'),
                        saveBtnController: _categorieBtnController,
                        onPressed: () {
                          BlocProvider.of<CategorieBloc>(context).add(
                            ExistsCategorieName(
                              Categorie(
                                id: 0,
                                name: _categorieNameController.text.trim(),
                                type: _selectedCategorieType,
                              ),
                              _currentCategorieList,
                              context,
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
        title: AppLocalizations.of(context).translate('kategoriename_existiert_bereits'),
        message: AppLocalizations.of(context).translate('kategoriename_existiert_bereits_beschreibung'),
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
              id: 0, // Wird automatisch hochgezählt (AutoIncrement)
              type: _selectedCategorieType,
              name: _categorieNameController.text.trim(),
            ),
          ),
        );
        Posthog().capture(
          eventName: 'Kategorie erstellt',
          properties: {
            'Aktion': 'Kategorie erstellt',
          },
        );
      });
      _setTabControllerIndex(_selectedCategorieType);
      Navigator.pop(context);
      _showFlushbar(AppLocalizations.of(context).translate('kategorie_erstellen_benachrichtigung'));
    }
  }

  void _showEditCategorieBottomSheet(Categorie categorie) {
    _setSelectedCategorie(categorie.type);
    _categorieNameController.text = AppLocalizations.of(context).translate(categorie.name);
    _categorieNameForDb = categorie.name;
    _oldCategorieName = categorie.name;
    _editMode = true;
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Material(
            color: Color(0xFF1c1b20),
            child: Wrap(
              children: [
                Form(
                  key: _categorieFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BottomSheetHeader(title: AppLocalizations.of(context).translate('kategorie_bearbeiten')),
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
                                      label: Text(AppLocalizations.of(context).translate(CategorieType.values[index].name)),
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
                        hintText: AppLocalizations.of(context).translate('kategoriename') + '...',
                        titleController: _categorieNameController,
                        autofocus: true,
                      ),
                      const SizedBox(height: 8.0),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('speichern'),
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
        title: AppLocalizations.of(context).translate('kategoriename_existiert_bereits'),
        message: AppLocalizations.of(context).translate('kategoriename_existiert_bereits_beschreibung'),
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
            _categorieNameController.text.trim(),
          ),
        );
        BlocProvider.of<booking.BookingBloc>(context).add(
          booking.UpdateBookingsWithCategorie(
            _oldCategorieName,
            _categorieNameController.text.trim(),
            _selectedCategorieType,
          ),
        );
      });
      _setTabControllerIndex(_selectedCategorieType);
      Navigator.pop(context);
      _showFlushbar(AppLocalizations.of(context).translate('kategorie_bearbeiten_benachrichtigung'));
    }
  }

  void _deleteCategorie(BuildContext context, Categorie categorie, int index) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('kategorie_löschen')),
          content: Text(AppLocalizations.of(context).translate('kategorie_löschen_beschreibung')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ja')),
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
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: ListTile(
                          title: Text(AppLocalizations.of(context).translate('gelöscht')),
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
                _showFlushbar(AppLocalizations.of(context).translate('kategorie_löschen_benachrichtigung'));
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('nein')),
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
          title: Text(AppLocalizations.of(context).translate('kategorien')),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.notes_rounded),
              );
            },
          ),
          bottom: TabBar(
            key: UniqueKey(),
            controller: _tabController,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: AppLocalizations.of(context).translate(CategorieType.expense.pluralName)),
              Tab(text: AppLocalizations.of(context).translate(CategorieType.income.pluralName)),
              Tab(text: AppLocalizations.of(context).translate(CategorieType.investment.pluralName)),
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
                      _currentCategorieList = state.expenseCategories;
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
                            Expanded(
                              child: EmptyList(
                                text: AppLocalizations.of(context).translate('keine_ausgabe_kategorien'),
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
                                  title: Text(AppLocalizations.of(context).translate(state.expenseCategories[index].name)),
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
                      _currentCategorieList = state.incomeCategories;
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
                            Expanded(
                              child: EmptyList(
                                text: AppLocalizations.of(context).translate('keine_einnahme_kategorien'),
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
                                  title: index < state.incomeCategories.length
                                      ? Text(AppLocalizations.of(context).translate(state.incomeCategories[index].name))
                                      : null,
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
                      _currentCategorieList = state.investmentCategories;
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
                            Expanded(
                              child: EmptyList(
                                text: AppLocalizations.of(context).translate('keine_investitions_kategorien'),
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
                                  title: index < state.investmentCategories.length
                                      ? Text(AppLocalizations.of(context).translate(state.investmentCategories[index].name))
                                      : null,
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
