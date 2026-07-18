import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/expense/expense_screen.dart';
import '../../presentation/leaves/leaves_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/personnel/personnel_detail_screen.dart';
import '../../presentation/personnel/personnel_list_screen.dart';
import '../../presentation/security/lock_screen.dart';
import '../../presentation/settings/settings_controller.dart';
import '../../presentation/shell/app_shell.dart';
import '../../presentation/trips/trips_screen.dart';
import '../../presentation/weapons/weapons_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Роутер с гейтом: онбординг → блокировка → приложение.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _GateRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/expense',
    refreshListenable: refresh,
    redirect: (context, state) {
      final settings = ref.read(settingsProvider).value;
      if (settings == null) return null; // настройки ещё грузятся
      final loc = state.matchedLocation;

      if (!settings.onboardingDone) {
        return loc == '/onboarding' ? null : '/onboarding';
      }
      if (settings.lockEnabled && ref.read(lockedProvider)) {
        return loc == '/lock' ? null : '/lock';
      }
      if (loc == '/onboarding' || loc == '/lock') return '/expense';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/lock', builder: (c, s) => const LockScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/expense', builder: (c, s) => const ExpenseScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/personnel', builder: (c, s) => const PersonnelListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/leaves', builder: (c, s) => const LeavesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/trips', builder: (c, s) => const TripsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/weapons', builder: (c, s) => const WeaponsScreen()),
          ]),
        ],
      ),
      GoRoute(
        path: '/soldier/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) => _slideFade(
          key: state.pageKey,
          child: PersonnelDetailScreen(personId: int.parse(state.pathParameters['id']!)),
        ),
      ),
    ],
  );
});

/// Перерасчёт редиректа при изменении настроек/блокировки.
class _GateRefresh extends ChangeNotifier {
  _GateRefresh(Ref ref) {
    _subs = [
      ref.listen(settingsProvider, (_, _) => notifyListeners()),
      ref.listen(lockedProvider, (_, _) => notifyListeners()),
    ];
  }
  late final List<ProviderSubscription> _subs;

  @override
  void dispose() {
    for (final s in _subs) {
      s.close();
    }
    super.dispose();
  }
}

/// Переход в стиле Nothing: горизонтальный слайд + затухание.
CustomTransitionPage<void> _slideFade({required LocalKey key, required Widget child}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}
