import 'package:flutter/material.dart';

import '../../../../../shared/presentation/widgets/deco/new_label.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isNew;

  const SettingCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(title),
            isNew ? NewLabel() : const SizedBox(),
          ],
        ),
        leading: Icon(icon),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
