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
import '../../../../../shared/widgets/status_badge.dart';
import '../../navigation/company_navigation.dart';

class CompanyDashboardScreen extends ConsumerWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = MockData.approvedCompany;
    final groupOrders = MockData.groupOrders;
    final cateringRequests = MockData.cateringRequests;
    final invoices = MockData.invoices;
    final unpaidInvoices = invoices.where((i) => !i.isPaid).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, ref, company)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  _buildMetricsGrid(context, ref, company, groupOrders, unpaidInvoices),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildQuickActions(context, ref),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildActiveGroupOrders(context, ref, groupOrders),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildRecentCatering(context, ref, cateringRequests),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildInvoiceAlert(context, ref, unpaidInvoices),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic company) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        MediaQuery.of(context).padding.top + 20,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    company.initials,
                    style: AppTypography.headingMd.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: AppTypography.titleLg
                            .copyWith(color: AppColors.white)),
                    Row(
                      children: [
                        StatusBadge.fromStatus(company.status,
                            size: BadgeSize.small),
                        const SizedBox(width: 8),
                        Text(company.industry,
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.white.withAlpha(180))),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Good ${_greeting()}, ${ref.watch(authProvider).user?.firstName ?? 'there'} 👋',
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.white.withAlpha(200)),
          ),
          Text(
            'Here\'s your company overview',
            style: AppTypography.headingSm.copyWith(color: AppColors.white),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }

  Widget _buildMetricsGrid(BuildContext context, WidgetRef ref,
      dynamic company, List groupOrders, List unpaidInvoices) {
    final metrics = [
      (Icons.people_rounded, '${company.memberCount}', 'Employees',
          AppColors.oliveGreen),
      (Icons.group_rounded, '${groupOrders.length}', 'Group Orders',
          AppColors.sageGreen),
      (Icons.attach_money_rounded,
          '\$${(company.monthlySpend / 1000).toStringAsFixed(1)}k',
          'Monthly Spend', AppColors.terracotta),
      (Icons.receipt_outlined, '${unpaidInvoices.length}', 'Unpaid Invoices',
          AppColors.warmGold),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) {
        final (icon, value, label, color) = metrics[i];
        return MetricCard(
          icon: icon,
          value: value,
          title: label,
          color: color,
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final actions = [
      (Icons.group_add_rounded, 'Group Order', AppColors.oliveGreen,
          () => ref.read(companyNavIndexProvider.notifier).state = 2),
      (Icons.event_available_rounded, 'Catering', AppColors.terracotta,
          () => ref.read(companyNavIndexProvider.notifier).state = 3),
      (Icons.person_add_outlined, 'Invite Staff', AppColors.sageGreen,
          () => context.push('/company/members/invite')),
      (Icons.restaurant_menu_rounded, 'Meal Plan', AppColors.warmGold,
          () => context.push('/company/meal-prep')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTypography.titleLg),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: actions
              .asMap()
              .entries
              .map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: e.key < actions.length - 1 ? 10 : 0),
                      child: GestureDetector(
                        onTap: e.value.$4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: e.value.$3.withAlpha(20),
                            borderRadius:
                                BorderRadius.circular(AppRadius.card),
                            border: Border.all(
                                color: e.value.$3.withAlpha(50)),
                          ),
                          child: Column(
                            children: [
                              Icon(e.value.$1,
                                  color: e.value.$3, size: 24),
                              const SizedBox(height: 6),
                              Text(
                                e.value.$2,
                                style: AppTypography.caption.copyWith(
                                    color: AppColors.charcoal,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    ).animate().fade(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildActiveGroupOrders(BuildContext context, WidgetRef ref, List groupOrders) {
    if (groupOrders.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Active Group Orders', style: AppTypography.titleLg),
            TextButton(
              onPressed: () =>
                  ref.read(companyNavIndexProvider.notifier).state = 2,
              child: Text('See All',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.oliveGreen)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...groupOrders.take(2).map((go) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GestureDetector(
                onTap: () => context.push('/company/group-orders/${go.id}'),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(Icons.group_rounded,
                            color: AppColors.white, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(go.name, style: AppTypography.titleSm),
                            Text(
                              '${go.participantCount} participants · ${go.deadlineCountdown}',
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                      ),
                      StatusBadge.fromStatus(go.status, size: BadgeSize.small),
                    ],
                  ),
                ),
              ),
            )),
      ],
    ).animate().fade(delay: 300.ms, duration: 300.ms);
  }

  Widget _buildRecentCatering(BuildContext context, WidgetRef ref, List requests) {
    if (requests.isEmpty) return const SizedBox.shrink();
    final req = requests.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Catering Request', style: AppTypography.titleLg),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => context.push('/company/catering/${req.id}'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.terracottaLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.event_outlined,
                      color: AppColors.terracotta, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req.eventType, style: AppTypography.titleSm),
                      Text(
                        req.numberOfGuests.toString() + ' guests · ' + req.serviceType,
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(req.status, size: BadgeSize.small),
              ],
            ),
          ),
        ),
      ],
    ).animate().fade(delay: 350.ms, duration: 300.ms);
  }

  Widget _buildInvoiceAlert(BuildContext context, WidgetRef ref, List unpaid) {
    if (unpaid.isEmpty) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => ref.read(companyNavIndexProvider.notifier).state = 4,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.goldLight,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.warmGold.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.receipt_outlined, color: AppColors.warmGold, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${unpaid.length} unpaid invoice${unpaid.length > 1 ? 's' : ''}',
                    style: AppTypography.titleSm.copyWith(color: AppColors.warmGold),
                  ),
                  Text('Tap to view and pay outstanding invoices.',
                      style: AppTypography.bodySm),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.warmGold),
          ],
        ),
      ),
    ).animate().fade(delay: 450.ms, duration: 300.ms);
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }
}
