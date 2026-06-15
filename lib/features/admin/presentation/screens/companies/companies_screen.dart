import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/company_model.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = MockData.allCompanies;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Companies'),
        backgroundColor: AppColors.creamBackground,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: companies.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => _CompanyCard(company: companies[i], index: i),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final int index;
  const _CompanyCard({required this.company, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(company.initials,
                      style: AppTypography.titleSm.copyWith(color: AppColors.white)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: AppTypography.titleMd),
                    Text('${company.industry} · ${company.size}',
                        style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
                  ],
                ),
              ),
              StatusBadge.fromStatus(company.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.lightBorder, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _info(Icons.people_outline_rounded, '${company.memberCount} members'),
              const SizedBox(width: AppSpacing.lg),
              _info(Icons.attach_money_rounded,
                  '\$${(company.monthlySpend / 1000).toStringAsFixed(1)}k/mo'),
              const Spacer(),
              if (company.isPending)
                Row(children: [
                  _actionBtn('Approve', AppColors.oliveGreen, () {}),
                  const SizedBox(width: 8),
                  _actionBtn('Reject', AppColors.errorRed, () {}, outlined: true),
                ]),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: Duration(milliseconds: index * 80), duration: 300.ms);
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
      ],
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap, {bool outlined = false}) {
    return outlined
        ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: color, side: BorderSide(color: color),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: Text(label, style: AppTypography.labelSm),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color, foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: Text(label, style: AppTypography.labelSm),
          );
  }
}
