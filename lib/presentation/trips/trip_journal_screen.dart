import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/n_panel.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/enums.dart';
import '../providers/app_providers.dart';
import 'widgets/trip_form_sheet.dart';

/// Журнал командировок бойца: полная история, итоги суток (в т.ч. льготных),
/// экспорт справкой.
class TripJournalScreen extends ConsumerWidget {
  const TripJournalScreen({super.key, required this.personId});
  final int personId;

  static DateTime _d(DateTime x) => DateTime(x.year, x.month, x.day);

  /// Суток по командировке (конец − начало + 1). null — если не посчитать.
  static int? _days(TripRow t, DateTime today) {
    if (t.startDate == null) return null;
    final start = _d(t.startDate!);
    final DateTime? end = t.endDate != null
        ? _d(t.endDate!)
        : (t.actualReturnDate != null
            ? _d(t.actualReturnDate!)
            : (t.status == TripStatus.active ? today : null));
    if (end == null || end.isBefore(start)) return null;
    return end.difference(start).inDays + 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final es = ref.watch(soldierByPersonProvider(personId));
    final today = _d(ref.watch(todayProvider));
    final trips = <TripRow>[...(ref.watch(tripsForProvider(personId)).value ?? const [])]
      ..sort((a, b) => (b.startDate ?? DateTime(0)).compareTo(a.startDate ?? DateTime(0)));

    final name = es?.view.displayName ?? '—';
    var total = 0, yearD = 0, privD = 0;
    for (final t in trips) {
      final d = _days(t, today) ?? 0;
      total += d;
      if (t.startDate != null && t.startDate!.year == today.year) yearD += d;
      if (t.serviceCoef > 1.0) privD += d;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Журнал командировок', style: AppTypography.title),
        leading: IconButton(
          icon: Icon(AppIcons.arrowLeft, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (trips.isNotEmpty)
            IconButton(
              tooltip: 'Выгрузить справку',
              icon: Icon(AppIcons.shareNetwork, color: AppColors.textSecondary),
              onPressed: () => _export(context, name, es, trips, today, total, yearD, privD),
            ),
        ],
      ),
      body: trips.isEmpty
          ? EmptyState(
              icon: AppIcons.airplaneTilt,
              title: 'Командировок нет',
              message: 'Добавьте командировку — она появится в журнале',
            )
          : ListView(
              padding: const EdgeInsets.all(AppDimens.lg),
              children: [
                Text(name.toUpperCase(), style: AppTypography.title),
                const SizedBox(height: AppDimens.sm),
                NPanel(
                  glow: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sum('Всего командировок', '${trips.length}', AppColors.textPrimary),
                      const SizedBox(height: 6),
                      _sum('Всего суток', '$total', AppColors.accentPrimary),
                      const SizedBox(height: 6),
                      _sum('Суток за ${today.year}', '$yearD', AppColors.textSecondary),
                      if (privD > 0) ...[
                        const SizedBox(height: 6),
                        _sum('Из них льготных суток', '$privD', AppColors.statusTrip),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.md),
                for (final t in trips) _tripCard(context, t, today),
              ],
            ),
    );
  }

  Widget _sum(String label, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(value, style: AppTypography.data.copyWith(color: color)),
        ],
      );

  Widget _tripCard(BuildContext context, TripRow t, DateTime today) {
    final d = _days(t, today);
    final statusColor = switch (t.status) {
      TripStatus.completed => AppColors.textTertiary,
      TripStatus.active => AppColors.statusTrip,
      TripStatus.planned => AppColors.statusLeave,
    };
    final statusLabel = switch (t.status) {
      TripStatus.completed => 'завершена',
      TripStatus.active => 'активна',
      TripStatus.planned => 'план',
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.sm),
      child: NPanel(
        onTap: () => showTripForm(context, personId, trip: t),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(t.destination, style: AppTypography.name)),
                Text(statusLabel, style: AppTypography.dataSmall.copyWith(color: statusColor)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${_range(t.startDate, t.endDate ?? t.actualReturnDate)}'
              '${d != null ? ' · ${Fmt.days(d)}' : ''}',
              style: AppTypography.dataSmall,
            ),
            if (t.serviceCoef > 1.0 || (t.orderNumber?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 3),
              Row(
                children: [
                  if (t.serviceCoef > 1.0)
                    Text('выслуга день за ${t.serviceCoef == 1.5 ? '1.5' : t.serviceCoef == 2.0 ? '2' : '3'}',
                        style: AppTypography.dataSmall.copyWith(color: AppColors.statusTrip)),
                  if (t.serviceCoef > 1.0 && (t.orderNumber?.isNotEmpty ?? false))
                    Text('  ·  ', style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                  if (t.orderNumber?.isNotEmpty ?? false)
                    Text('приказ ${t.orderNumber}',
                        style: AppTypography.dataSmall.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _range(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 'даты не указаны';
    return '${a == null ? '…' : Fmt.short(a)} — ${b == null ? 'по н.в.' : Fmt.short(b)}';
  }

  Future<void> _export(BuildContext context, String name, es, List<TripRow> trips,
      DateTime today, int total, int yearD, int privD) async {
    final p = es?.view.person;
    final pos = es?.view.position;
    final buf = StringBuffer()
      ..writeln('ЖУРНАЛ КОМАНДИРОВОК')
      ..writeln(name)
      ..writeln('${p?.rank ?? ''}${pos != null ? ' · ${pos.title}' : ''}')
      ..writeln('')
      ..writeln('Всего командировок: ${trips.length}')
      ..writeln('Всего суток: $total · за ${today.year}: $yearD'
          '${privD > 0 ? ' · льготных: $privD' : ''}')
      ..writeln('');
    var i = 1;
    for (final t in trips) {
      final d = _days(t, today);
      buf.writeln('${i++}. ${t.destination} — ${_range(t.startDate, t.endDate ?? t.actualReturnDate)}'
          '${d != null ? ' · $d сут' : ''}'
          '${t.serviceCoef > 1.0 ? ' · день за ${t.serviceCoef}' : ''}'
          '${(t.orderNumber?.isNotEmpty ?? false) ? ' · приказ ${t.orderNumber}' : ''}');
    }
    File? file;
    try {
      final dir = await getTemporaryDirectory();
      file = File('${dir.path}/journal_$personId.txt');
      await file.writeAsBytes(const Utf8Encoder().convert(buf.toString()));
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Журнал командировок · $name'),
      );
      // Журнал содержит ФИО — не оставляем копию в кэше после отправки.
      try {
        if (file.existsSync()) file.deleteSync();
      } catch (_) {/* не критично */}
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось выгрузить журнал')),
        );
      }
    }
  }
}
