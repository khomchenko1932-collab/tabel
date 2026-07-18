import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/n_button.dart';
import '../../core/widgets/n_indicators.dart';
import '../../core/widgets/n_panel.dart';
import '../../data/database/app_database.dart';
import '../../data/models/soldier_view.dart';
import '../../domain/entities/enums.dart';
import '../common/screen_header.dart';
import '../common/soldier_picker.dart';
import '../common/undo.dart';
import '../providers/app_providers.dart';
import '../reports/export_service.dart';
import 'widgets/weapon_form_sheet.dart';

/// Экран «Вооружение» — по бойцу / по оружию, фильтр по категории, экспорт.
class WeaponsScreen extends ConsumerStatefulWidget {
  const WeaponsScreen({super.key});

  @override
  ConsumerState<WeaponsScreen> createState() => _WeaponsScreenState();
}

class _WeaponsScreenState extends ConsumerState<WeaponsScreen> {
  bool _byPerson = true;
  WeaponType? _type;

  @override
  Widget build(BuildContext context) {
    final weapons = ref.watch(allWeaponsProvider).value ?? const [];
    final roster = ref.watch(effectiveRosterProvider).value ?? const [];
    final views = {for (final s in roster) if (s.view.person != null) s.view.person!.id: s.view};

    final filtered = weapons.where((w) => _type == null || w.type == _type).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(views),
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.bgPage,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.rXl)),
        child: Icon(AppIcons.plus),
      ),
      body: Column(
        children: [
          const ScreenHeader(title: 'Вооружение'),
          _toggle(),
          _typeFilter(),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: AppIcons.target,
                    title: 'Ничего не закреплено',
                    message: 'Нажмите «+», чтобы закрепить оружие за бойцом',
                  )
                : _byPerson
                    ? _byPersonList(filtered, views)
                    : _byWeaponList(filtered, views),
          ),
          _exportBar(filtered, views),
        ],
      ),
    );
  }

  Widget _toggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.md, AppDimens.lg, 0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.bgLcd,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            _toggleTab('ПО БОЙЦУ', _byPerson, () => setState(() => _byPerson = true)),
            _toggleTab('ПО ОРУЖИЮ', !_byPerson, () => setState(() => _byPerson = false)),
          ],
        ),
      ),
    );
  }

  Widget _toggleTab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: active ? AppColors.accentGradient : null,
            borderRadius: BorderRadius.circular(AppDimens.rSm),
          ),
          child: Text(label,
              style: AppTypography.label.copyWith(
                  color: active ? AppColors.bgPage : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _typeFilter() {
    final items = <(String, WeaponType?)>[
      ('Все', null),
      (WeaponType.weapon.label, WeaponType.weapon),
      (WeaponType.device.label, WeaponType.device),
      (WeaponType.equipment.label, WeaponType.equipment),
    ];
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, AppDimens.sm),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimens.sm),
        itemBuilder: (_, i) {
          final (label, t) = items[i];
          final active = _type == t;
          return GestureDetector(
            onTap: () => setState(() => _type = t),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: active ? AppColors.accentGradient : null,
                color: active ? null : AppColors.bgLcd,
                borderRadius: BorderRadius.circular(AppDimens.rSm),
                border: Border.all(color: active ? AppColors.accentBright : AppColors.stroke),
              ),
              child: Text(label.toUpperCase(),
                  style: AppTypography.data.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: active ? AppColors.bgPage : AppColors.textSecondary)),
            ),
          );
        },
      ),
    );
  }

  Widget _byPersonList(List<WeaponRow> weapons, Map<int, SoldierView> views) {
    final grouped = <int, List<WeaponRow>>{};
    for (final w in weapons) {
      grouped.putIfAbsent(w.personnelId, () => []).add(w);
    }
    final ids = grouped.keys.toList()
      ..sort((a, b) => (views[a]?.position.slot ?? 999).compareTo(views[b]?.position.slot ?? 999));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, 8),
      itemCount: ids.length,
      itemBuilder: (_, i) {
        final view = views[ids[i]];
        final list = grouped[ids[i]]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          child: NPanel(
            padding: EdgeInsets.zero,
            clip: true,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: AppDimens.sm),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.bgRaised, AppColors.bgPanelLo]),
                    border: Border(bottom: BorderSide(color: AppColors.stroke)),
                  ),
                  child: Text(
                    '${view?.displayName ?? '—'}  ·  ${view?.position.subunit ?? ''}',
                    style: AppTypography.name.copyWith(fontSize: 12),
                  ),
                ),
                for (final w in list) _weaponRow(w),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _byWeaponList(List<WeaponRow> weapons, Map<int, SoldierView> views) {
    final sorted = [...weapons]..sort((a, b) => a.name.compareTo(b.name));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, 8),
      itemCount: sorted.length,
      itemBuilder: (_, i) {
        final w = sorted[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          child: NPanel(
            child: IntrinsicHeight(
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CategoryBar(AppColors.accentDim),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.name, style: AppTypography.name),
                      const SizedBox(height: 2),
                      Text('${views[w.personnelId]?.displayName ?? '—'} · ${w.type.label}',
                          style: AppTypography.dataSmall),
                    ],
                  ),
                ),
                if (w.serialNumber != null)
                  Text('№ ${w.serialNumber}', style: AppTypography.data),
              ],
            ),
            ),
          ),
        );
      },
    );
  }

  Widget _weaponRow(WeaponRow w) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md, vertical: 10),
      child: Row(
        children: [
          CategoryBar(AppColors.accentDim, width: 3),
          const SizedBox(width: AppDimens.md),
          Expanded(child: Text(w.name, style: AppTypography.body)),
          Text(w.serialNumber != null ? '№ ${w.serialNumber}' : w.type.label,
              style: AppTypography.data),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(AppIcons.trash, size: 15, color: AppColors.textTertiary),
            onPressed: () async {
              if (await confirmDelete(context, what: 'оружие')) {
                await ref.read(appDatabaseProvider).deleteWeapon(w.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _exportBar(List<WeaponRow> weapons, Map<int, SoldierView> views) {
    if (weapons.isEmpty) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.sm, AppDimens.lg, AppDimens.sm),
        child: NButton(
          label: 'ЭКСПОРТ XLSX',
          outline: true,
          icon: AppIcons.fileXls,
          onPressed: () {
            final items = [
              for (final w in weapons)
                (soldier: views[w.personnelId]?.displayName ?? '—', weapon: w),
            ];
            ExportService.exportWeaponsExcel(items, DateTime.now());
          },
        ),
      ),
    );
  }

  Future<void> _add(Map<int, SoldierView> views) async {
    final person = await pickSoldier(context, ref, title: 'Кому закрепить оружие');
    if (person != null && mounted) {
      await showWeaponForm(context, person.id);
    }
  }
}
