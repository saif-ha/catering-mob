import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = MockData.orders;
    final active = allOrders.where((o) => o.isActive).toList();
    final past = allOrders.where((o) => !o.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.creamBackground,
        bottom: TabBar(
          controller: _tabs,
          labelStyle: AppTypography.labelLg,
          unselectedLabelStyle: AppTypography.labelLg,
          labelColor: AppColors.oliveGreen,
          unselectedLabelColor: AppColors.mutedText,
          indicatorColor: AppColors.oliveGreen,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _OrderList(orders: active, emptyMessage: 'No active orders.\nBrowse meals and place your first order.'),
          _OrderList(orders: past, emptyMessage: 'No past orders yet.'),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final String emptyMessage;

  const _OrderList({required this.orders, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'No orders',
        message: emptyMessage,
        actionLabel: 'Browse Meals',
        onAction: () => context.push('/client/meals'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) => _OrderCard(order: orders[i], index: i),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final int index;

  const _OrderCard({required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/client/orders/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNumber, style: AppTypography.titleMd),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(order.createdAt),
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
                StatusBadge.fromStatus(order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.lightBorder, height: 1),
            const SizedBox(height: AppSpacing.md),
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.oliveGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${item.quantity}× ${item.mealName}',
                          style: AppTypography.bodySm),
                    ],
                  ),
                  Text('\$${item.subtotal.toStringAsFixed(2)}',
                      style: AppTypography.labelSm),
                ],
              ),
            )),
            if (order.items.length > 2)
              Text('+${order.items.length - 2} more items',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.mutedText)),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.paymentMethod == 'invoice' ? '📄 Invoice' : '💳 Card',
                  style: AppTypography.bodySm,
                ),
                Text(
                  'Total: \$${order.total.toStringAsFixed(2)}',
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.terracotta),
                ),
              ],
            ),
            if (order.isActive) ...[
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => context.push('/client/orders/${order.id}/track'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.oliveLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 16, color: AppColors.oliveGreen),
                      const SizedBox(width: 6),
                      Text('Track Order',
                          style: AppTypography.labelSm
                              .copyWith(color: AppColors.oliveGreen)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(
        delay: Duration(milliseconds: index * 80), duration: 300.ms);
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
