import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
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
  final int _drawerTabIndex = 2;
  late final TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final RoundedLoadingButtonController _createCategorieBtnController = RoundedLoadingButtonController();
  CategorieType _selectedCategorieType = CategorieType.expense;
  List<bool> _selectedCategorieValue = [true, false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: CategorieType.values.length, vsync: this);
    loadCategories(context);
  }

  void loadCategories(BuildContext context) {
    BlocProvider.of<CategorieBloc>(context).add(
      const LoadAllCategories(),
    );
  }

  void _addCategorie() {
    if (_tabController.index == 0) {
      _selectedCategorieType = CategorieType.expense;
      _selectedCategorieValue = [true, false, false];
    } else if (_tabController.index == 1) {
      _selectedCategorieType = CategorieType.income;
      _selectedCategorieValue = [false, true, false];
    } else if (_tabController.index == 2) {
      _selectedCategorieType = CategorieType.investment;
      _selectedCategorieValue = [false, false, true];
    }
    _titleController.text = '';
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 8.0),
                              Wrap(
                                spacing: 6.0,
                                children: List<Widget>.generate(
                                  CategorieType.values.length,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(CategorieType.values[index].name),
                                      selected: _selectedCategorieValue[index],
                                      onSelected: (_) => _changeCategorieType(index, setModalBottomState),
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        );
                      }),
                      TitleTextField(
                        hintText: 'Kategoriename...',
                        titleController: _titleController,
                        autofocus: true,
                      ),
                      const SizedBox(height: 8.0),
                      SaveButton(
                        text: 'Erstellen',
                        saveBtnController: _createCategorieBtnController,
                        onPressed: () {
                          _createCategorie();
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

  void _createCategorie() {
    final FormState form = _categorieFormKey.currentState!;
    if (form.validate() == false) {
      _createCategorieBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createCategorieBtnController.reset();
      });
    } else {
      _createCategorieBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<CategorieBloc>(context).add(
          CreateCategorie(
            Categorie(
              id: 0,
              type: _selectedCategorieType,
              name: _titleController.text,
            ),
          ),
        );
      });
      if (_selectedCategorieType == CategorieType.expense) {
        _tabController.index = 0;
      } else if (_selectedCategorieType == CategorieType.income) {
        _tabController.index = 1;
      } else if (_selectedCategorieType == CategorieType.investment) {
        _tabController.index = 2;
      }
      Navigator.pop(context);
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

  void _changeCategorieType(int index, StateSetter setModalBottomState) {
    setModalBottomState(() {
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
    });
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
              Tab(text: CategorieType.expense.name),
              Tab(text: CategorieType.income.name),
              Tab(text: CategorieType.investment.name),
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
                      duration: const Duration(milliseconds: 500),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const CircularProgressIndicator();
                    } else if (state is Loaded) {
                      return AnimatedList(
                        key: _expenseKey,
                        initialItemCount: state.expenseCategories.length,
                        itemBuilder: (context, index, animation) {
                          if (state.expenseCategories.isEmpty) {
                            return const Text('Keine Kategorien vorhanden.');
                          } else {
                            if (state.expenseCategories[index].type == CategorieType.expense) {
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
                                  onTap: () => {}, // TODO
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        },
                      );
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
                      duration: const Duration(milliseconds: 500),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const CircularProgressIndicator();
                    } else if (state is Loaded) {
                      return AnimatedList(
                        key: _incomeKey,
                        initialItemCount: state.incomeCategories.length,
                        itemBuilder: (context, index, animation) {
                          if (state.incomeCategories.isEmpty) {
                            return const Text('Keine Kategorien vorhanden.');
                          } else {
                            if (state.incomeCategories[index].type == CategorieType.income) {
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
                                  onTap: () => {}, // TODO
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        },
                      );
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
                      duration: const Duration(milliseconds: 500),
                    );
                    loadCategories(context);
                  } else if (state is Deleted) {
                    loadCategories(context);
                  }
                },
                child: BlocBuilder<CategorieBloc, CategorieState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const CircularProgressIndicator();
                    } else if (state is Loaded) {
                      return AnimatedList(
                        key: _investmentKey,
                        initialItemCount: state.investmentCategories.length,
                        itemBuilder: (context, index, animation) {
                          if (state.investmentCategories.isEmpty) {
                            return const Text('Keine Kategorien vorhanden.');
                          } else {
                            if (state.investmentCategories[index].type == CategorieType.investment) {
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
                                  onTap: () => {}, // TODO
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('Moneybook'),
              ),
              ListTile(
                leading: Icon(
                  Icons.auto_stories_rounded,
                  color: _drawerTabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
                ),
                title: Text(
                  'Buchungen',
                  style: TextStyle(color: _drawerTabIndex == 0 ? Colors.cyan.shade400 : Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: _drawerTabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _drawerTabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
                ),
                title: Text(
                  'Konten',
                  style: TextStyle(color: _drawerTabIndex == 1 ? Colors.cyan.shade400 : Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: _drawerTabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(1));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.donut_small,
                  color: _drawerTabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
                ),
                title: Text(
                  'Kategorien',
                  style: TextStyle(color: _drawerTabIndex == 2 ? Colors.cyan.shade400 : Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: _drawerTabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
                ),
                selected: true,
                onTap: () {
                  Navigator.popAndPushNamed(context, categorieListRoute);
                },
              ),
            ],
          ),
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
