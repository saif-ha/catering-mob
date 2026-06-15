import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardingPage(
      emoji: '🍽️',
      title: 'Premium Corporate\nCatering',
      subtitle:
          'Platter delivers gourmet meals crafted by professional chefs directly to your office — every day.',
      bgColor: AppColors.oliveGreen,
    ),
    _OnboardingPage(
      emoji: '👥',
      title: 'Group Orders\nMade Simple',
      subtitle:
          'Coordinate team lunches effortlessly. Each employee picks their meal, you place one order.',
      bgColor: AppColors.terracotta,
    ),
    _OnboardingPage(
      emoji: '📋',
      title: 'Meal Prep\nPlans for Teams',
      subtitle:
          'Set up recurring meal plans for your entire company. Fresh, healthy meals delivered on schedule.',
      bgColor: AppColors.warmGold,
    ),
    _OnboardingPage(
      emoji: '🎉',
      title: 'Corporate Catering\nfor Every Event',
      subtitle:
          'From board meetings to product launches — we handle every corporate event with elegance.',
      bgColor: Color(0xFF3D5A80),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _PageContent(page: _pages[i]),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLast = _page == _pages.length - 1;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.xl,
          AppSpacing.pagePadding,
          MediaQuery.of(context).padding.bottom + AppSpacing.xl,
        ),
        child: Column(
          children: [
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                dotColor: AppColors.white.withAlpha(80),
                activeDotColor: AppColors.white,
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 4,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (isLast) ...[
              AppButton(
                label: 'Get Started',
                onPressed: () => context.go('/choose-role'),
                variant: AppButtonVariant.ghost,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Already have an account? Log In',
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.white.withAlpha(200)),
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => context.go('/choose-role'),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.white.withAlpha(180)),
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white.withAlpha(40),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.bgColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                page.emoji,
                style: const TextStyle(fontSize: 80),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fade(duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                page.title,
                style: AppTypography.displayMedium
                    .copyWith(color: AppColors.white, height: 1.15),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.lg),
              Text(
                page.subtitle,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.white.withAlpha(210),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(delay: 350.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
  });
}
