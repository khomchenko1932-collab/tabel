import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database/app_database.dart';

String _pad(int n) => n.toString().padLeft(2, '0');

/// Выгружает полный снимок базы в файл `.tbl` и открывает системный шэринг.
/// Если задан [password] — файл шифруется (AES-GCM); без пароля читать нельзя.
/// Возвращает true при успехе. Вызывается только из Настроек — за PIN-экраном.
Future<bool> exportTblBackup(AppDatabase db, {String? password}) async {
  File? file;
  try {
    var json = await db.exportJson();
    if (password != null && password.isNotEmpty) {
      json = encryptTbl(json, password);
    }
    final d = DateTime.now();
    final name = 'tabel_${d.year}${_pad(d.month)}${_pad(d.day)}.tbl';
    final dir = await getTemporaryDirectory();
    file = File('${dir.path}/$name');
    // Пишем явно в UTF-8, чтобы кириллица читалась на любом устройстве.
    await file.writeAsBytes(utf8.encode(json));
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Данные приложения «Табель»'),
    );
    return true;
  } catch (_) {
    return false;
  } finally {
    // Не оставляем незашифрованный снимок в temp-каталоге: после шэринга
    // копия уже у получателя, локальный файл больше не нужен.
    try {
      if (file != null && file.existsSync()) file.deleteSync();
    } catch (_) {/* не критично */}
  }
}

// ─────────────────────── Шифрование файла переноса ───────────────────────
//
// Конверт v2: AES-256-GCM (шифрование + контроль целостности: подмена или
// повреждение файла обнаруживаются при расшифровке), PBKDF2 120 000 итераций.
// Конверт v1 (старые файлы): AES-CBC, 60 000 итераций — читаем, но не пишем.

const int _kIterationsV2 = 120000;
const int _kIterationsV1 = 60000;

/// PBKDF2-HMAC-SHA256 → 32-байтовый ключ из пароля и соли.
Uint8List _deriveKey(String password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, utf8.encode(password));
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final result = List<int>.from(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < result.length; j++) {
      result[j] ^= u[j];
    }
  }
  return Uint8List.fromList(result);
}

Uint8List _randomBytes(int n) {
  final r = Random.secure();
  return Uint8List.fromList(List<int>.generate(n, (_) => r.nextInt(256)));
}

/// Зашифровать JSON-снимок паролем. Возвращает JSON-конверт `tabel-enc` v2.
String encryptTbl(String json, String password) {
  final salt = _randomBytes(16);
  final key = enc.Key(_deriveKey(password, salt, _kIterationsV2));
  final iv = enc.IV(_randomBytes(12)); // 96-битный nonce — стандарт для GCM
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
  final data = encrypter.encrypt(json, iv: iv).base64;
  return jsonEncode({
    'app': 'tabel-enc',
    'v': 2,
    'salt': base64Encode(salt),
    'iv': base64Encode(iv.bytes),
    'data': data,
  });
}

/// Является ли содержимое зашифрованным конвертом.
bool isEncryptedTbl(String content) {
  try {
    final m = jsonDecode(content);
    return m is Map && m['app'] == 'tabel-enc';
  } catch (_) {
    return false;
  }
}

/// Расшифровать конверт (v2 GCM или старый v1 CBC).
/// Бросает [FormatException] при неверном пароле/формате/подделке.
String decryptTbl(String content, String password) {
  try {
    final m = jsonDecode(content) as Map<String, dynamic>;
    final v = m['v'] as int? ?? 1;
    final salt = base64Decode(m['salt'] as String);
    final iv = enc.IV(base64Decode(m['iv'] as String));
    final mode = v >= 2 ? enc.AESMode.gcm : enc.AESMode.cbc;
    final iterations = v >= 2 ? _kIterationsV2 : _kIterationsV1;
    final key = enc.Key(_deriveKey(password, salt, iterations));
    final encrypter = enc.Encrypter(enc.AES(key, mode: mode));
    return encrypter.decrypt(enc.Encrypted.fromBase64(m['data'] as String), iv: iv);
  } catch (_) {
    throw const FormatException('Неверный пароль или повреждённый файл');
  }
}
