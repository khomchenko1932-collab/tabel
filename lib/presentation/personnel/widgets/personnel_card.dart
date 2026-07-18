import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/n_indicators.dart';
import '../../../core/widgets/n_panel.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/services/roster_service.dart';
import '../../common/status_ui.dart';

/// Карточка бойца/вакансии в списке «Состав» со свайп-действиями.
class PersonnelCard extends StatelessWidget {
  const PersonnelCard({
    super.key,
    required this.soldier,
    this.onTap,
    this.onEdit,
    this.onTransfer,
    this.onStatus,
    this.onExclude,
    this.onAssign,
    this.onEditPosition,
    this.onDeletePosition,
    this.onLongPress,
    this.selectionMode = false,
    this.selected = false,
    this.serviceLine,
  });

  final EffectiveSoldier soldier;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onTransfer;
  final VoidCallback? onStatus;
  final VoidCallback? onExclude;
  final VoidCallback? onAssign;
  final VoidCallback? onEditPosition;
  final VoidCallback? onDeletePosition;

  /// Долгое нажатие (по умолчанию — быстрый статус). Используется для входа
  /// в режим множественного выбора.
  final VoidCallback? onLongPress;

  /// Режим выделения нескольких бойцов (свайпы отключены, слева — чекбокс).
  final bool selectionMode;
  final bool selected;

  /// Строка выслуги (общая/льготная) — показывается под должностью, если задана.
  final String? serviceLine;

  @override
  Widget build(BuildContext context) {
    final view = soldier.view;
    final pos = view.position;
    final vacant = view.isVacant;
    final catColor = vacant ? AppColors.statusVacant : view.category.color;
    final showCheck = selectionMode && !vacant;

    final card = NPanel(
      margin: const EdgeInsets.fromLTRB(AppDimens.md, 0, AppDimens.md, AppDimens.sm),
      padding: EdgeInsets.zero,
      clip: true,
      border: selected ? AppColors.accentPrimary : null,
      onTap: vacant ? onAssign : onTap,
      onLongPress: onLongPress ?? (vacant ? null : onStatus),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (showCheck)
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.md),
                child: Icon(
                  selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: selected ? AppColors.accentPrimary : AppColors.textTertiary,
                ),
              ),
            CategoryBar(catColor),
            const SizedBox(width: AppDimens.md),
            SizedBox(
              width: 26,
              child: Text(
                pos.slot.toString().padLeft(2, '0'),
                style: AppTypography.data.copyWith(color: AppColors.textTertiary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          view.displayName,
                          style: AppTypography.name.copyWith(
                            color: vacant ? AppColors.textTertiary : AppColors.textPrimary,
                          ),
                        ),
                        if (vacant) ...[
                          const SizedBox(width: AppDimens.sm),
                          const NTag('Вакант', color: AppColors.statusVacant),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(pos, view.person?.rank ?? ''),
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!vacant && serviceLine != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(AppIcons.calendar, size: 11, color: AppColors.accentDim),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              serviceLine!,
                              style: AppTypography.dataSmall.copyWith(color: AppColors.accentDim),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            Padding(
              padding: const EdgeInsets.only(right: AppDimens.md),
              child: vacant
                  ? Icon(AppIcons.userPlus, size: 18, color: AppColors.accentPrimary)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusLed(soldier.status!.color),
                        const SizedBox(height: 4),
                        Text(
                          soldier.status!.label,
                          style: AppTypography.dataSmall.copyWith(color: soldier.status!.color),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );

    // В режиме выбора свайп-действия отключаем, чтобы не мешали тапам.
    if (selectionMode) return card;

    if (vacant) {
      return Slidable(
        key: ValueKey('vac${pos.id}'),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.5,
          children: [
            _action(AppIcons.pencilSimple, 'ДОЛЖНОСТЬ', AppColors.textSecondary, onEditPosition),
            _action(AppIcons.trash, 'УДАЛИТЬ', AppColors.statusSick, onDeletePosition),
          ],
        ),
        child: card,
      );
    }

    return Slidable(
      key: ValueKey('p${view.person!.id}'),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.75,
        children: [
          _action(AppIcons.pencilSimple, 'ПРАВКА', AppColors.textSecondary, onEdit),
          _action(AppIcons.arrowsLeftRight, 'ПЕРЕВОД', AppColors.statusLeave, onTransfer),
          _action(AppIcons.arrowsClockwise, 'СТАТУС', AppColors.accentPrimary, onStatus),
          _action(AppIcons.userMinus, 'ИСКЛ.', AppColors.statusSick, onExclude),
        ],
      ),
      child: card,
    );
  }

  String _subtitle(PositionRow pos, String rank) {
    final r = rank.isNotEmpty ? ' · $rank' : '';
    return '${pos.title}$r';
  }

  Widget _action(IconData icon, String label, Color color, VoidCallback? cb) {
    return CustomSlidableAction(
      onPressed: (_) => cb?.call(),
      backgroundColor: AppColors.bgRaised,
      foregroundColor: color,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.navLabel.copyWith(color: color)),
        ],
      ),
    );
  }
}
