import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Text('Welcome to', style: AppTypography.bodyLg.copyWith(color: AppColors.mutedText))
                  .animate().fade(duration: 400.ms),
              Text('Platter Catering', style: AppTypography.displayMedium)
                  .animate().fade(delay: 100.ms, duration: 400.ms).slideX(begin: -0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'How will you be using Platter?',
                style: AppTypography.bodyLg.copyWith(color: AppColors.mutedText),
              ).animate().fade(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),
              _RoleCard(
                index: 0,
                icon: Icons.person_outline_rounded,
                title: 'Individual / Employee',
                subtitle: 'Order meals, join group orders, and manage your personal meal prep.',
                color: AppColors.oliveGreen,
                onTap: () => context.push('/register/client'),
              ),
              const SizedBox(height: AppSpacing.lg),
              _RoleCard(
                index: 1,
                icon: Icons.business_outlined,
                title: 'Company / Organization',
                subtitle: 'Manage employee orders, corporate catering events, and meal plans.',
                color: AppColors.terracotta,
                onTap: () => context.push('/register/company'),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Log In',
                      style: AppTypography.labelLg.copyWith(color: AppColors.oliveGreen),
                    ),
                  ),
                ],
              ).animate().fade(delay: 600.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMd),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: 300 + index * 150), duration: 400.ms)
        .slideX(begin: 0.1, end: 0);
  }
}
