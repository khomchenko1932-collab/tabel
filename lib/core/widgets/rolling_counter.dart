import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Анимированное число-одометр (прокрутка при обновлении данных).
class RollingCounter extends StatelessWidget {
  const RollingCounter(
    this.value, {
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 600),
  });

  final int value;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) => AnimatedFlipCounter(
        value: value,
        duration: duration,
        curve: Curves.easeOutCubic,
        textStyle: style ?? AppTypography.counter,
      );
}
