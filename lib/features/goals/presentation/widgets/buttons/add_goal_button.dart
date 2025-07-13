import 'package:flutter/material.dart';

import '../../../../../core/consts/route_consts.dart';
import '../../../../../core/utils/app_localizations.dart';

class AddGoalButton extends StatefulWidget {
  const AddGoalButton({super.key});

  @override
  State<AddGoalButton> createState() => _AddGoalButtonState();
}

class _AddGoalButtonState extends State<AddGoalButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, createGoalRoute),
        child: Container(
          height: 180.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.cyanAccent, width: 0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: Colors.cyanAccent,
                size: 32.0,
              ),
              Text(
                AppLocalizations.of(context).translate('ziel_hinzufügen'),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
