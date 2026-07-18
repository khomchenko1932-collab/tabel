import 'package:flutter/material.dart';

/// Палитра «Тактический графит»: почти чёрный графит + зелёный акцент,
/// матовые панели с фаской и утопленные LCD-табло.
abstract final class AppColors {
  // ══ ФОНЫ ══════════════════════════════════════════════════
  static const bgPage = Color(0xFF0C0E0A); // общий фон экранов
  static const bgHeader = Color(0xFF12150E); // шапки
  static const bgPanel = Color(0xFF181B14); // базовая поверхность панели
  static const bgPanelHi = Color(0xFF2A3020); // верх градиента панели (фаска-свет)
  static const bgPanelLo = Color(0xFF11140C); // низ градиента панели
  static const bgRaised = Color(0xFF252A20); // поднятые элементы
  static const bgLcd = Color(0xFF0A0C08); // утопленный «экран» под цифры
  static const bgOverlay = Color(0xFF14170F); // оверлеи, bottomsheet-фон

  // ══ АКЦЕНТ ════════════════════════════════════════════════
  static const accentBright = Color(0xFF8FD98A); // максимально яркий (свечение)
  static const accentPrimary = Color(0xFF7EC87A); // основной акцент — CTA, активное
  static const accentDim = Color(0xFF4A7848); // приглушённый — иконки, бейджи
  static const accentFaint = Color(0xFF2A3E29); // едва заметный — selected bg

  // ══ ТЕКСТ ═════════════════════════════════════════════════
  static const textPrimary = Color(0xFFE8E9E3);
  static const textSecondary = Color(0xFF96A38F);
  static const textTertiary = Color(0xFF5B6854);
  static const textDisabled = Color(0xFF3E4838);

  // ══ СЕМАНТИКА СТАТУСОВ ════════════════════════════════════
  static const statusHere = Color(0xFF7EC87A); // налицо — зелёный
  static const statusTrip = Color(0xFFD4A84B); // командировка — янтарь
  static const statusLeave = Color(0xFF6B9FD4); // отпуск — стальной синий
  static const statusSick = Color(0xFFD47070); // болен — красный
  static const statusVacant = Color(0xFF4A524A); // вакант — выключен
  static const statusExcluded = Color(0xFF7A6A6A); // исключён — серо-бурый

  // ══ КАТЕГОРИИ ЗВАНИЙ ══════════════════════════════════════
  static const catOfficer = Color(0xFFD4A84B); // офицеры — янтарь
  static const catWarrant = Color(0xFFB98FD4); // прапорщики — фиолетовый
  static const catSergeant = Color(0xFF6B9FD4); // сержанты — синий
  static const catSoldier = Color(0xFF7EC87A); // рядовые — зелёный

  // ══ КОНТРАКТ ══════════════════════════════════════════════
  static const contractOk = Color(0xFF7EC87A); // норма
  static const contractSoon = Color(0xFFD4A84B); // истекает ≤ 30 дней
  static const contractExpired = Color(0xFFD47070); // истёк

  // ══ СТРУКТУРА ═════════════════════════════════════════════
  static const stroke = Color(0xFF2E3528); // видимая граница
  static const strokeStrong = Color(0xFF3A4432); // акцентная граница
  static const strokeSubtle = Color(0xFF23281E); // едва заметная

  // ══ ФАСКА (скевоморфизм) ══════════════════════════════════
  static const bevelLight = Color(0x1FFFFFFF); // светлый кант сверху
  static const bevelDark = Color(0xB3000000); // тень снизу/утопление

  /// Градиент матовой графитовой панели.
  static const LinearGradient panelGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgPanelHi, bgPanelLo],
  );

  /// Градиент подсвеченного (акцентного) элемента — кнопка, активный чип.
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentBright, accentDim],
  );
}
