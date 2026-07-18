import '../../domain/entities/enums.dart';
import '../database/app_database.dart';

/// Штатная должность вместе с занимающим её бойцом (или без него — вакансия).
class SoldierView {
  const SoldierView({required this.position, this.person});

  final PositionRow position;
  final PersonRow? person;

  bool get isVacant => person == null;

  /// Категория: у занятой должности — по званию бойца, у вакансии — штатная.
  RankCategory get category => person != null
      ? RankCategory.fromRank(person!.rank)
      : position.category;

  /// «Фамилия И.О.» либо «Вакант».
  String get displayName {
    final p = person;
    if (p == null) return 'Вакант';
    final initials =
        [p.firstName, p.middleName].where((s) => s.isNotEmpty).join(' ');
    return initials.isEmpty ? p.lastName : '${p.lastName} $initials';
  }

  /// Полное ФИО для профиля/экспорта.
  String get fullName {
    final p = person;
    if (p == null) return 'Вакант';
    return [p.lastName, p.firstName, p.middleName]
        .where((s) => s.isNotEmpty)
        .join(' ');
  }
}
