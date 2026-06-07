import 'package:flutter/material.dart';

import '../../../../core/theming/noir_account_hub_theme.dart';

class NoirAccountHubMenuTile extends StatelessWidget {
  const NoirAccountHubMenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NoirAccountHubTheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: NoirAccountHubTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: NoirAccountHubTheme.menuBorder),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: NoirAccountHubTheme.onBackground,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: NoirAccountHubTheme.anton(
                    fontSize: 20,
                    color: NoirAccountHubTheme.onBackground,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: NoirAccountHubTheme.onBackground,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
