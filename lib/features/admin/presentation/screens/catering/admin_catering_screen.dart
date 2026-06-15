import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/catering_request_model.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminCateringScreen extends ConsumerWidget {
  const AdminCateringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = MockData.cateringRequests;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Catering Requests'),
        backgroundColor: AppColors.creamBackground,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_rounded), onPressed: () {}),
        ],
      ),
      body: requests.isEmpty
          ? const Center(child: Text('No catering requests'))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _AdminCateringCard(request: requests[i], index: i),
            ),
    );
  }
}

class _AdminCateringCard extends StatelessWidget {
  final CateringRequest request;
  final int index;
  const _AdminCateringCard({required this.request, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.terracottaLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.event_outlined, color: AppColors.terracotta, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.eventType, style: AppTypography.titleSm),
                    Text(request.companyName ?? request.contactPerson,
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
              _chip(Icons.attach_money_rounded, request.budgetRange),
              const Spacer(),
              if (request.isPending)
                Row(children: [
                  _actionBtn('Quote', AppColors.oliveGreen),
                  const SizedBox(width: 8),
                  _actionBtn('Decline', AppColors.errorRed, outlined: true),
                ]),
              if (request.quotedPrice != null)
                Text('\$${request.quotedPrice!.toStringAsFixed(0)}',
                    style: AppTypography.titleSm.copyWith(color: AppColors.terracotta)),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 80), duration: 300.ms);
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

  Widget _actionBtn(String label, Color color, {bool outlined = false}) {
    return outlined
        ? OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: color, side: BorderSide(color: color),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: Text(label, style: AppTypography.labelSm),
          )
        : ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color, foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: Text(label, style: AppTypography.labelSm),
          );
  }
}
