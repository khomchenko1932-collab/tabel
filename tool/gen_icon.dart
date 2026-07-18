import 'dart:io';

import 'package:image/image.dart' as img;

/// Генерирует иконку приложения «Тактический графит»: зелёный прицельный
/// знак (кольцо + перекрестье + центр) на графитовом фоне.
void main() {
  Directory('assets/icon').createSync(recursive: true);
  _gen(withBackground: true, scale: 0.60, path: 'assets/icon/icon.png');
  _gen(withBackground: false, scale: 0.52, path: 'assets/icon/foreground.png');
  stdout.writeln('Готово: assets/icon/icon.png, foreground.png');
}

void _gen({required bool withBackground, required double scale, required String path}) {
  const size = 1024;
  final image = img.Image(width: size, height: size, numChannels: 4);
  final transparent = img.ColorRgba8(0, 0, 0, 0);
  img.fill(image, color: transparent);

  const graphiteTop = [0x22, 0x28, 0x1A];
  const graphiteBottom = [0x0C, 0x0E, 0x0A];
  final green = img.ColorRgba8(0x7E, 0xC8, 0x7A, 255);
  final greenBright = img.ColorRgba8(0x9A, 0xE0, 0x95, 255);

  if (withBackground) {
    // Вертикальный градиент графита.
    for (var y = 0; y < size; y++) {
      final t = y / size;
      final r = _lerp(graphiteTop[0], graphiteBottom[0], t);
      final g = _lerp(graphiteTop[1], graphiteBottom[1], t);
      final b = _lerp(graphiteTop[2], graphiteBottom[2], t);
      final c = img.ColorRgba8(r, g, b, 255);
      for (var x = 0; x < size; x++) {
        image.setPixel(x, y, c);
      }
    }
    // Точечная сетка (dot-matrix) как в приложении.
    final dot = img.ColorRgba8(0x38, 0x50, 0x3A, 110);
    for (var y = 40; y < size; y += 46) {
      for (var x = 40; x < size; x += 46) {
        img.fillCircle(image, x: x, y: y, radius: 3, color: dot);
      }
    }
  }

  final cx = size ~/ 2;
  final cy = size ~/ 2;
  final base = (size / 2 * scale);
  final outerR = base.round();
  final ringThick = (base * 0.14).round();
  final innerR = outerR - ringThick;

  // Внешнее кольцо (набор концентрических окружностей — работает и на прозрачном фоне).
  for (var r = innerR; r <= outerR; r++) {
    img.drawCircle(image, x: cx, y: cy, radius: r, color: green, antialias: true);
  }

  // Перекрестье: 4 засечки от кольца к центру с зазором.
  final tickOuter = (innerR - base * 0.02).round();
  final tickInner = (base * 0.30).round();
  final tickW = (base * 0.10).round();
  // верх/низ
  img.fillRect(image,
      x1: cx - tickW ~/ 2, y1: cy - tickOuter, x2: cx + tickW ~/ 2, y2: cy - tickInner, color: green);
  img.fillRect(image,
      x1: cx - tickW ~/ 2, y1: cy + tickInner, x2: cx + tickW ~/ 2, y2: cy + tickOuter, color: green);
  // лево/право
  img.fillRect(image,
      x1: cx - tickOuter, y1: cy - tickW ~/ 2, x2: cx - tickInner, y2: cy + tickW ~/ 2, color: green);
  img.fillRect(image,
      x1: cx + tickInner, y1: cy - tickW ~/ 2, x2: cx + tickOuter, y2: cy + tickW ~/ 2, color: green);

  // Центральная точка со свечением.
  final dotR = (base * 0.17).round();
  img.fillCircle(image, x: cx, y: cy, radius: dotR + 6, color: img.ColorRgba8(0x7E, 0xC8, 0x7A, 90));
  img.fillCircle(image, x: cx, y: cy, radius: dotR, color: greenBright);

  File(path).writeAsBytesSync(img.encodePng(image));
}

int _lerp(int a, int b, double t) => (a + (b - a) * t).round().clamp(0, 255);
