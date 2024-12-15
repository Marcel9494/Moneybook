import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
