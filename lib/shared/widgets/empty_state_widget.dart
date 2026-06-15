import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.oliveGreen).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: (iconColor ?? AppColors.oliveGreen).withAlpha(180),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                )
                .fade(duration: 300.ms),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: AppTypography.titleLg.copyWith(color: AppColors.charcoal),
              textAlign: TextAlign.center,
            )
                .animate()
                .fade(delay: 150.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
              textAlign: TextAlign.center,
            )
                .animate()
                .fade(delay: 250.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
                size: AppButtonSize.medium,
              )
                  .animate()
                  .fade(delay: 350.ms, duration: 300.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  const LoadingSkeleton.line({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  const LoadingSkeleton.circle({
    super.key,
    required double size,
    this.borderRadius,
  })  : width = size,
        height = size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppRadius.sm),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          color: AppColors.shimmerHighlight,
        );
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LoadingSkeleton.circle(size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingSkeleton.line(width: double.infinity * 0.6, height: 14),
                    const SizedBox(height: 8),
                    const LoadingSkeleton.line(height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton.line(height: 12),
          const SizedBox(height: 6),
          const LoadingSkeleton.line(height: 12),
          const SizedBox(height: 6),
          LoadingSkeleton.line(width: MediaQuery.of(context).size.width * 0.5, height: 12),
        ],
      ),
    );
  }
}
