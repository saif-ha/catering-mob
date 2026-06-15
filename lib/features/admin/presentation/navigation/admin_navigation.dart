import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../screens/dashboard/admin_dashboard_screen.dart';
import '../screens/companies/companies_screen.dart';
import '../screens/meals/admin_meals_screen.dart';
import '../screens/orders/admin_orders_screen.dart';
import '../screens/catering/admin_catering_screen.dart';

final adminNavIndexProvider = StateProvider<int>((ref) => 0);

class AdminNavigation extends ConsumerWidget {
  const AdminNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(adminNavIndexProvider);

    final screens = [
      const AdminDashboardScreen(),
      const CompaniesScreen(),
      const AdminMealsScreen(),
      const AdminOrdersScreen(),
      const AdminCateringScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[index],
      ),
      bottomNavigationBar: _AdminBottomNav(
        currentIndex: index,
        onTap: (i) => ref.read(adminNavIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const _AdminBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
      (Icons.business_outlined, Icons.business_rounded, 'Companies'),
      (Icons.restaurant_menu_outlined, Icons.restaurant_menu_rounded, 'Meals'),
      (Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Orders'),
      (Icons.event_outlined, Icons.event_rounded, 'Catering'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.lightBorder)),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 20, offset: const Offset(0, -4))],
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.oliveLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isActive ? iconOn : iconOff, size: 22,
                          color: isActive ? AppColors.oliveGreen : AppColors.mutedText),
                      const SizedBox(height: 3),
                      Text(label,
                          style: AppTypography.navLabel.copyWith(
                            color: isActive ? AppColors.oliveGreen : AppColors.mutedText,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          )),
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
