import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_fields.dart';
import '../../core/widgets/n_panel.dart';
import '../../domain/services/service_service.dart';

/// Интерактивный калькулятор выслуги лет: дата начала службы + льготные
/// периоды → календарная/льготная выслуга, надбавка, право на пенсию.
class ServiceCalcScreen extends StatefulWidget {
  const ServiceCalcScreen({super.key});

  @override
  State<ServiceCalcScreen> createState() => _ServiceCalcScreenState();
}

class _ServiceCalcScreenState extends State<ServiceCalcScreen> {
  DateTime? _start;
  final List<({DateTime start, DateTime? end, double coef})> _periods = [];

  @override
  Widget build(BuildContext context) {
    final los = _start == null
        ? null
        : LengthOfService.fromParts(_start!, _periods);

    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор выслуги', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.lg),
        children: [
          if (los != null) _result(los),
          if (los != null) const SizedBox(height: AppDimens.md),
          NField(
            label: 'Дата начала военной службы',
            child: NDateField(
              value: _start,
              onChanged: (d) => setState(() => _start = d),
              onCleared: () => setState(() => _start = null),
              openYearFirst: true,
              lastDate: DateTime.now(),
            ),
          ),
          const SizedBox(height: AppDimens.lg),
          Row(
            children: [
              Icon(AppIcons.calendar, size: 16, color: AppColors.statusTrip),
              const SizedBox(width: AppDimens.sm),
              Text('ЛЬГОТНЫЕ ПЕРИОДЫ', style: AppTypography.label),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          for (var i = 0; i < _periods.length; i++) _periodRow(i),
          const SizedBox(height: AppDimens.sm),
          GestureDetector(
            onTap: _addPeriod,
            child: Row(
              children: [
                Icon(AppIcons.plus, size: 16, color: AppColors.accentPrimary),
                const SizedBox(width: 6),
                Text('Добавить льготный период',
                    style: AppTypography.data.copyWith(color: AppColors.accentPrimary)),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }

  Widget _result(LengthOfService los) => NPanel(
        glow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Календарная выслуга', formatYmd(los.calendar), AppColors.textPrimary),
            if (los.hasBonus) ...[
              const SizedBox(height: 6),
              _row('Льготная выслуга', formatYmd(los.preferential), AppColors.statusTrip),
            ],
            const Divider(height: AppDimens.lg, color: AppColors.stroke),
            _row('Надбавка за выслугу', '${los.allowancePercent}%', AppColors.accentPrimary),
            const SizedBox(height: 2),
            Text('справочно, по календарной', style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: AppDimens.sm),
            Row(
              children: [
                Icon(los.pensionReached ? AppIcons.shield : AppIcons.calendar,
                    size: 14,
                    color: los.pensionReached ? AppColors.accentPrimary : AppColors.textSecondary),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: Text(
                    los.pensionReached
                        ? 'Право на пенсию (20 лет) — есть'
                        : 'До 20 лет выслуги: ${formatYmd(los.toPension)}',
                    style: AppTypography.dataSmall.copyWith(
                        color: los.pensionReached ? AppColors.accentPrimary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _row(String label, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(value, style: AppTypography.data.copyWith(color: color)),
        ],
      );

  Widget _periodRow(int i) {
    final p = _periods[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.xs),
      child: NPanel(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'день за ${p.coef == 1.5 ? 'полтора' : p.coef == 2.0 ? 'два' : 'три'} · '
                '${Fmt.short(p.start)} → ${p.end == null ? 'по н.в.' : Fmt.short(p.end!)}',
                style: AppTypography.dataSmall,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(AppIcons.trash, size: 16, color: AppColors.textTertiary),
              onPressed: () => setState(() => _periods.removeAt(i)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPeriod() async {
    final res = await showModalBottomSheet<({DateTime start, DateTime? end, double coef})>(
      context: context,
      backgroundColor: AppColors.bgRaised,
      isScrollControlled: true,
      builder: (_) => const _PeriodSheet(),
    );
    if (res != null) setState(() => _periods.add(res));
  }
}

class _PeriodSheet extends StatefulWidget {
  const _PeriodSheet();
  @override
  State<_PeriodSheet> createState() => _PeriodSheetState();
}

class _PeriodSheetState extends State<_PeriodSheet> {
  DateTime? _start;
  DateTime? _end;
  bool _ongoing = true;
  double _coef = 1.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg,
          MediaQuery.of(context).viewInsets.bottom + AppDimens.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Льготный период', style: AppTypography.title),
          const SizedBox(height: AppDimens.md),
          NField(
            label: 'Коэффициент',
            child: NChoiceChips<double>(
              values: const [1.5, 2.0, 3.0],
              selected: _coef,
              labelOf: (c) => c == 1.5 ? 'день за полтора' : c == 2.0 ? 'день за два' : 'день за три',
              onChanged: (c) => setState(() => _coef = c),
            ),
          ),
          const SizedBox(height: AppDimens.md),
          Row(
            children: [
              Expanded(
                child: NField(
                  label: 'Начало',
                  child: NDateField(value: _start, onChanged: (d) => setState(() => _start = d), onCleared: () => setState(() => _start = null)),
                ),
              ),
              const SizedBox(width: AppDimens.md),
              Expanded(
                child: NField(
                  label: 'Окончание',
                  child: _ongoing
                      ? Container(height: 44, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: AppDimens.md), child: Text('по н.в.', style: AppTypography.data.copyWith(color: AppColors.textTertiary)))
                      : NDateField(value: _end, onChanged: (d) => setState(() => _end = d), onCleared: () => setState(() => _end = null)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          NToggle(label: 'Период продолжается (по н.в.)', value: _ongoing, onChanged: (v) => setState(() => _ongoing = v)),
          const SizedBox(height: AppDimens.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.accentPrimary, foregroundColor: AppColors.bgPage),
              onPressed: _start == null
                  ? null
                  : () => Navigator.pop(context, (start: _start!, end: _ongoing ? null : _end, coef: _coef)),
              child: Text('ДОБАВИТЬ', style: AppTypography.title.copyWith(fontSize: 13, color: AppColors.bgPage)),
            ),
          ),
        ],
      ),
    );
  }
}
