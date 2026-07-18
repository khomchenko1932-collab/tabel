/// Отступы, радиусы и размеры — единая сетка приложения.
abstract final class AppDimens {
  // Отступы
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Радиусы (скруглённые, но не круглые — приборная эстетика)
  static const double rSm = 6;
  static const double rMd = 8;
  static const double rLg = 11;
  static const double rXl = 15;

  // Границы
  static const double borderThin = 1;
  static const double borderHair = 0.5;

  // Точка перехода на планшетную раскладку
  static const double tabletBreakpoint = 600;
  static const double contentMaxWidth = 760;

  // Высоты элементов
  static const double navHeight = 64;
  static const double buttonHeight = 48;
  static const double fabSize = 52;
}
