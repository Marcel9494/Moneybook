import 'package:flutter/material.dart';

class TextFadeAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;

  const TextFadeAnimation({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<TextFadeAnimation> createState() => _TextFadeAnimationState();
}

class _TextFadeAnimationState extends State<TextFadeAnimation> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      opacity: _opacity,
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
