import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/categorie_bloc.dart';
import '../cards/categorie_card.dart';

class CategorieListView extends StatelessWidget {
  const CategorieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorieBloc, CategorieState>(
      builder: (context, state) {
        if (state is Loaded) {
          return ListView.builder(
            itemCount: state.categorie.length,
            itemBuilder: (BuildContext context, int index) {
              return CategorieCard(categorie: state.categorie[index]);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
