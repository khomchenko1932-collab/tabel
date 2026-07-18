// Применяет выбранную иконку One UI (вариант B «строй», палитра «графит»):
//  - assets/icon/icon.png       — легаси-иконка (squircle + градиент + глиф)
//  - assets/icon/bg.png         — фон адаптивной иконки (полный квадрат, градиент)
//  - assets/icon/foreground.png — передний план (глиф на прозрачном)
// Запуск: dart run tool/apply_oneui_icon.dart
import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

const int out = 1024;
const int ss = 2;
const int S = out * ss;

// Палитра «графит»: тёмный градиент + акцентно-зелёный глиф.
const c0 = [58, 74, 62]; // верх-лево
const c1 = [15, 19, 16]; // низ-право
const glyphColor = [126, 200, 122]; // #7EC87A

double rrect(double px, double py, double cx, double cy, double hw, double hh, double r) {
  final dx = (px - cx).abs() - (hw - r);
  final dy = (py - cy).abs() - (hh - r);
  final ax = dx > 0 ? dx : 0.0;
  final ay = dy > 0 ? dy : 0.0;
  return sqrt(ax * ax + ay * ay) - r + min(max(dx, dy), 0.0);
}

double circle(double px, double py, double cx, double cy, double r) =>
    sqrt(pow(px - cx, 2) + pow(py - cy, 2)) - r;

/// Глиф «строй»: три фигуры (голова + корпус), центральная крупнее.
double glyph(double x, double y) {
  const c = S / 2.0;
  double fig(double fx, double scale) {
    final head = circle(x, y, fx, c - S * 0.15 * scale, S * 0.052 * scale);
    final body = rrect(x, y, fx, c + S * 0.06 * scale, S * 0.062 * scale,
        S * 0.105 * scale, S * 0.06 * scale);
    return min(head, body);
  }

  return min(fig(c, 1.08), min(fig(c - S * 0.165, 0.9), fig(c + S * 0.165, 0.9)));
}

List<int> gradientAt(int x, int y) {
  final t = ((x + y) / (2 * S)).clamp(0.0, 1.0);
  return [
    (c0[0] + (c1[0] - c0[0]) * t).round(),
    (c0[1] + (c1[1] - c0[1]) * t).round(),
    (c0[2] + (c1[2] - c0[2]) * t).round(),
  ];
}

img.Image _down(img.Image im) => img.copyResize(im,
    width: out, height: out, interpolation: img.Interpolation.average);

void main() {
  const n = 4.2; // squircle
  const c = S / 2.0;

  final icon = img.Image(width: S, height: S, numChannels: 4);
  final bg = img.Image(width: S, height: S, numChannels: 4);
  final fg = img.Image(width: S, height: S, numChannels: 4);

  for (var y = 0; y < S; y++) {
    for (var x = 0; x < S; x++) {
      final g = gradientAt(x, y);
      final inGlyph = glyph(x.toDouble(), y.toDouble()) <= 0;

      // Фон адаптивной иконки — полный квадрат с градиентом (без маски).
      bg.setPixelRgba(x, y, g[0], g[1], g[2], 255);

      // Передний план — только глиф на прозрачном.
      if (inGlyph) {
        fg.setPixelRgba(x, y, glyphColor[0], glyphColor[1], glyphColor[2], 255);
      } else {
        fg.setPixelRgba(x, y, 0, 0, 0, 0);
      }

      // Легаси-иконка — squircle с градиентом и глифом.
      final nx = (x - c) / c, ny = (y - c) / c;
      if (pow(nx.abs(), n) + pow(ny.abs(), n) > 1.0) {
        icon.setPixelRgba(x, y, 0, 0, 0, 0);
      } else if (inGlyph) {
        icon.setPixelRgba(x, y, glyphColor[0], glyphColor[1], glyphColor[2], 255);
      } else {
        icon.setPixelRgba(x, y, g[0], g[1], g[2], 255);
      }
    }
  }

  File('assets/icon/icon.png').writeAsBytesSync(img.encodePng(_down(icon)));
  File('assets/icon/bg.png').writeAsBytesSync(img.encodePng(_down(bg)));
  File('assets/icon/foreground.png').writeAsBytesSync(img.encodePng(_down(fg)));
  stdout.writeln('Готово: icon.png, bg.png, foreground.png (One UI «строй», графит)');
}
