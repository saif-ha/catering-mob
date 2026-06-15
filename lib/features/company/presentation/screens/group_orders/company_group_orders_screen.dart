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

class CompanyGroupOrdersScreen extends ConsumerWidget {
  const CompanyGroupOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupOrders = MockData.groupOrders;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Group Orders'),
        backgroundColor: AppColors.creamBackground,
      ),
      body: groupOrders.isEmpty
          ? EmptyStateWidget(
              icon: Icons.group_outlined,
              title: 'No group orders',
              message: 'Create your first group order for your team.',
              actionLabel: 'Create Group Order',
              onAction: () => context.push('/company/group-orders/create'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: groupOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _CompanyGroupOrderCard(
                    groupOrder: groupOrders[i],
                    index: i,
                  ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/company/group-orders/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Group Order'),
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
      ),
    );
  }
}

class _CompanyGroupOrderCard extends StatelessWidget {
  final GroupOrder groupOrder;
  final int index;
  const _CompanyGroupOrderCard({required this.groupOrder, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/company/group-orders/${groupOrder.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.group_rounded, color: AppColors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(groupOrder.name, style: AppTypography.titleMd,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${groupOrder.participantCount} participants',
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
                _info(Icons.calendar_today_outlined, _formatDate(groupOrder.deliveryDate)),
                const SizedBox(width: AppSpacing.xl),
                _info(Icons.schedule_outlined, groupOrder.deliveryTime),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _info(Icons.timer_outlined, 'Deadline: ${groupOrder.deadlineCountdown}'),
                const Spacer(),
                if (groupOrder.estimatedTotal != null)
                  Text(
                    '\$${groupOrder.estimatedTotal!.toStringAsFixed(2)}',
                    style: AppTypography.titleSm.copyWith(color: AppColors.terracotta),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ParticipantProgress(groupOrder: groupOrder),
            if (groupOrder.joinCode != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.oliveLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.vpn_key_outlined, size: 14, color: AppColors.oliveGreen),
                    const SizedBox(width: 6),
                    Text('Code: ${groupOrder.joinCode}',
                        style: AppTypography.labelSm.copyWith(color: AppColors.oliveGreen)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 100), duration: 300.ms);
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _ParticipantProgress extends StatelessWidget {
  final GroupOrder groupOrder;
  const _ParticipantProgress({required this.groupOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Participants submitted', style: AppTypography.caption),
            Text(
              '${groupOrder.participants.where((p) => p.hasSubmitted).length}/${groupOrder.participantCount}',
              style: AppTypography.caption.copyWith(color: AppColors.oliveGreen),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: groupOrder.participantCount > 0
                ? groupOrder.participants.where((p) => p.hasSubmitted).length /
                    groupOrder.participantCount
                : 0,
            backgroundColor: AppColors.lightBorder,
            color: AppColors.oliveGreen,
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
