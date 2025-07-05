import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  final String title;
  final String description;

  const GoalCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
