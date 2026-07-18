import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../settings/settings_controller.dart';
import 'pin_keypad.dart';

/// Установка нового PIN: ввод + подтверждение. Возвращает true при успехе.
class SetPinScreen extends ConsumerStatefulWidget {
  const SetPinScreen({super.key});

  @override
  ConsumerState<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends ConsumerState<SetPinScreen> {
  String? _first;
  int _attempt = 0;

  @override
  Widget build(BuildContext context) {
    final confirming = _first != null;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.shield, color: AppColors.accentPrimary, size: 30),
                const SizedBox(height: AppDimens.lg),
                PinKeypad(
                  key: ValueKey('$confirming-$_attempt'),
                  title: confirming ? 'Повторите код' : 'Новый код',
                  subtitle: confirming
                      ? 'Введите тот же код ещё раз'
                      : 'Придумайте 4-значный код доступа',
                  onComplete: (pin) async {
                    if (_first == null) {
                      setState(() => _first = pin);
                    } else if (pin == _first) {
                      await ref.read(settingsActionsProvider).setPin(pin);
                      if (context.mounted) Navigator.pop(context, true);
                    } else {
                      setState(() {
                        _first = null;
                        _attempt++;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Коды не совпадают, попробуйте снова')),
                      );
                    }
                  },
                ),
                if (confirming) ...[
                  const SizedBox(height: AppDimens.md),
                  TextButton(
                    onPressed: () => setState(() {
                      _first = null;
                      _attempt++;
                    }),
                    child: Text('Начать заново',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
