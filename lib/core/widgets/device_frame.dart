import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Рамка-«телефон» ТОЛЬКО для веб-превью на широком экране: приложение
/// показывается в центрированном bezel. На реальных устройствах (в т.ч.
/// планшетах) рамки нет — там работает адаптивная раскладка (NavigationRail).
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});

  final Widget child;

  static const double _innerWidth = 390;
  static const double _maxHeight = 860;
  static const double _bezel = 3;

  @override
  Widget build(BuildContext context) {
    // Только веб. На нативных платформах — без рамки (планшет получит рейл).
    if (!kIsWeb) return child;

    final media = MediaQuery.of(context);
    final size = media.size;

    // Узкий экран — обычный телефон, рамка не нужна.
    if (size.width <= 540) return child;

    final frameH = size.height.clamp(0.0, _maxHeight) - 24;
    final innerH = frameH - _bezel * 2;

    return ColoredBox(
      color: const Color(0xFF060704),
      child: Center(
        child: Container(
          width: _innerWidth + _bezel * 2,
          height: frameH,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(46),
            border: Border.all(color: const Color(0xFF23281E), width: _bezel),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 44,
                spreadRadius: 4,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: MediaQuery(
            data: media.copyWith(
              size: Size(_innerWidth, innerH),
              padding: EdgeInsets.zero,
              viewPadding: EdgeInsets.zero,
              viewInsets: EdgeInsets.zero,
            ),
            child: SizedBox(
              width: _innerWidth,
              height: innerH,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
