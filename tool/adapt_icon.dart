import 'dart:io';

import 'package:image/image.dart' as img;

/// Готовит иконку из присланного PNG «Табель»:
/// - icon.png (1024×1024) — легаси-иконка целиком;
/// - foreground.png (1024×1024) — дизайн вписан в safe-zone адаптивной иконки
///   на прозрачном фоне (фон задаётся цветом в flutter_launcher_icons).
void main() {
  final src = img.decodePng(File('assets/icon/source_tabel.png').readAsBytesSync());
  if (src == null) {
    stderr.writeln('Не удалось прочитать source_tabel.png');
    exit(1);
  }
  stdout.writeln('Источник: ${src.width}x${src.height}');

  // Легаси-иконка: подгон к квадрату 1024.
  final icon = img.copyResize(src,
      width: 1024, height: 1024, interpolation: img.Interpolation.cubic);
  File('assets/icon/icon.png').writeAsBytesSync(img.encodePng(icon));

  // Адаптивный передний план: полный дизайн (flutter_launcher_icons сам даёт
  // 16% inset → примерно safe-zone ~68%).
  File('assets/icon/foreground.png').writeAsBytesSync(img.encodePng(icon));

  stdout.writeln('Готово: icon.png, foreground.png');
}
