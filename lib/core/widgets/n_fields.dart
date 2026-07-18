import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';

/// Обёртка поля: UPPERCASE-метка над контентом.
class NField extends StatelessWidget {
  const NField({super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTypography.label),
          const SizedBox(height: 6),
          child,
        ],
      );
}

/// Утопленное текстовое поле.
class NTextInput extends StatelessWidget {
  const NTextInput({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: AppTypography.body,
      cursorColor: AppColors.accentPrimary,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        filled: true,
        fillColor: AppColors.bgLcd,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.md),
        enabledBorder: _border(AppColors.stroke),
        focusedBorder: _border(AppColors.accentDim),
        border: _border(AppColors.stroke),
      ),
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        borderSide: BorderSide(color: c, width: 1),
      );
}

/// Поле выбора даты.
class NDateField extends StatelessWidget {
  const NDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.onCleared,
    this.hint = 'не задана',
    this.firstDate,
    this.lastDate,
    this.openYearFirst = false,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  /// Если задан и дата выбрана — показывает крестик для сброса даты.
  final VoidCallback? onCleared;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Открывать календарь сразу с выбора ГОДА — для дат рождения и начала
  /// службы, где листать месяцы на десятилетия назад неудобно.
  final bool openYearFirst;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        // Нижняя граница 1940 — любые даты рождения/начала службы достижимы.
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: firstDate ?? DateTime(1940),
          lastDate: lastDate ?? DateTime(now.year + 30),
          initialDatePickerMode:
              openYearFirst ? DatePickerMode.year : DatePickerMode.day,
          locale: const Locale('ru'),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.bgLcd,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.stroke, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value == null ? hint : Fmt.short(value!),
                style: AppTypography.data.copyWith(
                  color: value == null
                      ? AppColors.textTertiary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (value != null && onCleared != null)
              GestureDetector(
                onTap: onCleared,
                child: const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.close, size: 15, color: AppColors.textTertiary),
                ),
              ),
            const Icon(Icons.event, size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// Горизонтальный выбор из вариантов (чипы).
class NChoiceChips<T> extends StatelessWidget {
  const NChoiceChips({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.sm,
      runSpacing: AppDimens.sm,
      children: [
        for (final v in values)
          GestureDetector(
            onTap: () => onChanged(v),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: v == selected ? AppColors.accentGradient : null,
                color: v == selected ? null : AppColors.bgLcd,
                borderRadius: BorderRadius.circular(AppDimens.rSm),
                border: Border.all(
                  color: v == selected ? AppColors.accentBright : AppColors.stroke,
                  width: 1,
                ),
              ),
              child: Text(
                labelOf(v).toUpperCase(),
                style: AppTypography.data.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: v == selected ? AppColors.bgPage : AppColors.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Переключатель ON/OFF с меткой.
class NToggle extends StatelessWidget {
  const NToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.bgPage,
            activeTrackColor: AppColors.accentPrimary,
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.bgLcd,
          ),
        ],
      );
}

/// Числовой степпер −/+.
class NStepper extends StatelessWidget {
  const NStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgLcd,
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        border: Border.all(color: AppColors.stroke, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, () => value > min ? onChanged(value - 1) : null),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.lcd.copyWith(color: AppColors.textPrimary),
            ),
          ),
          _btn(Icons.add, () => value < max ? onChanged(value + 1) : null),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.md),
          child: Icon(icon, size: 18, color: AppColors.accentPrimary),
        ),
      );
}
