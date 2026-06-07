import 'package:flutter/material.dart';

import '../../../../core/theming/noir_account_hub_theme.dart';

class NoirBottomNavBar extends StatelessWidget {
  const NoirBottomNavBar({
    this.currentIndex = 3,
    this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const _items = <_NavItem>[
    _NavItem(icon: Icons.home_outlined, label: 'Home'),
    _NavItem(icon: Icons.search, label: 'Search'),
    _NavItem(icon: Icons.favorite_border, label: 'Wishlist'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      color: NoirAccountHubTheme.bottomNavBackground,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              final color = isActive
                  ? NoirAccountHubTheme.accent
                  : NoirAccountHubTheme.bottomNavInactive;

              return IconButton(
                onPressed: () => onTap?.call(index),
                icon: Icon(item.icon, color: color, size: 28),
                tooltip: item.label,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
