import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = MockData.members;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Team Members'),
        backgroundColor: AppColors.creamBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => context.push('/company/members/invite'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, 0, AppSpacing.pagePadding, AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.input),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.mutedText, size: 18),
                  const SizedBox(width: 8),
                  Text('Search members...',
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.mutedText)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: members.isEmpty
          ? EmptyStateWidget(
              icon: Icons.people_outline_rounded,
              title: 'No members yet',
              message:
                  'Invite your team members to join your company on Platter.',
              actionLabel: 'Invite Members',
              onAction: () => context.push('/company/members/invite'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: members.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _MemberCard(
                    member: members[i],
                    index: i,
                  ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/company/members/invite'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Invite Member'),
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final CompanyMember member;
  final int index;

  const _MemberCard({required this.member, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _avatarColor(index),
              child: Text(
                member.initials,
                style: AppTypography.titleSm.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(member.fullName,
                            style: AppTypography.titleSm,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      StatusBadge.fromStatus(member.status,
                          size: BadgeSize.small),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${member.roleInCompany} · ${member.department}',
                    style: AppTypography.bodySm,
                  ),
                  const SizedBox(height: 2),
                  Text(member.email,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: AppColors.mutedText, size: 20),
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'permissions', child: Text('Permissions')),
                const PopupMenuItem(
                    value: 'remove', child: Text('Remove Member')),
              ],
              onSelected: (v) {},
            ),
          ],
        ),
      ),
    ).animate().fade(
        delay: Duration(milliseconds: index * 80), duration: 300.ms);
  }

  Color _avatarColor(int i) {
    const colors = [
      AppColors.oliveGreen,
      AppColors.terracotta,
      AppColors.warmGold,
      AppColors.sageGreen,
    ];
    return colors[i % colors.length];
  }
}
