import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/meal_card.dart';

final _selectedCategoryProvider = StateProvider<String?>((ref) => null);
final _searchQueryProvider = StateProvider<String>((ref) => '');
final _selectedTagsProvider = StateProvider<List<String>>((ref) => []);

class MealsListScreen extends ConsumerWidget {
  const MealsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(_selectedCategoryProvider);
    final query = ref.watch(_searchQueryProvider);
    final selectedTags = ref.watch(_selectedTagsProvider);

    List<MealModel> meals = MockMeals.meals;
    if (selectedCat != null) {
      meals = MockMeals.getMealsByCategory(selectedCat);
    }
    if (query.isNotEmpty) {
      meals = MockMeals.searchMeals(query);
    }
    if (selectedTags.isNotEmpty) {
      meals = meals
          .where((m) => selectedTags.any((t) => m.dietaryTags.contains(t)))
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Meals'),
            floating: true,
            snap: true,
            backgroundColor: AppColors.creamBackground,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Column(
                children: [
                  _SearchBar(ref: ref),
                  const SizedBox(height: 8),
                  _CategoryChips(ref: ref),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          if (selectedTags.isNotEmpty || selectedCat != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding, 0, AppSpacing.pagePadding, 8),
                child: _DietaryFilters(ref: ref),
              ),
            ),
          if (meals.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.no_food_outlined,
                title: 'No meals found',
                message: 'Try adjusting your search or filters.',
                actionLabel: 'Clear Filters',
                onAction: () {
                  ref.read(_selectedCategoryProvider.notifier).state = null;
                  ref.read(_searchQueryProvider.notifier).state = '';
                  ref.read(_selectedTagsProvider.notifier).state = [];
                },
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => MealCard(
                    meal: meals[i],
                    onTap: () => context.push('/client/meals/${meals[i].id}'),
                    onAddToCart: () => _addToCart(context, meals[i].name),
                  ).animate().fade(
                      delay: Duration(milliseconds: i * 60), duration: 300.ms),
                  childCount: meals.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 330,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, String mealName) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$mealName added to cart'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.charcoal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }
}

class _SearchBar extends StatelessWidget {
  final WidgetRef ref;
  const _SearchBar({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: TextField(
        onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
        style: AppTypography.bodyMd,
        decoration: InputDecoration(
          hintText: 'Search meals...',
          hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.mutedText, size: 20),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide:
                const BorderSide(color: AppColors.oliveGreen, width: 2),
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final WidgetRef ref;
  const _CategoryChips({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(_selectedCategoryProvider);
    final categories = [null, ...MockMeals.categories.map((c) => c)];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected =
              cat == null ? selected == null : selected == cat.id;
          return Padding(
            padding: EdgeInsets.only(right: i < categories.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => ref.read(_selectedCategoryProvider.notifier).state =
                  cat?.id,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.oliveGreen : AppColors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.oliveGreen
                        : AppColors.lightBorder,
                  ),
                ),
                child: Text(
                  cat == null ? 'All' : '${cat.iconEmoji} ${cat.name}',
                  style: AppTypography.labelMd.copyWith(
                    color:
                        isSelected ? AppColors.white : AppColors.charcoal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DietaryFilters extends StatelessWidget {
  final WidgetRef ref;
  const _DietaryFilters({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(_selectedTagsProvider);
    const tags = ['Vegetarian', 'Vegan', 'Gluten-Free', 'High Protein', 'Halal'];
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: tags.map((tag) {
        final isSelected = selected.contains(tag);
        return GestureDetector(
          onTap: () {
            final current = List<String>.from(selected);
            if (isSelected) current.remove(tag); else current.add(tag);
            ref.read(_selectedTagsProvider.notifier).state = current;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.oliveLight : AppColors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? AppColors.oliveGreen : AppColors.lightBorder,
              ),
            ),
            child: Text(tag,
                style: AppTypography.labelSm.copyWith(
                  color: isSelected ? AppColors.oliveGreen : AppColors.mutedText,
                )),
          ),
        );
      }).toList(),
    );
  }
}
