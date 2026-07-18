// Генератор превью иконок в стиле One UI (squircle + градиент + белый глиф).
// Рисуем в 2x и уменьшаем — получаем сглаживание.
// Запуск: dart run tool/gen_oneui_icons.dart
import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

const int out = 1024; // финальный размер
const int ss = 2; // суперсэмплинг
const int S = out * ss;

class Palette {
  const Palette(this.name, this.c0, this.c1, this.glyph);
  final String name;
  final List<int> c0; // верх-лево
  final List<int> c1; // низ-право
  final List<int> glyph;
}

const palettes = [
  Palette('green', [143, 227, 155], [30, 122, 76], [255, 255, 255]),
  Palette('graphite', [58, 74, 62], [15, 19, 16], [126, 200, 122]),
];

// ── SDF-хелперы (координаты в пикселях канвы S) ──
double rrect(double px, double py, double cx, double cy, double hw, double hh, double r) {
  final dx = (px - cx).abs() - (hw - r);
  final dy = (py - cy).abs() - (hh - r);
  final ax = dx > 0 ? dx : 0.0;
  final ay = dy > 0 ? dy : 0.0;
  return sqrt(ax * ax + ay * ay) - r + min(max(dx, dy), 0.0);
}

double circle(double px, double py, double cx, double cy, double r) =>
    sqrt(pow(px - cx, 2) + pow(py - cy, 2)) - r;

double seg(double px, double py, double ax, double ay, double bx, double by, double t) {
  final vx = bx - ax, vy = by - ay;
  final wx = px - ax, wy = py - ay;
  final len2 = vx * vx + vy * vy;
  var u = len2 == 0 ? 0.0 : (wx * vx + wy * vy) / len2;
  u = u.clamp(0.0, 1.0);
  final qx = ax + u * vx, qy = ay + u * vy;
  return sqrt(pow(px - qx, 2) + pow(py - qy, 2)) - t / 2;
}

/// Щит: прямоугольник со скруглённым верхом, сужающийся к низу.
double shield(double px, double py, double cx, double cy, double hw, double hh) {
  final top = cy - hh, bot = cy + hh;
  if (py < top || py > bot) return 1;
  final t = (py - top) / (2 * hh);
  double half;
  if (t < 0.45) {
    half = hw;
  } else {
    final k = (t - 0.45) / 0.55;
    half = hw * sqrt(max(0.0, 1 - k * k));
  }
  // Скругление верхних углов.
  if (t < 0.12) {
    final r = hw * 0.35;
    final dy = (top + r) - py;
    if (dy > 0) {
      final dx = (px - cx).abs() - (hw - r);
      if (dx > 0) return sqrt(dx * dx + dy * dy) - r;
    }
  }
  return (px - cx).abs() - half;
}

typedef Glyph = double Function(double x, double y);

/// Возвращает SDF глифа (<=0 — внутри) для варианта.
Glyph glyphFor(String v) {
  const c = S / 2.0;
  switch (v) {
    case 'A': // Монограмма «Т»
      return (x, y) => min(
            rrect(x, y, c, c - S * 0.13, S * 0.20, S * 0.055, S * 0.05),
            rrect(x, y, c, c + S * 0.07, S * 0.055, S * 0.20, S * 0.05),
          );
    case 'B': // Строй: три фигуры
      return (x, y) {
        double fig(double fx, double scale) {
          final head = circle(x, y, fx, c - S * 0.15 * scale, S * 0.052 * scale);
          final body = rrect(x, y, fx, c + S * 0.06 * scale, S * 0.062 * scale,
              S * 0.105 * scale, S * 0.06 * scale);
          return min(head, body);
        }
        return min(fig(c, 1.08), min(fig(c - S * 0.165, 0.9), fig(c + S * 0.165, 0.9)));
      };
    case 'C': // Табель: доска со списком (строки — вырезом)
      return (x, y) {
        final board = rrect(x, y, c, c + S * 0.02, S * 0.225, S * 0.265, S * 0.05);
        final clip = rrect(x, y, c, c - S * 0.245, S * 0.09, S * 0.038, S * 0.03);
        var s = min(board, clip);
        // Вырезаем 3 строки: квадрат + линия.
        for (var i = -1; i <= 1; i++) {
          final ry = c + S * 0.02 + i * S * 0.105;
          final box = rrect(x, y, c - S * 0.135, ry, S * 0.028, S * 0.028, S * 0.009);
          final line = rrect(x, y, c + S * 0.045, ry, S * 0.085, S * 0.019, S * 0.009);
          s = max(s, -min(box, line)); // вычитание
        }
        return s;
      };
    default: // 'D' — щит с галочкой (галочка вырезом)
      return (x, y) {
        final sh = shield(x, y, c, c + S * 0.01, S * 0.235, S * 0.275);
        final ck = min(
          seg(x, y, c - S * 0.10, c + S * 0.005, c - S * 0.02, c + S * 0.085, S * 0.055),
          seg(x, y, c - S * 0.02, c + S * 0.085, c + S * 0.115, c - S * 0.10, S * 0.055),
        );
        return max(sh, -ck);
      };
  }
}

void main() {
  final dir = Directory(r'C:\Users\user\Desktop\tabel_icons');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  const n = 4.2; // степень суперэллипса (squircle One UI)
  const c = S / 2.0;

  for (final v in ['A', 'B', 'C', 'D']) {
    final g = glyphFor(v);
    for (final p in palettes) {
      final im = img.Image(width: S, height: S, numChannels: 4);
      for (var y = 0; y < S; y++) {
        for (var x = 0; x < S; x++) {
          final nx = (x - c) / c, ny = (y - c) / c;
          if (pow(nx.abs(), n) + pow(ny.abs(), n) > 1.0) {
            im.setPixelRgba(x, y, 0, 0, 0, 0); // вне squircle — прозрачно
            continue;
          }
          final t = ((x + y) / (2 * S)).clamp(0.0, 1.0);
          var r = (p.c0[0] + (p.c1[0] - p.c0[0]) * t).round();
          var gg = (p.c0[1] + (p.c1[1] - p.c0[1]) * t).round();
          var b = (p.c0[2] + (p.c1[2] - p.c0[2]) * t).round();
          if (g(x.toDouble(), y.toDouble()) <= 0) {
            r = p.glyph[0];
            gg = p.glyph[1];
            b = p.glyph[2];
          }
          im.setPixelRgba(x, y, r, gg, b, 255);
        }
      }
      final small = img.copyResize(im,
          width: out, height: out, interpolation: img.Interpolation.average);
      final f = File('${dir.path}\\oneui_${v}_${p.name}.png');
      f.writeAsBytesSync(img.encodePng(small));
      stdout.writeln('готово: ${f.path}');
    }
  }
  stdout.writeln('\nВсе превью в: ${dir.path}');
}
