import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/error_log.dart';
import '../../core/widgets/app_icons.dart';
import '../common/backup.dart';
import '../../core/widgets/n_fields.dart';
import '../../core/widgets/n_panel.dart';
import '../../core/widgets/n_section_header.dart';
import '../providers/app_providers.dart';
import '../security/set_pin_screen.dart';
import 'archive_screen.dart';
import 'settings_controller.dart';

/// Экран настроек приложения.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _unit = TextEditingController();
  bool _unitInit = false;

  @override
  void dispose() {
    _unit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).value;
    final actions = ref.read(settingsActionsProvider);
    if (s != null && !_unitInit) {
      _unit.text = s.unitName;
      _unitInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.xxl),
        children: [
          const NSectionHeader('Безопасность', color: AppColors.accentPrimary),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.lock, size: 18, color: AppColors.accentDim),
                      const SizedBox(width: AppDimens.md),
                      Expanded(child: Text('Блокировка кодом', style: AppTypography.body)),
                      Switch(
                        value: s?.lockEnabled ?? false,
                        activeThumbColor: AppColors.bgPage,
                        activeTrackColor: AppColors.accentPrimary,
                        inactiveThumbColor: AppColors.textTertiary,
                        inactiveTrackColor: AppColors.bgLcd,
                        onChanged: (v) async {
                          if (v) {
                            final ok = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(builder: (_) => const SetPinScreen()),
                            );
                            if (ok == true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Код установлен')),
                              );
                            }
                          } else {
                            await actions.disableLock();
                          }
                        },
                      ),
                    ],
                  ),
                  if (s?.lockEnabled ?? false) ...[
                    const Divider(height: AppDimens.lg),
                    InkWell(
                      onTap: () async {
                        final ok = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => const SetPinScreen()),
                        );
                        if (ok == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Код изменён')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(AppIcons.arrowsClockwise, size: 18, color: AppColors.accentDim),
                          const SizedBox(width: AppDimens.md),
                          Expanded(child: Text('Сменить код', style: AppTypography.body)),
                          Icon(AppIcons.caretDown, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const NSectionHeader('Подразделение'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NField(
              label: 'Наименование (для отчётов)',
              child: NTextInput(
                controller: _unit,
                hint: 'напр. 1-я рота',
                onChanged: (v) => actions.setUnitName(v),
              ),
            ),
          ),
          const NSectionHeader('Передача данных', color: AppColors.accentPrimary),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              onTap: () => _export(context),
              child: Row(
                children: [
                  Icon(AppIcons.shareNetwork, size: 18, color: AppColors.accentPrimary),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Поделиться данными', style: AppTypography.body),
                        Text('выгрузить весь список и передать (файл .tbl)', style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              onTap: () => _import(context),
              child: Row(
                children: [
                  Icon(AppIcons.download, size: 18, color: AppColors.statusLeave),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Загрузить данные из файла', style: AppTypography.body),
                        Text('заменит текущие данными из полученного файла', style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const NSectionHeader('Данные'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ArchiveScreen()),
              ),
              child: Row(
                children: [
                  Icon(AppIcons.userMinus, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Архив исключённых', style: AppTypography.body),
                        Text('вернуть бойца или удалить безвозвратно', style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                  Icon(AppIcons.caretDown, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              onTap: () => _confirmReset(context),
              child: Row(
                children: [
                  Icon(AppIcons.arrowsClockwise, size: 18, color: AppColors.statusLeave),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Сбросить к типовому штату', style: AppTypography.body),
                        Text('УДАЛИТ все текущие данные и создаст пустой типовой штат (53 должности)', style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              border: AppColors.statusSick,
              onTap: () => _confirmWipe(context),
              child: Row(
                children: [
                  Icon(AppIcons.trash, size: 18, color: AppColors.statusSick),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Удалить всё', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
                        Text('удалить должности, звания, фамилии — всё; пустой лист', style: AppTypography.dataSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const NSectionHeader('О приложении'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              child: Column(
                children: [
                  _about('Табель', 'учёт личного состава'),
                  const Divider(height: AppDimens.lg),
                  _about('Версия', '2.0'),
                  const Divider(height: AppDimens.lg),
                  _about('Данные', 'офлайн, только на устройстве'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
            child: NPanel(
              onTap: () => _shareErrorLog(context),
              child: Row(
                children: [
                  Icon(AppIcons.warning, size: 18, color: AppColors.textTertiary),
                  const SizedBox(width: AppDimens.md),
                  Expanded(child: Text('Журнал ошибок', style: AppTypography.body)),
                  Text('поделиться',
                      style: AppTypography.dataSmall.copyWith(color: AppColors.accentPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareErrorLog(BuildContext context) async {
    final path = await ErrorLog.filePath();
    if (!context.mounted) return;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Журнал пуст — ошибок не зафиксировано')),
      );
      return;
    }
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)], text: 'Журнал ошибок «Табель»'),
    );
  }

  Widget _about(String k, String v) => Row(
        children: [
          Expanded(child: Text(k, style: AppTypography.body)),
          Text(v, style: AppTypography.dataSmall),
        ],
      );

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text('Сбросить все данные?', style: AppTypography.title),
        content: Text(
          'Будут удалены все бойцы, награды, отпуска, командировки и вооружение. '
          'Штат восстановится по умолчанию (53 должности). Отменить нельзя.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Сбросить', style: AppTypography.body.copyWith(color: AppColors.statusSick)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(appDatabaseProvider).resetAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные сброшены, штат восстановлен')),
        );
      }
    }
  }

  Future<void> _confirmWipe(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.statusSick),
        ),
        title: Text('Удалить всё?', style: AppTypography.title.copyWith(color: AppColors.statusSick)),
        content: Text(
          'Будут удалены ВСЕ должности, звания, фамилии, награды, отпуска, '
          'командировки и вооружение. Останется пустой лист. Отменить нельзя.',
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
    if (ok == true) {
      await ref.read(appDatabaseProvider).wipeAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Все данные удалены')),
        );
      }
    }
  }

  Future<void> _export(BuildContext context) async {
    final pw = await _askExportPassword(context);
    if (pw == null) return; // отмена
    final picker = ref.read(systemPickerActiveProvider.notifier);
    picker.active = true; // не блокировать приложение на время шэринга
    bool ok;
    try {
      ok = await exportTblBackup(
        ref.read(appDatabaseProvider),
        password: pw.isEmpty ? null : pw,
      );
    } finally {
      picker.active = false;
    }
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось выгрузить данные')),
      );
    }
  }

  /// Диалог экспорта: пустой пароль — без шифрования; иначе файл шифруется.
  /// Возвращает null при отмене.
  Future<String?> _askExportPassword(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text('Выгрузка данных', style: AppTypography.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Файл содержит персональные данные. Можно задать пароль — '
                'тогда без него файл не прочитать.',
                style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: AppDimens.md),
            TextField(
              controller: ctrl,
              autofocus: true,
              obscureText: true,
              style: AppTypography.data.copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Пароль (необязательно)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ''),
            child: Text('Без пароля', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text('Зашифровать', style: AppTypography.body.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
  }

  Future<String?> _askImportPassword(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text('Файл зашифрован', style: AppTypography.title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          obscureText: true,
          style: AppTypography.data.copyWith(color: AppColors.textPrimary),
          decoration: const InputDecoration(hintText: 'Пароль'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text('Расшифровать', style: AppTypography.body.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
  }

  Future<void> _import(BuildContext context) async {
    final picker = ref.read(systemPickerActiveProvider.notifier);
    picker.active = true; // не блокировать приложение на время выбора файла
    try {
      await _importInner(context);
    } finally {
      picker.active = false;
    }
  }

  Future<void> _importInner(BuildContext context) async {
    // Разрешаем выбрать ЛЮБОЙ файл: Android «серит» незнакомые расширения
    // (.tbl), поэтому не ограничиваем тип — содержимое проверяем сами.
    const group = XTypeGroup(label: 'Файл данных «Табель» (.tbl)');
    final XFile? f = await openFile(acceptedTypeGroups: const [group]);
    if (f == null) return;
    String content;
    try {
      // Явно декодируем как UTF-8 (readAsString на части устройств берёт
      // системную кодировку → кириллица превращается в «иероглифы»).
      content = utf8.decode(await f.readAsBytes());
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось прочитать файл')),
        );
      }
      return;
    }
    // Зашифрованный файл — спросить пароль и расшифровать.
    if (isEncryptedTbl(content)) {
      if (!context.mounted) return;
      final pw = await _askImportPassword(context);
      if (pw == null || pw.isEmpty) return;
      try {
        content = decryptTbl(content, pw);
      } on FormatException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
        return;
      }
    }
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.rLg),
          side: const BorderSide(color: AppColors.stroke),
        ),
        title: Text('Загрузить данные?', style: AppTypography.title),
        content: Text(
          'Текущие данные будут заменены содержимым файла. Продолжить?',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Загрузить', style: AppTypography.body.copyWith(color: AppColors.accentPrimary)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(appDatabaseProvider).importJson(content);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные загружены')),
        );
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить данные')),
        );
      }
    }
  }
}
