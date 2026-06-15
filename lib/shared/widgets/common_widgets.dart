import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'app_button.dart';

// ── Section Header ────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.titleLg),
        if (trailing != null)
          trailing!
        else if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel!,
              style: AppTypography.labelMd.copyWith(color: AppColors.oliveGreen),
            ),
          ),
      ],
    );
  }
}

// ── Quantity Selector ─────────────────────────────────────────────────────────

class QuantitySelector extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;
  final int min;
  final int max;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 28.0 : 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _btn(
          icon: Icons.remove_rounded,
          onTap: value > min ? () => onChanged(value - 1) : null,
          size: size,
        ),
        SizedBox(
          width: compact ? 32 : 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: compact ? AppTypography.titleSm : AppTypography.titleMd,
          ),
        ),
        _btn(
          icon: Icons.add_rounded,
          onTap: value < max ? () => onChanged(value + 1) : null,
          size: size,
        ),
      ],
    );
  }

  Widget _btn({
    required IconData icon,
    required VoidCallback? onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.oliveGreen : AppColors.lightBorder,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          size: compact ? 14 : 18,
          color: onTap != null ? AppColors.white : AppColors.mutedText,
        ),
      ),
    );
  }
}

// ── Price Summary ─────────────────────────────────────────────────────────────

class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final double? discount;
  final String? promoCode;

  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    this.discount,
    this.promoCode,
  });

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
        children: [
          _row('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: AppSpacing.sm),
          _row('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
          const SizedBox(height: AppSpacing.sm),
          _row('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
          if (discount != null && discount! > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _row(
              promoCode != null ? 'Promo ($promoCode)' : 'Discount',
              '-\$${discount!.toStringAsFixed(2)}',
              valueColor: AppColors.successGreen,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.lightBorder),
          const SizedBox(height: AppSpacing.md),
          _row(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.titleMd
              : AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        ),
        Text(
          value,
          style: isBold
              ? AppTypography.titleMd.copyWith(color: AppColors.terracotta)
              : AppTypography.bodyMd.copyWith(
                  color: valueColor ?? AppColors.charcoal,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}

// ── Timeline Widget ───────────────────────────────────────────────────────────

class TimelineStep {
  final String status;
  final String label;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;
  final String? timestamp;

  const TimelineStep({
    required this.status,
    required this.label,
    required this.description,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
    this.timestamp,
  });
}

class TimelineWidget extends StatelessWidget {
  final List<TimelineStep> steps;

  const TimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        return _buildStep(step, isLast, i);
      }),
    );
  }

  Widget _buildStep(TimelineStep step, bool isLast, int index) {
    final color = step.isCompleted || step.isActive
        ? AppColors.oliveGreen
        : AppColors.lightBorder;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300 + index * 100),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? AppColors.oliveGreen
                    : step.isActive
                        ? AppColors.oliveLight
                        : AppColors.softBeige,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Icon(
                step.icon,
                size: 18,
                color: step.isCompleted
                    ? AppColors.white
                    : step.isActive
                        ? AppColors.oliveGreen
                        : AppColors.mutedText,
              ),
            ),
            if (!isLast)
              AnimatedContainer(
                duration: Duration(milliseconds: 400 + index * 100),
                width: 2,
                height: 40,
                color: step.isCompleted
                    ? AppColors.oliveGreen
                    : AppColors.lightBorder,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: isLast ? 0 : AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.label,
                      style: AppTypography.titleSm.copyWith(
                        color: step.isActive || step.isCompleted
                            ? AppColors.charcoal
                            : AppColors.mutedText,
                      ),
                    ),
                    if (step.timestamp != null)
                      Text(
                        step.timestamp!,
                        style: AppTypography.caption,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  step.description,
                  style: AppTypography.bodySm,
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fade(delay: Duration(milliseconds: index * 80), duration: 300.ms);
  }
}

// ── Step Progress Indicator ───────────────────────────────────────────────────

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> labels;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (i) {
            if (i.isOdd) {
              final stepIndex = i ~/ 2;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  color: stepIndex < currentStep - 1
                      ? AppColors.oliveGreen
                      : AppColors.lightBorder,
                ),
              );
            }
            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < currentStep - 1;
            final isActive = stepIndex == currentStep - 1;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.oliveGreen
                    : isActive
                        ? AppColors.oliveGreen
                        : AppColors.white,
                border: Border.all(
                  color: isCompleted || isActive
                      ? AppColors.oliveGreen
                      : AppColors.lightBorder,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: AppColors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: AppTypography.labelSm.copyWith(
                          color: isActive
                              ? AppColors.white
                              : AppColors.mutedText,
                        ),
                      ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .asMap()
              .entries
              .map((e) => Text(
                    e.value,
                    style: AppTypography.caption.copyWith(
                      color: e.key < currentStep
                          ? AppColors.oliveGreen
                          : AppColors.mutedText,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── Success Dialog ────────────────────────────────────────────────────────────

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Done',
    required this.onPressed,
    this.icon = Icons.check_circle_rounded,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'Done',
    required VoidCallback onPressed,
    IconData icon = Icons.check_circle_rounded,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.successGreen)
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: AppTypography.headingMd,
                textAlign: TextAlign.center)
                .animate()
                .fade(delay: 200.ms, duration: 300.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(message,
                style:
                    AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
                textAlign: TextAlign.center)
                .animate()
                .fade(delay: 300.ms, duration: 300.ms),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: buttonLabel,
              onPressed: onPressed,
            ).animate().fade(delay: 400.ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}

// ── Confirmation Dialog ───────────────────────────────────────────────────────

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.headingMd),
            const SizedBox(height: AppSpacing.sm),
            Text(message,
                style:
                    AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                    variant: AppButtonVariant.ghost,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    variant: isDangerous
                        ? AppButtonVariant.danger
                        : AppButtonVariant.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Bottom Sheet ──────────────────────────────────────────────────────────

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showHandle = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.bottomSheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding, AppSpacing.lg,
                  AppSpacing.pagePadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title!, style: AppTypography.titleLg),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 22,
                    color: AppColors.mutedText,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: AppSpacing.lg, color: AppColors.lightBorder),
          ] else
            const SizedBox(height: AppSpacing.md),
          child,
          SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.md),
        ],
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : AppColors.oliveLight,
          border: Border.all(color: AppColors.lightBorder),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _typeColor.withAlpha(30),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(_typeIcon, size: 20, color: _typeColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title, style: AppTypography.titleSm),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.oliveGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(body,
                      style: AppTypography.bodySm, maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(_timeAgo, style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _typeColor {
    switch (type) {
      case 'order': return AppColors.oliveGreen;
      case 'group_order': return AppColors.sageGreen;
      case 'catering': return AppColors.terracotta;
      case 'invoice': return AppColors.warmGold;
      case 'meal_prep': return AppColors.oliveGreen;
      default: return AppColors.mutedText;
    }
  }

  IconData get _typeIcon {
    switch (type) {
      case 'order': return Icons.receipt_long_outlined;
      case 'group_order': return Icons.group_outlined;
      case 'catering': return Icons.restaurant_outlined;
      case 'invoice': return Icons.description_outlined;
      case 'meal_prep': return Icons.calendar_today_outlined;
      default: return Icons.notifications_outlined;
    }
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
