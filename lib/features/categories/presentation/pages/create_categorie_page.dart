import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../bloc/categorie_bloc.dart';

class CreateCategoriePage extends StatefulWidget {
  const CreateCategoriePage({super.key});

  @override
  State<CreateCategoriePage> createState() => _CreateCategoriePageState();
}

class _CreateCategoriePageState extends State<CreateCategoriePage> {
  final GlobalKey<FormState> _categorieFormKey = GlobalKey<FormState>();
  final TextEditingController _categorieTypeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final RoundedLoadingButtonController _createCategorieBtnController = RoundedLoadingButtonController();
  final CategorieType _categorieType = CategorieType.outcome;

  void _createAccount(BuildContext context) {
    final FormState form = _categorieFormKey.currentState!;
    if (form.validate() == false) {
      _createCategorieBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createCategorieBtnController.reset();
      });
    } else {
      _createCategorieBtnController.success();
      /*Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<CategorieBloc>(context).add(
          CreateCategorie(
            Categorie(
              id: 0,
              type: _categorieType,
              name: _titleController.text,
            ),
          ),
        );
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorie erstellen'),
      ),
      body: BlocProvider(
        create: (_) => sl<CategorieBloc>(),
        child: BlocConsumer<CategorieBloc, CategorieState>(
          listener: (BuildContext context, CategorieState state) {
            if (state is Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, categorieListRoute);
            }
          },
          builder: (BuildContext context, state) {
            if (state is Initial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Card(
                    child: Form(
                      key: _categorieFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TODO hier weitermachen und CategorieType auswählen implementieren
                          TitleTextField(hintText: 'Kategoriename...', titleController: _titleController),
                          SaveButton(text: 'Erstellen', saveBtnController: _createCategorieBtnController, onPressed: () => _createAccount(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
