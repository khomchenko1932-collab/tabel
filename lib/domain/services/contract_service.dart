/// Состояние контракта для подсветки в профиле.
enum ContractState {
  none, // дата не задана
  ok, // всё в порядке
  soon, // истекает в пределах порога
  expired, // истёк
}

abstract final class ContractService {
  /// Порог «скоро истекает», дней.
  static const int soonThreshold = 30;

  static int? daysLeft(DateTime? end, [DateTime? now]) {
    if (end == null) return null;
    final today = _d(now ?? DateTime.now());
    return _d(end).difference(today).inDays;
  }

  static ContractState state(DateTime? end, [DateTime? now]) {
    final d = daysLeft(end, now);
    if (d == null) return ContractState.none;
    if (d < 0) return ContractState.expired;
    if (d <= soonThreshold) return ContractState.soon;
    return ContractState.ok;
  }

  static DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
