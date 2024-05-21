import 'package:flutter/material.dart';

import 'bottom_sheet_line.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final bool showCloseButton;

  const BottomSheetHeader({
    super.key,
    required this.title,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BottomSheetLine(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 28.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 20.0)),
              showCloseButton
                  ? IconButton(
                      iconSize: 26.0,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
