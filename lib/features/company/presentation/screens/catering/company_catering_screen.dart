import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/catering_request_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompanyCateringScreen extends ConsumerWidget {
  const CompanyCateringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = MockData.cateringRequests;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Catering Requests'),
        backgroundColor: AppColors.creamBackground,
      ),
      body: requests.isEmpty
          ? EmptyStateWidget(
              icon: Icons.event_outlined,
              title: 'No catering requests',
              message: 'Plan your next corporate event with a catering request.',
              actionLabel: 'Request Catering',
              onAction: () => context.push('/company/catering/new'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _CateringRequestCard(request: requests[i], index: i),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/company/catering/new'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Request'),
        backgroundColor: AppColors.terracotta,
        foregroundColor: AppColors.white,
      ),
    );
  }
}

class _CateringRequestCard extends StatelessWidget {
  final CateringRequest request;
  final int index;

  const _CateringRequestCard({required this.request, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/company/catering/${request.id}'),
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
                    color: AppColors.terracottaLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.event_outlined, color: AppColors.terracotta, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.eventType, style: AppTypography.titleMd),
                      Text(request.serviceType,
                          style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(request.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.lightBorder, height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _chip(Icons.people_outline_rounded, '${request.numberOfGuests} guests'),
                const SizedBox(width: AppSpacing.md),
                _chip(Icons.calendar_today_outlined, _fmtDate(request.eventDate)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _chip(Icons.schedule_outlined, request.eventTime),
                const SizedBox(width: AppSpacing.md),
                _chip(Icons.attach_money_rounded, request.budgetRange),
              ],
            ),
            if (request.dietaryRestrictions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: request.dietaryRestrictions.take(3).map((d) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.oliveLight,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(d,
                      style: AppTypography.caption.copyWith(color: AppColors.oliveGreen)),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 100), duration: 300.ms);
  }

  Widget _chip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
      ],
    );
  }

  String _fmtDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }
}
