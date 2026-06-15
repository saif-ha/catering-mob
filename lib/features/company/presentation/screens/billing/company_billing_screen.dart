import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/invoice_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompanyBillingScreen extends ConsumerWidget {
  const CompanyBillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = MockData.invoices;
    final unpaid = invoices.where((i) => !i.isPaid).toList();
    final totalDue = unpaid.fold<double>(0, (sum, i) => sum + i.total);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Billing & Invoices'),
        backgroundColor: AppColors.creamBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          if (unpaid.isNotEmpty) _SummaryBanner(unpaidCount: unpaid.length, totalDue: totalDue),
          if (unpaid.isNotEmpty) const SizedBox(height: AppSpacing.sectionSpacing),
          Text('All Invoices', style: AppTypography.titleLg),
          const SizedBox(height: AppSpacing.md),
          if (invoices.isEmpty)
            EmptyStateWidget(
              icon: Icons.receipt_outlined,
              title: 'No invoices yet',
              message: 'Invoices from your catering requests will appear here.',
            )
          else
            ...invoices.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _InvoiceCard(invoice: e.value, index: e.key),
                  ),
                ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int unpaidCount;
  final double totalDue;
  const _SummaryBanner({required this.unpaidCount, required this.totalDue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.white, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${totalDue.toStringAsFixed(2)} Due',
                  style: AppTypography.headingMd.copyWith(color: AppColors.white),
                ),
                Text(
                  '$unpaidCount unpaid invoice${unpaidCount > 1 ? 's' : ''}',
                  style: AppTypography.bodySm.copyWith(color: AppColors.white.withAlpha(200)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.warmGold,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: const Text('Pay All'),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final int index;
  const _InvoiceCard({required this.invoice, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/company/invoices/${invoice.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: invoice.isOverdue ? AppColors.errorRed.withAlpha(100) : AppColors.lightBorder,
          ),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: invoice.isPaid ? AppColors.oliveLight : AppColors.goldLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    invoice.isPaid ? Icons.check_circle_outline_rounded : Icons.receipt_outlined,
                    color: invoice.isPaid ? AppColors.oliveGreen : AppColors.warmGold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoice.invoiceNumber, style: AppTypography.titleSm),
                      Text(invoice.invoiceType,
                          style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(invoice.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.lightBorder, height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: AppTypography.caption),
                    Text(
                      '\$${invoice.total.toStringAsFixed(2)}',
                      style: AppTypography.titleMd.copyWith(color: AppColors.terracotta),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Due Date', style: AppTypography.caption),
                    Text(
                      _fmtDate(invoice.dueDate),
                      style: AppTypography.titleSm.copyWith(
                        color: invoice.isOverdue ? AppColors.errorRed : AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
                if (!invoice.isPaid)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.oliveGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    ),
                    child: const Text('Pay Now'),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 100), duration: 300.ms);
  }

  String _fmtDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }
}
