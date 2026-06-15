import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class ClientGroupOrdersScreen extends ConsumerWidget {
  const ClientGroupOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupOrders = MockData.groupOrders;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Group Orders'),
        backgroundColor: AppColors.creamBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showJoinDialog(context),
          ),
        ],
      ),
      body: groupOrders.isEmpty
          ? EmptyStateWidget(
              icon: Icons.group_outlined,
              title: 'No group orders',
              message: 'No active group orders right now.\nJoin one with an invite code or wait for your company to create one.',
              actionLabel: 'Join with Code',
              onAction: () => _showJoinDialog(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: groupOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) =>
                  _GroupOrderCard(groupOrder: groupOrders[i], index: i),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showJoinDialog(context),
        icon: const Icon(Icons.group_add_rounded),
        label: const Text('Join with Code'),
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.modal)),
        title: Text('Join Group Order', style: AppTypography.headingMd),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the invite code shared by your team.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(
                labelText: 'Invite Code',
                hintText: 'e.g. TECH-LUNCH-42',
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (ctrl.text.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Searching for group order...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oliveGreen,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

class _GroupOrderCard extends StatelessWidget {
  final GroupOrder groupOrder;
  final int index;

  const _GroupOrderCard({required this.groupOrder, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/client/group-orders/${groupOrder.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.group_rounded,
                      color: AppColors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(groupOrder.name,
                          style: AppTypography.titleMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (groupOrder.companyName != null)
                        Text(groupOrder.companyName!,
                            style: AppTypography.bodySm),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(groupOrder.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.lightBorder, height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _metaItem(Icons.calendar_today_outlined,
                    _formatDate(groupOrder.deliveryDate)),
                const SizedBox(width: AppSpacing.xl),
                _metaItem(Icons.schedule_outlined, groupOrder.deliveryTime),
                const SizedBox(width: AppSpacing.xl),
                _metaItem(Icons.group_outlined,
                    '${groupOrder.participantCount} joined'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order deadline',
                          style: AppTypography.caption),
                      Text(
                        groupOrder.deadlineCountdown,
                        style: AppTypography.labelMd.copyWith(
                          color: groupOrder.deadlinePassed
                              ? AppColors.errorRed
                              : AppColors.oliveGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                if (groupOrder.isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.oliveGreen,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant_menu_outlined,
                            size: 14, color: AppColors.white),
                        const SizedBox(width: 6),
                        Text('Select Meal',
                            style: AppTypography.labelSm
                                .copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: groupOrder.participantProgress,
                backgroundColor: AppColors.lightBorder,
                color: AppColors.oliveGreen,
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${groupOrder.participantCount} of ${groupOrder.maxParticipants} spots filled',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    ).animate().fade(
        delay: Duration(milliseconds: index * 100), duration: 300.ms);
  }

  Widget _metaItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }
}
