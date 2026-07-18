import 'package:flutter/material.dart';

/// Тонкие иконки (Material outlined) под эстетику Nothing.
/// Централизованы, чтобы легко сменить набор при необходимости.
abstract final class AppIcons {
  // Навигация
  static const IconData gauge = Icons.assessment_outlined;
  static const IconData gaugeFill = Icons.assessment_rounded;
  static const IconData users = Icons.groups_2_outlined;
  static const IconData usersFill = Icons.groups_2_rounded;
  static const IconData usersThree = Icons.groups_2_outlined;
  static const IconData umbrella = Icons.beach_access_outlined;
  static const IconData umbrellaFill = Icons.beach_access_rounded;
  static const IconData airplaneTilt = Icons.flight_takeoff_outlined;
  static const IconData airplaneTiltFill = Icons.flight_takeoff_rounded;
  static const IconData target = Icons.shield_outlined;
  static const IconData targetFill = Icons.shield_rounded;

  // Статусы
  static const IconData checkCircle = Icons.check_circle_rounded;
  static const IconData firstAid = Icons.medical_services_rounded;

  // Действия
  static const IconData plus = Icons.add_rounded;
  static const IconData plusCircle = Icons.add_circle_rounded;
  static const IconData magnifyingGlass = Icons.search_rounded;
  static const IconData pencilSimple = Icons.edit_rounded;
  static const IconData arrowsLeftRight = Icons.swap_horiz_rounded;
  static const IconData arrowsClockwise = Icons.sync_rounded;
  static const IconData arrowLeft = Icons.arrow_back_rounded;
  static const IconData trash = Icons.delete_rounded;
  static const IconData userPlus = Icons.person_add_alt_1_rounded;
  static const IconData userMinus = Icons.person_off_rounded;

  // Профиль / данные
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData mapPin = Icons.place_rounded;
  static const IconData heart = Icons.favorite_rounded;
  static const IconData baby = Icons.escalator_warning_rounded;
  static const IconData medal = Icons.workspace_premium_rounded;
  static const IconData calendar = Icons.event_rounded;
  static const IconData cake = Icons.cake_rounded;
  static const IconData shieldStar = Icons.verified_rounded;
  static const IconData idCard = Icons.badge_rounded;
  static const IconData contract = Icons.assignment_ind_rounded;
  static const IconData rank = Icons.military_tech_rounded;

  // Экспорт
  static const IconData filePdf = Icons.picture_as_pdf_rounded;
  static const IconData fileXls = Icons.table_chart_rounded;
  static const IconData shareNetwork = Icons.ios_share_rounded;
  static const IconData download = Icons.file_download_rounded;

  // Довольствие
  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData coins = Icons.payments_rounded;
  static const IconData calculator = Icons.calculate_rounded;
  static const IconData hourglass = Icons.hourglass_bottom_rounded;

  // Разное
  static const IconData backspace = Icons.backspace_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData lockOpen = Icons.lock_open_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData shield = Icons.shield_rounded;
  static const IconData caretUp = Icons.keyboard_arrow_up_rounded;
  static const IconData caretDown = Icons.keyboard_arrow_down_rounded;
  static const IconData home = Icons.home_rounded;
  static const IconData mapForward = Icons.location_on_rounded;
}
