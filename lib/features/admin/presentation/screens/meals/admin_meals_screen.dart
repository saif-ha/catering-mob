import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminMealsScreen extends ConsumerWidget {
  const AdminMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = MockMeals.meals;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Manage Meals'),
        backgroundColor: AppColors.creamBackground,
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, i) => _MealAdminTile(meal: meals[i], index: i),
      ),
    );
  }
}

class _MealAdminTile extends StatelessWidget {
  final MealModel meal;
  final int index;
  const _MealAdminTile({required this.meal, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.network(
              meal.imageUrl ?? '',
              width: 56, height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56, height: 56,
                color: AppColors.oliveLight,
                child: const Icon(Icons.restaurant_rounded, color: AppColors.oliveGreen),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: AppTypography.titleSm,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(meal.categoryName ?? meal.categoryId, style: AppTypography.bodySm
                    .copyWith(color: AppColors.mutedText)),
                Text(meal.formattedPrice,
                    style: AppTypography.labelSm.copyWith(color: AppColors.terracotta)),
              ],
            ),
          ),
          StatusBadge.fromStatus(meal.isAvailable ? 'active' : 'inactive'),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.mutedText, size: 20),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'toggle', child: Text('Toggle Availability')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 40), duration: 250.ms);
  }
}
