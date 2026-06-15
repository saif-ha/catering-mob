import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );

    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (auth.isAuthenticated && auth.user != null) {
      switch (auth.user!.role) {
        case 'client':
          context.go('/client');
        case 'company':
          context.go('/company');
        case 'admin':
          context.go('/admin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              _buildHeader(),
              const SizedBox(height: AppSpacing.xxxl),
              _buildDemoAccounts(),
              const SizedBox(height: AppSpacing.xxl),
              _buildForm(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.go('/onboarding'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.charcoal),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.oliveGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.restaurant_rounded, color: AppColors.white, size: 28),
        ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
        const SizedBox(height: AppSpacing.lg),
        Text('Welcome back', style: AppTypography.headingSm.copyWith(color: AppColors.mutedText))
            .animate().fade(delay: 100.ms, duration: 300.ms),
        Text('Log in to Platter', style: AppTypography.headingLg)
            .animate().fade(delay: 200.ms, duration: 300.ms).slideX(begin: -0.1, end: 0),
      ],
    );
  }

  Widget _buildDemoAccounts() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.warmGold.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warmGold),
              const SizedBox(width: 6),
              Text('Demo Accounts', style: AppTypography.titleSm.copyWith(color: AppColors.warmGold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Password for all: Password1', style: AppTypography.bodySm),
          const SizedBox(height: 8),
          _demoRow('Client', 'alex.morgan@email.com'),
          _demoRow('Company', 'admin@techflow.com'),
          _demoRow('Admin', 'admin@plattercatering.com'),
        ],
      ),
    ).animate().fade(delay: 300.ms, duration: 400.ms);
  }

  Widget _demoRow(String role, String email) {
    return GestureDetector(
      onTap: () => _emailCtrl.text = email,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warmGold.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(role, style: AppTypography.labelSm.copyWith(color: AppColors.warmGold)),
            ),
            const SizedBox(width: 8),
            Text(email, style: AppTypography.bodySm.copyWith(color: AppColors.oliveGreen)),
            const Spacer(),
            Icon(Icons.touch_app_rounded, size: 14, color: AppColors.mutedText.withAlpha(120)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AuthState auth) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Email Address',
            hint: 'you@company.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.email_outlined,
            validator: AppValidators.email,
          ).animate().fade(delay: 400.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Password',
            controller: _passCtrl,
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_outline_rounded,
            validator: (v) => v == null || v.isEmpty ? 'Password is required.' : null,
            onSubmitted: (_) => _login(),
          ).animate().fade(delay: 500.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/forgot-password'),
              child: Text(
                'Forgot Password?',
                style: AppTypography.labelMd.copyWith(color: AppColors.oliveGreen),
              ),
            ),
          ).animate().fade(delay: 550.ms, duration: 300.ms),
          if (auth.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.errorRed.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.errorRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(auth.error!,
                        style: AppTypography.bodySm.copyWith(color: AppColors.errorRed)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: 'Log In',
            onPressed: _login,
            isLoading: auth.isLoading,
          ).animate().fade(delay: 600.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
              ),
              TextButton(
                onPressed: () => context.go('/choose-role'),
                child: Text(
                  'Sign Up',
                  style: AppTypography.labelLg.copyWith(color: AppColors.oliveGreen),
                ),
              ),
            ],
          ).animate().fade(delay: 700.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
