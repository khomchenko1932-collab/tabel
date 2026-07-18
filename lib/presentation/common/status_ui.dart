import 'package:flutter/widgets.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/contract_service.dart';

/// Цвета и иконки для статусов бойца.
extension PersonnelStatusUi on PersonnelStatus {
  Color get color => switch (this) {
        PersonnelStatus.here => AppColors.statusHere,
        PersonnelStatus.trip => AppColors.statusTrip,
        PersonnelStatus.leave => AppColors.statusLeave,
        PersonnelStatus.sick => AppColors.statusSick,
      };

  IconData get icon => switch (this) {
        PersonnelStatus.here => AppIcons.checkCircle,
        PersonnelStatus.trip => AppIcons.airplaneTilt,
        PersonnelStatus.leave => AppIcons.umbrella,
        PersonnelStatus.sick => AppIcons.firstAid,
      };
}

/// Цвета категорий по званию.
extension RankCategoryUi on RankCategory {
  Color get color => switch (this) {
        RankCategory.officer => AppColors.catOfficer,
        RankCategory.warrant => AppColors.catWarrant,
        RankCategory.sergeant => AppColors.catSergeant,
        RankCategory.soldier => AppColors.catSoldier,
      };
}

/// Цвет состояния контракта.
extension ContractStateUi on ContractState {
  Color get color => switch (this) {
        ContractState.none => AppColors.textTertiary,
        ContractState.ok => AppColors.contractOk,
        ContractState.soon => AppColors.contractSoon,
        ContractState.expired => AppColors.contractExpired,
      };
}

/// Цвет статуса отпуска / командировки.
extension LeaveStatusUi on LeaveStatus {
  Color get color => switch (this) {
        LeaveStatus.planned => AppColors.statusLeave,
        LeaveStatus.active => AppColors.statusHere,
        LeaveStatus.completed => AppColors.textTertiary,
        LeaveStatus.cancelled => AppColors.statusSick,
      };
}

extension TripStatusUi on TripStatus {
  Color get color => switch (this) {
        TripStatus.planned => AppColors.statusLeave,
        TripStatus.active => AppColors.statusTrip,
        TripStatus.completed => AppColors.textTertiary,
      };
}
