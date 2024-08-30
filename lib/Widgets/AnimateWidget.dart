import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimateWidget extends StatelessWidget {
  final Widget widget;
  const AnimateWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(
            duration: Duration(milliseconds: 800), curve: Curves.easeInOut),
        MoveEffect(duration: Duration(milliseconds: 900), curve: Curves.easeIn)
      ],
      child: widget,
    );
  }
}
