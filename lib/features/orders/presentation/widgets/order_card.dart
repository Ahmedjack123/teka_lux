import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_sizes.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  final Order order;
  final VoidCallback? onTap;

  static final _dateFormat = DateFormat('MMM d, y');

  Color _statusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => AppColors.warning,
      OrderStatus.processing => AppColors.info,
      OrderStatus.shipped => AppColors.accentWarm,
      OrderStatus.delivered => AppColors.success,
      OrderStatus.cancelled => AppColors.error,
    };
  }

  String _statusLabel(OrderStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceElevated,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length)}',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textStrong,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      _statusLabel(order.status),
                      style: AppTextStyles.caption.copyWith(
                        color: _statusColor(order.status),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                _dateFormat.format(order.createdAt),
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textBody,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.priceLg.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
