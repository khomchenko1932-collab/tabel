import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';

/// Ввод PIN: заголовок, точки-индикаторы и цифровая клавиатура.
/// Вызывает [onComplete] по вводу [length] цифр и очищается.
class PinKeypad extends StatefulWidget {
  const PinKeypad({
    super.key,
    required this.title,
    this.subtitle,
    required this.onComplete,
    this.length = 4,
    this.errorSignal = 0,
  });

  final String title;
  final String? subtitle;
  final ValueChanged<String> onComplete;
  final int length;

  /// Изменение значения запускает анимацию ошибки и очистку.
  final int errorSignal;

  @override
  State<PinKeypad> createState() => _PinKeypadState();
}

class _PinKeypadState extends State<PinKeypad> with SingleTickerProviderStateMixin {
  String _pin = '';
  late final AnimationController _shake =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

  @override
  void didUpdateWidget(covariant PinKeypad old) {
    super.didUpdateWidget(old);
    if (widget.errorSignal != old.errorSignal) {
      setState(() => _pin = '');
      _shake.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _tap(String d) {
    if (_pin.length >= widget.length) return;
    setState(() => _pin += d);
    HapticFeedback.selectionClick();
    if (_pin.length == widget.length) {
      final v = _pin;
      // Небольшая пауза, чтобы последняя точка успела прорисоваться.
      Future.delayed(const Duration(milliseconds: 90), () => widget.onComplete(v));
    }
  }

  void _del() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.title, style: AppTypography.title, textAlign: TextAlign.center),
        if (widget.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(widget.subtitle!, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
        const SizedBox(height: AppDimens.xl),
        AnimatedBuilder(
          animation: _shake,
          builder: (_, child) {
            final dx = (_shake.value == 0) ? 0.0 : 8 * (1 - _shake.value) *
                (((_shake.value * 8).floor() % 2 == 0) ? 1 : -1);
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length ? AppColors.accentPrimary : Colors.transparent,
                    border: Border.all(color: AppColors.strokeStrong, width: 1.5),
                    boxShadow: i < _pin.length
                        ? [const BoxShadow(color: AppColors.accentPrimary, blurRadius: 8)]
                        : null,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.xxl),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', '⌫'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final k in row) _key(k),
            ],
          ),
      ],
    );
  }

  Widget _key(String k) {
    if (k.isEmpty) return const SizedBox(width: 76, height: 76);
    final isDel = k == '⌫';
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(38),
        onTap: () => isDel ? _del() : _tap(k),
        child: Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDel ? null : AppColors.panelGradient,
            border: Border.all(color: AppColors.stroke, width: 1),
          ),
          child: isDel
              ? Icon(AppIcons.backspace, color: AppColors.textSecondary, size: 24)
              : Text(k, style: AppTypography.counter.copyWith(fontSize: 28)),
        ),
      ),
    );
  }
}
