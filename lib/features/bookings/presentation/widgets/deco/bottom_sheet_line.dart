import 'package:flutter/material.dart';

class BottomSheetLine extends StatelessWidget {
  const BottomSheetLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: Center(
        child: Container(
          width: 54.0,
          height: 3.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
