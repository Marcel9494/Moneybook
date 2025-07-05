import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../buttons/more_info_button.dart';

class CalculatorCard extends StatefulWidget {
  final String title;
  final String description;
  final String route;

  const CalculatorCard({
    super.key,
    required this.title,
    required this.description,
    required this.route,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, widget.route),
      child: Card(
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.cyanAccent, width: 3.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.8,
                    height: 16.0,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                  ),
                  MoreInfoButton(text: AppLocalizations.of(context).translate("mehr_info")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
