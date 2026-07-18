import 'package:flutter_test/flutter_test.dart';
import 'package:narmb_ls/presentation/settings/settings_controller.dart';

void main() {
  group('hashPin (PBKDF2 + соль)', () {
    test('детерминирован при одной соли', () {
      expect(hashPin('1234', 'saltA'), hashPin('1234', 'saltA'));
    });

    test('разная соль → разный хэш (нет радужных таблиц)', () {
      expect(hashPin('1234', 'saltA'), isNot(hashPin('1234', 'saltB')));
    });

    test('разный PIN → разный хэш', () {
      expect(hashPin('1234', 'saltA'), isNot(hashPin('9999', 'saltA')));
    });

    test('хэш не содержит открытый PIN', () {
      expect(hashPin('1234', 'saltA').contains('1234'), isFalse);
    });
  });
}
