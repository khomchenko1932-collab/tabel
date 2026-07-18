import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

/// Ключи настроек.
abstract final class SettingsKeys {
  static const onboardingDone = 'onboarding_done';
  static const lockEnabled = 'lock_enabled';
  static const pinHash = 'pin_hash';
  static const pinSalt = 'pin_salt';
  static const unitName = 'unit_name';
  static const lockFailCount = 'lock_fail_count';
  static const lockUntilMs = 'lock_until_ms';
  static const demoHintDismissed = 'demo_hint_dismissed';
}

/// Число итераций PBKDF2 (компромисс между стойкостью и скоростью на телефоне).
const int _kPbkdf2Iterations = 120000;

/// После скольких неудачных попыток начинается временная блокировка ввода.
const int _kFailThreshold = 5;

/// Нарастающие задержки блокировки (сек) после превышения порога.
const List<int> _kLockoutSteps = [30, 60, 300, 900]; // 30с, 1м, 5м, 15м

/// Разобранные настройки приложения.
class AppSettings {
  const AppSettings({
    required this.onboardingDone,
    required this.lockEnabled,
    required this.pinHash,
    required this.pinSalt,
    required this.unitName,
    this.failCount = 0,
    this.lockUntilMs = 0,
    this.demoHintDismissed = false,
  });

  final bool onboardingDone;
  final bool lockEnabled;
  final String? pinHash;
  final String? pinSalt;
  final String unitName;
  final int failCount;
  final int lockUntilMs;
  final bool demoHintDismissed;

  /// Секунды до конца временной блокировки (0 — можно вводить).
  int lockoutRemaining({DateTime? now}) {
    final ms = (now ?? DateTime.now()).millisecondsSinceEpoch;
    if (lockUntilMs <= ms) return 0;
    return ((lockUntilMs - ms) / 1000).ceil();
  }

  factory AppSettings.fromMap(Map<String, String> m) => AppSettings(
        onboardingDone: m[SettingsKeys.onboardingDone] == '1',
        lockEnabled: m[SettingsKeys.lockEnabled] == '1',
        pinHash: (m[SettingsKeys.pinHash]?.isEmpty ?? true)
            ? null
            : m[SettingsKeys.pinHash],
        pinSalt: (m[SettingsKeys.pinSalt]?.isEmpty ?? true)
            ? null
            : m[SettingsKeys.pinSalt],
        unitName: m[SettingsKeys.unitName]?.trim() ?? '',
        failCount: int.tryParse(m[SettingsKeys.lockFailCount] ?? '') ?? 0,
        lockUntilMs: int.tryParse(m[SettingsKeys.lockUntilMs] ?? '') ?? 0,
        demoHintDismissed: m[SettingsKeys.demoHintDismissed] == '1',
      );
}

/// PBKDF2-HMAC-SHA256, один блок (длина ключа = 32 байта = размер SHA-256).
List<int> _pbkdf2(List<int> password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, password);
  // INT_32_BE(1) в конце соли — номер блока.
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final result = List<int>.from(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < result.length; j++) {
      result[j] ^= u[j];
    }
  }
  return result;
}

/// Хэш PIN-кода с индивидуальной солью (PBKDF2-HMAC-SHA256).
String hashPin(String pin, String salt) =>
    base64Encode(_pbkdf2(utf8.encode(pin), utf8.encode(salt), _kPbkdf2Iterations));

/// Старая схема (единая соль, один SHA-256) — только для входа на установках,
/// заведённых до появления индивидуальной соли.
String _legacyHash(String pin) =>
    sha256.convert(utf8.encode('narmb-ls:$pin')).toString();

/// Случайная соль на установку (16 байт из криптостойкого генератора).
String _newSalt() {
  final r = Random.secure();
  return base64Encode(List<int>.generate(16, (_) => r.nextInt(256)));
}

final settingsMapProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(appDatabaseProvider).watchSettings(),
);

final settingsProvider = Provider<AsyncValue<AppSettings>>(
  (ref) => ref.watch(settingsMapProvider).whenData(AppSettings.fromMap),
);

/// Пока true — авто-блокировку при уходе в фон НЕ выполняем. Ставится на время
/// системного выбора файла / шэринга (это не «сворачивание» пользователем,
/// иначе импорт/экспорт ломается: приложение блокируется под выбором файла).
final systemPickerActiveProvider = NotifierProvider<SystemPickerNotifier, bool>(
    SystemPickerNotifier.new);

class SystemPickerNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  set active(bool v) => state = v;
}

/// Заблокировано ли приложение сейчас (эфемерно, стартует «заблокировано»).
final lockedProvider = NotifierProvider<LockedNotifier, bool>(LockedNotifier.new);

class LockedNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void unlock() => state = false;
  void lock() => state = true;
}

/// Действия над настройками.
class SettingsActions {
  SettingsActions(this.ref);
  final Ref ref;

  Future<void> _set(String k, String v) =>
      ref.read(appDatabaseProvider).setSetting(k, v);

  Future<void> completeOnboarding() => _set(SettingsKeys.onboardingDone, '1');

  Future<void> setPin(String pin) async {
    final salt = _newSalt();
    await _set(SettingsKeys.pinSalt, salt);
    await _set(SettingsKeys.pinHash, hashPin(pin, salt));
    await _set(SettingsKeys.lockEnabled, '1');
    await resetFailedAttempts();
  }

  Future<void> disableLock() async {
    await _set(SettingsKeys.lockEnabled, '0');
    await _set(SettingsKeys.pinHash, '');
    await _set(SettingsKeys.pinSalt, '');
    await resetFailedAttempts();
  }

  Future<void> setUnitName(String name) => _set(SettingsKeys.unitName, name);

  Future<void> dismissDemoHint() => _set(SettingsKeys.demoHintDismissed, '1');

  bool verifyPin(String pin, String? hash, String? salt) {
    if (hash == null || hash.isEmpty) return false;
    if (salt != null && salt.isNotEmpty) return hashPin(pin, salt) == hash;
    // Установка до появления соли — сверяем по старой схеме.
    return _legacyHash(pin) == hash;
  }

  /// Зафиксировать неудачную попытку и, при превышении порога, назначить
  /// временную блокировку с нарастающей задержкой. Возвращает секунды локаута.
  Future<int> registerFailedAttempt() async {
    final fails = (ref.read(settingsProvider).value?.failCount ?? 0) + 1;
    await _set(SettingsKeys.lockFailCount, '$fails');
    if (fails < _kFailThreshold) return 0;
    final idx = (fails - _kFailThreshold).clamp(0, _kLockoutSteps.length - 1);
    final seconds = _kLockoutSteps[idx];
    final until = DateTime.now().millisecondsSinceEpoch + seconds * 1000;
    await _set(SettingsKeys.lockUntilMs, '$until');
    return seconds;
  }

  Future<void> resetFailedAttempts() async {
    await _set(SettingsKeys.lockFailCount, '0');
    await _set(SettingsKeys.lockUntilMs, '0');
  }
}

final settingsActionsProvider = Provider((ref) => SettingsActions(ref));
