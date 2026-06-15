import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/widgets/meal_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = MockData.allCompanies;
    final orders = MockData.orders;
    final catering = MockData.cateringRequests;
    final invoices = MockData.invoices;
    final pendingCompanies = companies.where((c) => c.isPending).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, ref)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetrics(companies.length, orders.length, catering.length, invoices.length),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  if (pendingCompanies.isNotEmpty) ...[
                    _buildPendingCompanies(context, pendingCompanies),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                  _buildRecentActivity(context, orders, catering),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        MediaQuery.of(context).padding.top + 20,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.white, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Panel', style: AppTypography.titleLg.copyWith(color: AppColors.white)),
                Text('Platter Catering', style: AppTypography.bodySm.copyWith(color: AppColors.white.withAlpha(180))),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout_rounded, color: AppColors.white),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }

  Widget _buildMetrics(int companies, int orders, int catering, int invoices) {
    final metrics = [
      (Icons.business_rounded, '$companies', 'Companies', AppColors.oliveGreen),
      (Icons.receipt_long_rounded, '$orders', 'Orders', AppColors.sageGreen),
      (Icons.event_rounded, '$catering', 'Catering', AppColors.terracotta),
      (Icons.receipt_outlined, '$invoices', 'Invoices', AppColors.warmGold),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
      ),
      itemCount: 4,
      itemBuilder: (_, i) => MetricCard(
        icon: metrics[i].$1,
        value: metrics[i].$2,
        title: metrics[i].$3,
        color: metrics[i].$4,
      ),
    ).animate().fade(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildPendingCompanies(BuildContext context, List pending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.pending_actions_rounded, color: AppColors.warmGold, size: 18),
              const SizedBox(width: 6),
              Text('Pending Approvals', style: AppTypography.titleLg),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text('${pending.length}', style: AppTypography.labelSm.copyWith(color: AppColors.warmGold)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...pending.map((c) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.warmGold.withAlpha(60)),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(child: Text(c.initials, style: AppTypography.titleSm.copyWith(color: AppColors.warmGold))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name, style: AppTypography.titleSm),
                  Text(c.industry, style: AppTypography.bodySm),
                ],
              )),
              Row(children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.oliveGreen, foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  ),
                  child: const Text('Approve'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorRed, side: BorderSide(color: AppColors.errorRed),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  ),
                  child: const Text('Reject'),
                ),
              ]),
            ],
          ),
        )),
      ],
    ).animate().fade(delay: 300.ms, duration: 300.ms);
  }

  Widget _buildRecentActivity(BuildContext context, List orders, List catering) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Orders', style: AppTypography.titleLg),
        const SizedBox(height: AppSpacing.md),
        ...orders.take(3).map((o) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.receipt_long_outlined, color: AppColors.oliveGreen),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.id.substring(0, 8).toUpperCase(), style: AppTypography.titleSm),
                  Text(o.status, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
                ],
              )),
              Text('\$${o.total.toStringAsFixed(2)}',
                  style: AppTypography.titleSm.copyWith(color: AppColors.terracotta)),
            ],
          ),
        )),
      ],
    ).animate().fade(delay: 400.ms, duration: 300.ms);
  }
}
