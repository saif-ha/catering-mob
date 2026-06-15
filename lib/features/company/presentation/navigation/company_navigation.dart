import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../screens/dashboard/company_dashboard_screen.dart';
import '../screens/members/members_screen.dart';
import '../screens/group_orders/company_group_orders_screen.dart';
import '../screens/catering/company_catering_screen.dart';
import '../screens/billing/company_billing_screen.dart';

final companyNavIndexProvider = StateProvider<int>((ref) => 0);

class CompanyNavigation extends ConsumerWidget {
  const CompanyNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(companyNavIndexProvider);

    final screens = [
      const CompanyDashboardScreen(),
      const MembersScreen(),
      const CompanyGroupOrdersScreen(),
      const CompanyCateringScreen(),
      const CompanyBillingScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[index],
      ),
      bottomNavigationBar: _CompanyBottomNav(
        currentIndex: index,
        onTap: (i) => ref.read(companyNavIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _CompanyBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _CompanyBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
      (Icons.people_outline_rounded, Icons.people_rounded, 'Members'),
      (Icons.group_outlined, Icons.group_rounded, 'Group'),
      (Icons.event_outlined, Icons.event_rounded, 'Catering'),
      (Icons.receipt_outlined, Icons.receipt_rounded, 'Billing'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.lightBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final (iconOff, iconOn, label) = e.value;
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.terracottaLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? iconOn : iconOff,
                        size: 22,
                        color: isActive
                            ? AppColors.terracotta
                            : AppColors.mutedText,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        style: AppTypography.navLabel.copyWith(
                          color: isActive
                              ? AppColors.terracotta
                              : AppColors.mutedText,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
