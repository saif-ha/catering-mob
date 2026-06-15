import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/widgets/meal_card.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../navigation/client_navigation.dart';

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final featuredMeals = MockMeals.getFeaturedMeals();
    final activeOrders = MockData.orders.where((o) => o.isActive).toList();
    final groupOrders = MockData.groupOrders.where((g) => g.isOpen).toList();
    final notifications = MockData.notifications.where((n) => !n.isRead).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref, user?.firstName ?? 'there', notifications.length),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(context),
                _buildQuickActions(context, ref),
                if (activeOrders.isNotEmpty)
                  _buildActiveOrders(context, ref, activeOrders),
                if (groupOrders.isNotEmpty)
                  _buildGroupOrderBanner(context, ref, groupOrders),
                _buildFeaturedMeals(context, ref, featuredMeals),
                _buildCategories(context, ref),
                const SizedBox(height: AppSpacing.huge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, WidgetRef ref,
      String firstName, int notifCount) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      snap: true,
      backgroundColor: AppColors.creamBackground,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, 16, AppSpacing.pagePadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good ${_greeting()}, 👋',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.mutedText)),
                    Text(firstName,
                        style: AppTypography.headingMd),
                  ],
                ).animate().fade(duration: 400.ms).slideX(begin: -0.1, end: 0),
                Row(
                  children: [
                    _iconBtn(
                      icon: Icons.notifications_outlined,
                      badge: notifCount,
                      onTap: () => context.push('/client/notifications'),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => ref
                          .read(clientNavIndexProvider.notifier)
                          .state = 4,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.oliveGreen,
                        child: Text(
                          ref.watch(authProvider).user?.initials ?? '?',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ).animate().fade(delay: 100.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0,
          AppSpacing.pagePadding, AppSpacing.lg),
      child: GestureDetector(
        onTap: () => context.push('/client/meals/search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: Border.all(color: AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  color: AppColors.mutedText, size: 20),
              const SizedBox(width: 10),
              Text('Search meals, categories...',
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.mutedText)),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: 150.ms, duration: 300.ms);
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final actions = [
      _QuickAction(icon: Icons.restaurant_menu_rounded, label: 'Order Meal',
          color: AppColors.oliveGreen,
          onTap: () => ref.read(clientNavIndexProvider.notifier).state = 1),
      _QuickAction(icon: Icons.group_rounded, label: 'Group Order',
          color: AppColors.terracotta,
          onTap: () => ref.read(clientNavIndexProvider.notifier).state = 2),
      _QuickAction(icon: Icons.calendar_today_rounded, label: 'Meal Prep',
          color: AppColors.warmGold,
          onTap: () => context.push('/client/meal-prep')),
      _QuickAction(icon: Icons.event_available_rounded, label: 'Catering',
          color: const Color(0xFF3D5A80),
          onTap: () => context.push('/client/catering-request')),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0,
          AppSpacing.pagePadding, AppSpacing.sectionSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions
            .asMap()
            .entries
            .map((e) => _quickActionCard(e.value, e.key))
            .toList(),
      ),
    );
  }

  Widget _quickActionCard(_QuickAction action, int index) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: action.color.withAlpha(20),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: action.color.withAlpha(40)),
            ),
            child: Icon(action.icon, color: action.color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(action.label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.charcoal, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: 200 + index * 60), duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildActiveOrders(BuildContext context, WidgetRef ref, List<dynamic> orders) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0,
          AppSpacing.pagePadding, AppSpacing.sectionSpacing),
      child: Column(
        children: [
          SectionHeader(
            title: 'Active Orders',
            actionLabel: 'See All',
            onAction: () => ref.read(clientNavIndexProvider.notifier).state = 3,
          ),
          const SizedBox(height: AppSpacing.md),
          ...orders.take(2).map((order) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _ActiveOrderCard(order: order),
          )),
        ],
      ),
    );
  }

  Widget _buildGroupOrderBanner(BuildContext context, WidgetRef ref, List<dynamic> groupOrders) {
    final go = groupOrders.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, 0,
          AppSpacing.pagePadding, AppSpacing.sectionSpacing),
      child: GestureDetector(
        onTap: () => context.push('/client/group-orders/${go.id}'),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            children: [
              const Icon(Icons.group_rounded, color: AppColors.white, size: 32),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(go.name,
                        style: AppTypography.titleMd
                            .copyWith(color: AppColors.white)),
                    Text(
                      '${go.participantCount} participants • ${go.deadlineCountdown}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.white.withAlpha(200)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text('Select Meal',
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.white)),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: 400.ms, duration: 300.ms);
  }

  Widget _buildFeaturedMeals(BuildContext context, WidgetRef ref, List<dynamic> meals) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: SectionHeader(
              title: 'Featured Meals',
              actionLabel: 'View All',
              onAction: () => ref.read(clientNavIndexProvider.notifier).state = 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              itemCount: meals.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(right: i < meals.length - 1 ? 12 : 0),
                child: SizedBox(
                  width: 200,
                  child: MealCard(
                    meal: meals[i],
                    compact: false,
                    onTap: () => context.push('/client/meals/${meals[i].id}'),
                    onAddToCart: () => _addToCart(context, meals[i].name),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    final categories = MockMeals.categories;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Browse by Category'),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              return GestureDetector(
                onTap: () => context.push('/client/meals?category=${cat.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat.iconEmoji ?? '🍽️',
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(cat.name,
                          style: AppTypography.caption.copyWith(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ).animate().fade(
                  delay: Duration(milliseconds: 500 + i * 60), duration: 300.ms);
            },
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, String mealName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$mealName added to cart'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.charcoal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _iconBtn({required IconData icon, int badge = 0, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Icon(icon, size: 20, color: AppColors.charcoal),
          ),
          if (badge > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.terracotta,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$badge',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.white, fontSize: 9)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
}

class _ActiveOrderCard extends StatelessWidget {
  final dynamic order;
  const _ActiveOrderCard({required this.order});

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
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.oliveLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: AppColors.oliveGreen, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNumber, style: AppTypography.titleSm),
                  Text(
                    '${order.totalItems} item${order.totalItems > 1 ? 's' : ''} · \$${order.total.toStringAsFixed(2)}',
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
            ),
            StatusBadge.fromStatus(order.status),
          ],
        ),
      ),
    );
  }
}
