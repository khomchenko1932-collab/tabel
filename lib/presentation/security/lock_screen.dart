import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../providers/app_providers.dart';
import '../settings/settings_controller.dart';
import 'pin_keypad.dart';

/// Экран блокировки: ввод PIN для входа.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  int _error = 0;
  int _remaining = 0; // секунды до конца временной блокировки
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _syncLockout(AppSettings? s) {
    if (!mounted) return;
    final left = s?.lockoutRemaining() ?? 0;
    // Активируем локаут из персистентного состояния только если он больше
    // текущего (не затираем уже идущий отсчёт из-за задержки стрима настроек).
    if (left > _remaining) {
      setState(() => _remaining = left);
      _startTicker();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _remaining -= 1;
        if (_remaining <= 0) t.cancel();
      });
    });
  }

  String _fmt(int sec) {
    final m = sec ~/ 60, s = sec % 60;
    if (m > 0) return '$m мин ${s.toString().padLeft(2, '0')} с';
    return '$s с';
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).value;
    final actions = ref.read(settingsActionsProvider);
    // Синхронизируем оставшийся локаут с персистентным состоянием
    // (переживает перезапуск приложения — обход рестартом закрыт).
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncLockout(s));
    final lockedOut = _remaining > 0;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.panelGradient,
                    borderRadius: BorderRadius.circular(AppDimens.rXl),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Icon(AppIcons.lock, color: AppColors.accentPrimary, size: 26),
                ),
                const SizedBox(height: AppDimens.md),
                Text('ТАБЕЛЬ · Л/С', style: AppTypography.kicker),
                const SizedBox(height: AppDimens.xl),
                if (lockedOut)
                  _lockoutPanel()
                else
                  PinKeypad(
                    title: 'Введите код',
                    subtitle: 'Доступ к личному составу',
                    errorSignal: _error,
                    onComplete: (pin) => _submit(actions, s, pin),
                  ),
                const SizedBox(height: AppDimens.lg),
                TextButton(
                  onPressed: _forgot,
                  child: Text('Забыли код?',
                      style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lockoutPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl, vertical: AppDimens.xxl),
      child: Column(
        children: [
          Icon(AppIcons.lock, color: AppColors.statusSick, size: 40),
          const SizedBox(height: AppDimens.md),
          Text('Слишком много попыток',
              style: AppTypography.title.copyWith(color: AppColors.statusSick),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('Повторите через ${_fmt(_remaining)}',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Future<void> _submit(SettingsActions actions, AppSettings? s, String pin) async {
    if (_remaining > 0) return;
    if (actions.verifyPin(pin, s?.pinHash, s?.pinSalt)) {
      await actions.resetFailedAttempts();
      ref.read(lockedProvider.notifier).unlock();
    } else {
      final lock = await actions.registerFailedAttempt();
      if (!mounted) return;
      setState(() {
        _error++;
        if (lock > 0) {
          _remaining = lock;
          _startTicker();
        }
      });
    }
  }

  Future<void> _forgot() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Сбросить код?', style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text(
          'Восстановить забытый код нельзя — всё хранится офлайн. Снять блокировку '
          'можно только вместе с удалением ВСЕХ данных.\n\n'
          'Резервную копию (.tbl) с заблокированного экрана сохранить нельзя — '
          'иначе код ничего бы не защищал. Копию нужно делать заранее, в Настройках.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'wipe'),
            child: Text('Удалить всё', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
    if (choice == 'wipe') {
      final confirmed = await _confirmWipe();
      if (confirmed != true) return;
      await ref.read(appDatabaseProvider).wipeAll();
      await ref.read(settingsActionsProvider).disableLock();
      ref.read(lockedProvider.notifier).unlock();
    }
  }

  Future<bool?> _confirmWipe() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Точно удалить всё?',
            style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text(
          'Все должности, фамилии, награды, отпуска, командировки и вооружение '
          'будут удалены безвозвратно. Отменить нельзя.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Удалить всё', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
  }
}
