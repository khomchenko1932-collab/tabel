import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Простой локальный журнал ошибок: последние сбои пишутся в файл на
/// устройстве (офлайн, без отправки куда-либо). Помогает разобраться, если
/// что-то упало — журнал можно посмотреть/переслать из настроек.
abstract final class ErrorLog {
  static const int _maxChars = 20000; // храним ~последние 20 КБ

  static Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/errors.log');
  }

  /// Дописать запись об ошибке (в начало файла, старое обрезаем).
  static Future<void> record(String message, [StackTrace? stack]) async {
    try {
      final f = await _file();
      final old = await f.exists() ? await f.readAsString() : '';
      final ts = DateTime.now().toIso8601String();
      var content = '[$ts] $message\n${stack ?? ''}\n----------\n$old';
      if (content.length > _maxChars) content = content.substring(0, _maxChars);
      await f.writeAsString(content);
    } catch (_) {
      // Логирование не должно само по себе ронять приложение.
    }
  }

  static Future<String> read() async {
    try {
      final f = await _file();
      return await f.exists() ? await f.readAsString() : '';
    } catch (_) {
      return '';
    }
  }

  static Future<String?> filePath() async {
    try {
      final f = await _file();
      return await f.exists() ? f.path : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    try {
      final f = await _file();
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
