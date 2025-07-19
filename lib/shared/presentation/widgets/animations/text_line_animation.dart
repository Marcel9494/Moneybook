import 'package:flutter/material.dart';

class TextLineAnimation extends StatefulWidget {
  final String text;
  final int letterDelayInMilliseconds;
  final TextStyle? style;
  final double offsetX;

  const TextLineAnimation({
    super.key,
    required this.text,
    this.letterDelayInMilliseconds = 30,
    this.style,
    this.offsetX = 40.0,
  });

  @override
  State<TextLineAnimation> createState() => _TextLineAnimationState();
}

class _TextLineAnimationState extends State<TextLineAnimation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(widget.text.length, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.text.length * widget.letterDelayInMilliseconds),
      );
    });
    _fadeAnimations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            ),
          ),
        )
        .toList();
    _slideAnimations = _controllers
        .map(
          (controller) => Tween<Offset>(begin: Offset(widget.offsetX / 100, 0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            ),
          ),
        )
        .toList();

    _runAnimations();
  }

  Future<void> _runAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: widget.letterDelayInMilliseconds));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: Text(
              widget.text[index],
              style: widget.style,
            ),
          ),
        );
      }),
    );
  }
}
