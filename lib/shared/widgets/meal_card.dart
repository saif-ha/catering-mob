import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/models/meal_model.dart';

class MealCard extends StatefulWidget {
  final MealModel meal;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final bool compact;

  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onAddToCart,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.compact = false,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _handleFavorite() {
    _heartCtrl.forward().then((_) => _heartCtrl.reverse());
    widget.onToggleFavorite?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) return _buildCompact();
    return _buildFull();
  }

  Widget _buildFull() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: _buildInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.card),
          ),
          child: widget.meal.imageUrl != null
              ? Image.network(
                  widget.meal.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(),
                )
              : _imagePlaceholder(),
        ),
        if (widget.onToggleFavorite != null)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _handleFavorite,
              child: AnimatedBuilder(
                animation: _heartCtrl,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + _heartCtrl.value * 0.3,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(230),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: widget.isFavorite
                          ? AppColors.terracotta
                          : AppColors.mutedText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (widget.meal.isFeatured)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warmGold,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 11, color: AppColors.white),
                  const SizedBox(width: 3),
                  Text('Featured',
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.white)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.meal.name,
                style: AppTypography.titleMd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.meal.formattedPrice,
              style: AppTypography.titleMd
                  .copyWith(color: AppColors.terracotta),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.meal.description,
          style: AppTypography.bodySm,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _metaChip(Icons.local_fire_department_rounded,
                '${widget.meal.calories} cal', AppColors.terracotta),
            const SizedBox(width: 8),
            _metaChip(Icons.schedule_outlined, widget.meal.prepTime,
                AppColors.mutedText),
            const Spacer(),
            if (widget.meal.rating > 0) ...[
              const Icon(Icons.star_rounded,
                  size: 14, color: AppColors.warmGold),
              const SizedBox(width: 3),
              Text(
                widget.meal.rating.toStringAsFixed(1),
                style: AppTypography.labelMd
                    .copyWith(color: AppColors.charcoal),
              ),
              const SizedBox(width: 2),
              Text(
                '(${widget.meal.reviewCount})',
                style: AppTypography.bodySm,
              ),
            ],
          ],
        ),
        if (widget.meal.dietaryTags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.meal.dietaryTags
                .take(3)
                .map((tag) => _dietaryTag(tag))
                .toList(),
          ),
        ],
        if (widget.onAddToCart != null) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: widget.onAddToCart,
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oliveGreen,
                foregroundColor: AppColors.white,
                textStyle: AppTypography.labelMd,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompact() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
              child: widget.meal.imageUrl != null
                  ? Image.network(
                      widget.meal.imageUrl!,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(110),
                    )
                  : _imagePlaceholder(110),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.meal.name,
                    style: AppTypography.titleSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.meal.formattedPrice,
                    style: AppTypography.labelMd
                        .copyWith(color: AppColors.terracotta),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder([double height = 160]) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.softBeige,
      child: const Icon(Icons.restaurant_rounded,
          size: 40, color: AppColors.lightBorder),
    );
  }

  Widget _metaChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
      ],
    );
  }

  Widget _dietaryTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.oliveLight,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        tag,
        style: AppTypography.labelSm.copyWith(color: AppColors.oliveGreen),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                if (onTap != null)
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.mutedText),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(value,
                style: AppTypography.headingMd
                    .copyWith(color: AppColors.charcoal)),
            const SizedBox(height: 2),
            Text(title,
                style:
                    AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.successGreen)),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
