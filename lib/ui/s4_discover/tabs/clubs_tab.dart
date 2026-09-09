import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_card.dart';
import '../../../core/widgets/soft_3d_chip.dart';
import '../../../data/models/club_model.dart';
import '../../../data/services/mock_data_service.dart';
import '../widgets/club_detail_modal.dart';

/// Clubs & Communities Tab: Explore clubs, send join requests, follow updates, view portfolios
class ClubsTab extends StatefulWidget {
  const ClubsTab({super.key});

  @override
  State<ClubsTab> createState() => _ClubsTabState();
}

class _ClubsTabState extends State<ClubsTab> {
  final MockDataService _dataService = MockDataService();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Technical',
    'Cultural',
    'Entrepreneurship',
    'Sports',
    'Social & Volunteering',
  ];

  void _openClubDetail(BuildContext context, ClubModel club) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ClubDetailModal(club: club),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final currentUser = _dataService.currentUser;
        final filteredClubs = _dataService.clubs.where((club) {
          if (_selectedCategory != 'All' && club.category != _selectedCategory) {
            return false;
          }
          return true;
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Soft3DChip(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Header Banner
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Clubs & Communities',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Tap to view team & events',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ...filteredClubs.map((club) {
              final isFollowing = currentUser?.followingClubIds.contains(club.id) ?? false;
              final isJoined = currentUser?.joinedClubIds.contains(club.id) ?? false;
              final isPending = currentUser?.pendingClubJoinIds.contains(club.id) ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: Soft3DCard(
                  onTap: () => _openClubDetail(context, club),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [club.themeColor, club.themeColor.withValues(alpha: 0.8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: AppShadows.soft3dChipActive,
                            ),
                            child: Icon(club.icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        club.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (club.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified_rounded, color: AppColors.primary, size: 16),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.iceBlue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        club.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${club.memberCount} members • Lead: ${club.leaderName.split(' ').first}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Portfolio Snippet
                      Text(
                        club.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: club.tags.take(3).map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoft,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.lightBlueTint),
                            ),
                            child: Text(
                              '#$t',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // Join Request & Follow Buttons or Leader Panel
                      if (club.leaderId == currentUser?.id || (currentUser?.isClubAdmin == true && currentUser?.clubName?.toLowerCase() == club.name.toLowerCase())) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Soft3DButton(
                                text: 'Host Workshop',
                                height: 38,
                                type: Soft3DButtonType.primary,
                                icon: Icons.add_rounded,
                                onPressed: () {
                                  _openClubDetail(context, club);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Soft3DButton(
                                text: 'Manage Team',
                                height: 38,
                                type: Soft3DButtonType.secondary,
                                icon: Icons.shield_rounded,
                                onPressed: () {
                                  _openClubDetail(context, club);
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Soft3DButton(
                                text: isJoined
                                    ? 'Joined Member'
                                    : (isPending ? 'Request Pending' : 'Send Join Request'),
                                height: 38,
                                type: isJoined
                                    ? Soft3DButtonType.secondary
                                    : (isPending ? Soft3DButtonType.outline : Soft3DButtonType.primary),
                                icon: isJoined
                                    ? Icons.check_circle_rounded
                                    : (isPending ? Icons.hourglass_top_rounded : Icons.group_add_rounded),
                                onPressed: () {
                                  _dataService.toggleClubJoinRequest(club.id);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 4,
                              child: Soft3DButton(
                                text: isFollowing ? 'Following' : 'Follow',
                                height: 38,
                                type: isFollowing ? Soft3DButtonType.secondary : Soft3DButtonType.outline,
                                icon: isFollowing ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                                onPressed: () {
                                  _dataService.toggleClubFollow(club.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
