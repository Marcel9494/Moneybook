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
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(child: BottomSheetLine()),
              showCloseButton
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          iconSize: 26.0,
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => {
                            Navigator.pop(context),
                          },
                        ),
                      ),
                    )
                  : const Expanded(child: SizedBox(height: 36.0)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 28.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
