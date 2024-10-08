import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/widgets/buttons/create_button.dart';

class CreateRow extends StatelessWidget {
  final String title;
  final String buttonText;
  final String createRoute;
  final double leftPadding;

  const CreateRow({
    super.key,
    required this.title,
    required this.buttonText,
    required this.createRoute,
    required this.leftPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, 4.0, 12.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
          ),
          CreateButton(
            text: buttonText,
            createRoute: createRoute,
          ),
        ],
      ),
    );
  }
}
