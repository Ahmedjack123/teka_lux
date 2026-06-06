import 'package:flutter/material.dart';

import '../../../../core/theming/theming.dart';
import '../../../profile/domain/entities/address.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    required this.address,
    this.onDelete,
    super.key,
  });

  final Address address;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: const BorderSide(color: AppColors.divider),
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    address.street,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textBody,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxs),
                  Text(
                    '${address.city}, ${address.country}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
