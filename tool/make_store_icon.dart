// Иконка 512×512 для карточки RuStore (даунскейл из icon.png 1024).
// Запуск: dart run tool/make_store_icon.dart
import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final src = img.decodePng(File('assets/icon/icon.png').readAsBytesSync())!;
  final out = img.copyResize(src, width: 512, height: 512,
      interpolation: img.Interpolation.average);
  File('docs/store_icon_512.png').writeAsBytesSync(img.encodePng(out));
  stdout.writeln('Готово: docs/store_icon_512.png (${out.width}x${out.height})');
}
