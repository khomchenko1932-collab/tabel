import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:narmb_ls/core/widgets/app_icons.dart';

import '../../core/theme/app_dimens.dart';
import '../../core/widgets/n_bottom_nav.dart';

/// Каркас приложения: телефон — нижняя навигация, планшет — NavigationRail.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final _items = <NNavItem>[
    NNavItem(
      icon: AppIcons.gauge,
      activeIcon: AppIcons.gaugeFill,
      label: 'РАСХОД',
    ),
    NNavItem(
      icon: AppIcons.users,
      activeIcon: AppIcons.usersFill,
      label: 'СОСТАВ',
    ),
    NNavItem(
      icon: AppIcons.umbrella,
      activeIcon: AppIcons.umbrellaFill,
      label: 'ОТПУСКА',
    ),
    NNavItem(
      icon: AppIcons.airplaneTilt,
      activeIcon: AppIcons.airplaneTiltFill,
      label: 'КОМАНД.',
    ),
    NNavItem(
      icon: AppIcons.target,
      activeIcon: AppIcons.targetFill,
      label: 'ОРУЖИЕ',
    ),
  ];

  void _go(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final isTablet =
        MediaQuery.of(context).size.shortestSide >= AppDimens.tabletBreakpoint;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            _Rail(items: _items, index: navigationShell.currentIndex, onTap: _go),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NBottomNav(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: _go,
      ),
    );
  }
}

/// Боковой рейл для планшета.
class _Rail extends StatelessWidget {
  const _Rail({required this.items, required this.index, required this.onTap});

  final List<NNavItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onTap,
      labelType: NavigationRailLabelType.all,
      minWidth: 72,
      destinations: [
        for (final it in items)
          NavigationRailDestination(
            icon: Icon(it.icon),
            selectedIcon: Icon(it.activeIcon),
            label: Text(it.label),
          ),
      ],
    );
  }
}
