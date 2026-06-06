import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_sizes.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/orders_cubit.dart';
import '../bloc/orders_state.dart';
import '../widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(
        getOrderHistory: context.read(),
        getOrderDetail: context.read(),
        placeOrder: context.read(),
      )..loadOrders(),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading && state.orders.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == OrdersStatus.failure && state.orders.isEmpty) {
              return _EmptyState(
                message: state.errorMessage ?? l10n.genericErrorTitle,
                actionLabel: l10n.retryAction,
                onAction: context.read<OrdersCubit>().loadOrders,
              );
            }

            if (state.orders.isEmpty) {
              return _EmptyState(
                message: 'No orders yet.',
                actionLabel: 'Start shopping',
                onAction: () {
                  // Navigate to shop — hook up when shop feature exists.
                },
              );
            }

            return RefreshIndicator(
              onRefresh: context.read<OrdersCubit>().loadOrders,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: DeviceHelper.horizontalPadding(context),
                  vertical: AppSizes.md,
                ),
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => const SizedBox(
                  height: AppSizes.sm,
                ),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(
                    order: order,
                    onTap: () {
                      // Navigate to order detail when implemented.
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.actionLabel,
    this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceHelper.horizontalPadding(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textBody),
            ),
            const SizedBox(height: AppSizes.lg),
            if (onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
          ],
        ),
      ),
    );
  }
}
