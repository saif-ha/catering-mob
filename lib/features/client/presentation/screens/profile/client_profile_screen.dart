import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/widgets/app_button.dart';

class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user ?? MockData.clientUser;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, user)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  _buildStats(),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildSection('Account', [
                    _ProfileTile(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () => context.push('/client/profile/edit')),
                    _ProfileTile(icon: Icons.location_on_outlined, label: 'My Addresses', onTap: () => context.push('/client/addresses')),
                    _ProfileTile(icon: Icons.favorite_outline_rounded, label: 'Favorite Meals', onTap: () {}),
                    _ProfileTile(icon: Icons.star_outline_rounded, label: 'My Reviews', onTap: () {}),
                  ], 0),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildSection('Company', [
                    _ProfileTile(
                      icon: Icons.business_outlined,
                      label: user.companyId != null ? 'TechFlow Solutions' : 'Join a Company',
                      subtitle: user.companyId != null ? 'Senior Engineer · Engineering' : 'Enter an invite code',
                      onTap: () {},
                    ),
                  ], 1),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildSection('Support', [
                    _ProfileTile(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
                    _ProfileTile(icon: Icons.policy_outlined, label: 'Privacy Policy', onTap: () {}),
                    _ProfileTile(icon: Icons.description_outlined, label: 'Terms of Service', onTap: () {}),
                  ], 2),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  AppButton(
                    label: 'Log Out',
                    variant: AppButtonVariant.ghost,
                    icon: Icons.logout_rounded,
                    onPressed: () => _confirmLogout(context, ref),
                  ).animate().fade(delay: 500.ms, duration: 300.ms),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Platter Catering v1.0.0',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        MediaQuery.of(context).padding.top + AppSpacing.xl,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.white.withAlpha(30),
            child: Text(
              user.initials,
              style: AppTypography.headingMd.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName,
                    style: AppTypography.titleLg
                        .copyWith(color: AppColors.white)),
                const SizedBox(height: 2),
                Text(user.email,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.white.withAlpha(180))),
                if (user.companyId != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('TechFlow Solutions',
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.white)),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/client/profile/edit'),
            icon: const Icon(Icons.edit_outlined,
                color: AppColors.white, size: 20),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms);
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          _statItem('12', 'Total Orders'),
          _divider(),
          _statItem('4.8', 'Avg Rating'),
          _divider(),
          _statItem('3', 'Group Orders'),
        ],
      ),
    ).animate().fade(delay: 200.ms, duration: 300.ms);
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style:
                  AppTypography.headingMd.copyWith(color: AppColors.oliveGreen)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
        width: 1, height: 36, color: AppColors.lightBorder);
  }

  Widget _buildSection(String title, List<Widget> tiles, int sectionIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.overline),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: List.generate(tiles.length, (i) {
              return Column(
                children: [
                  tiles[i],
                  if (i < tiles.length - 1)
                    const Divider(
                        height: 1, color: AppColors.lightBorder,
                        indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    ).animate().fade(
        delay: Duration(milliseconds: 200 + sectionIndex * 100),
        duration: 300.ms);
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.modal)),
        title: Text('Log Out', style: AppTypography.headingMd),
        content: Text('Are you sure you want to log out?',
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.mutedText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            child: Text('Log Out',
                style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.oliveLight,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Icon(icon, size: 18, color: AppColors.oliveGreen),
      ),
      title: Text(label, style: AppTypography.titleSm),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTypography.bodySm)
          : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.mutedText),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
