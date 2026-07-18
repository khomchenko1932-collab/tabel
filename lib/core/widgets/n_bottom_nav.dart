import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Пункт нижней навигации.
class NNavItem {
  const NNavItem({required this.icon, required this.activeIcon, required this.label});
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Кастомная нижняя навигация в стиле Nothing: линия-индикатор СВЕРХУ активной
/// вкладки, свечение акцента, моноширинные подписи.
class NBottomNav extends StatelessWidget {
  const NBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.navHeight + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgHeader, Color(0xFF090A07)],
        ),
        border: Border(top: BorderSide(color: AppColors.strokeStrong, width: 1)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(child: _NavTab(item: items[i], active: i == currentIndex, onTap: () => onTap(i))),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({required this.item, required this.active, required this.onTap});

  final NNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.accentPrimary : AppColors.textTertiary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Линия-индикатор сверху.
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            height: 2,
            width: active ? 26 : 0,
            decoration: BoxDecoration(
              color: AppColors.accentPrimary,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
              boxShadow: active
                  ? [const BoxShadow(color: AppColors.accentPrimary, blurRadius: 6)]
                  : null,
            ),
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              active ? item.activeIcon : item.icon,
              key: ValueKey(active),
              size: 21,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(item.label, style: AppTypography.navLabel.copyWith(color: color)),
          const Spacer(),
        ],
      ),
    );
  }
}
