import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/presentation/common/backup.dart';

/// Собирает конверт СТАРОГО формата v1 (AES-CBC, PBKDF2 60k) так же, как
/// это делала прошлая версия приложения — для проверки обратной совместимости.
String _legacyEncryptV1(String json, String password) {
  Uint8List deriveKey(String password, List<int> salt) {
    final hmac = Hmac(sha256, utf8.encode(password));
    var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
    final result = List<int>.from(u);
    for (var i = 1; i < 60000; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }
    return Uint8List.fromList(result);
  }

  final salt = List<int>.generate(16, (i) => i * 7 % 256);
  final key = enc.Key(deriveKey(password, salt));
  final iv = enc.IV(Uint8List.fromList(List<int>.generate(16, (i) => i)));
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final data = encrypter.encrypt(json, iv: iv).base64;
  return jsonEncode({
    'app': 'tabel-enc',
    'v': 1,
    'salt': base64Encode(salt),
    'iv': base64Encode(iv.bytes),
    'data': data,
  });
}

void main() {
  const json = '{"app":"tabel","version":5,"personnel":[{"lastName":"Тест"}]}';

  group('Шифрование .tbl (v2, AES-GCM)', () {
    test('конверт распознаётся как зашифрованный и имеет v=2', () {
      final e = encryptTbl(json, 'секрет123');
      expect(isEncryptedTbl(e), isTrue);
      expect(isEncryptedTbl(json), isFalse);
      expect((jsonDecode(e) as Map)['v'], 2);
    });

    test('верный пароль → исходный JSON (round-trip)', () {
      final e = encryptTbl(json, 'секрет123');
      expect(decryptTbl(e, 'секрет123'), json);
    });

    test('в зашифрованном тексте нет открытых данных', () {
      final e = encryptTbl(json, 'секрет123');
      expect(e.contains('Тест'), isFalse);
      expect(e.contains('personnel'), isFalse);
    });

    test('неверный пароль → FormatException', () {
      final e = encryptTbl(json, 'секрет123');
      expect(() => decryptTbl(e, 'другой'), throwsA(isA<FormatException>()));
    });

    test('подделка шифртекста → FormatException (GCM ловит подмену)', () {
      final m = jsonDecode(encryptTbl(json, 'p')) as Map<String, dynamic>;
      final bytes = base64Decode(m['data'] as String);
      bytes[bytes.length ~/ 2] ^= 0xFF; // портим байт в середине
      m['data'] = base64Encode(bytes);
      expect(() => decryptTbl(jsonEncode(m), 'p'),
          throwsA(isA<FormatException>()));
    });

    test('два шифрования одного текста дают разный результат (случайные соль/IV)', () {
      expect(encryptTbl(json, 'p'), isNot(encryptTbl(json, 'p')));
    });

    test('старый конверт v1 (CBC) по-прежнему читается', () {
      final legacy = _legacyEncryptV1(json, 'старыйПароль');
      expect(decryptTbl(legacy, 'старыйПароль'), json);
      expect(() => decryptTbl(legacy, 'другой'),
          throwsA(isA<FormatException>()));
    });
  });
}
