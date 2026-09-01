import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_card.dart';
import '../../../data/models/club_model.dart';
import '../../../data/services/mock_data_service.dart';

/// Full Club details modal with portfolio, leadership team management, and event registrations
class ClubDetailModal extends StatefulWidget {
  final ClubModel club;

  const ClubDetailModal({super.key, required this.club});

  @override
  State<ClubDetailModal> createState() => _ClubDetailModalState();
}

class _ClubDetailModalState extends State<ClubDetailModal> {
  final MockDataService _dataService = MockDataService();

  void _showAddMemberDialog(String roleType) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add $roleType',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the full name of the student you wish to assign as $roleType for ${widget.club.name}.',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Rahul Ramesh',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.lightBlueTint),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                if (roleType == 'Co-Leader') {
                  _dataService.addClubCoLeader(widget.club.id, name);
                } else {
                  _dataService.addClubModerator(widget.club.id, name);
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$roleType "$name" added successfully!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Add Member', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        // Find latest club state
        final currentClub = _dataService.clubs.firstWhere(
          (c) => c.id == widget.club.id,
          orElse: () => widget.club,
        );

        final currentUser = _dataService.currentUser;
        final isFollowing = currentUser?.followingClubIds.contains(currentClub.id) ?? false;
        final isJoined = currentUser?.joinedClubIds.contains(currentClub.id) ?? false;
        final isPendingJoin = currentUser?.pendingClubJoinIds.contains(currentClub.id) ?? false;

        // Is current user the leader of this club?
        final isLeader = (currentUser != null &&
            (currentUser.id == currentClub.leaderId ||
                currentUser.clubName?.toLowerCase() == currentClub.name.toLowerCase() ||
                currentUser.role.name == 'developerAdmin'));

        // Events hosted by this club
        final clubEvents = _dataService.events.where((e) => e.clubId == currentClub.id).toList();

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Header Banner & Category
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [currentClub.themeColor, currentClub.themeColor.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft3dChipActive,
                      ),
                      child: Icon(currentClub.icon, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  currentClub.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (currentClub.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, color: AppColors.primary, size: 18),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.iceBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  currentClub.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${currentClub.memberCount} Members • ${currentClub.followerCount} Followers',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Action Buttons: Join Request & Follow
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Soft3DButton(
                        text: isJoined
                            ? 'Member (Joined)'
                            : (isPendingJoin ? 'Join Request Sent' : 'Send Join Request'),
                        icon: isJoined
                            ? Icons.check_circle_rounded
                            : (isPendingJoin ? Icons.hourglass_top_rounded : Icons.group_add_rounded),
                        type: isJoined
                            ? Soft3DButtonType.secondary
                            : (isPendingJoin ? Soft3DButtonType.outline : Soft3DButtonType.primary),
                        onPressed: () {
                          _dataService.toggleClubJoinRequest(currentClub.id);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: Soft3DButton(
                        text: isFollowing ? 'Following' : 'Follow',
                        icon: isFollowing ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                        type: isFollowing ? Soft3DButtonType.secondary : Soft3DButtonType.outline,
                        onPressed: () {
                          _dataService.toggleClubFollow(currentClub.id);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Portfolio / Description Card
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Club Portfolio & Vision',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentClub.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: currentClub.tags.map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#$t',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Leadership & Team Structure Card
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Leadership Team',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isLeader)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'You are Leader',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Club Leader
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LEADER',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            currentClub.leaderName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Co-Leaders
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CO-LEADS',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentClub.coLeaderNames.isNotEmpty
                                  ? currentClub.coLeaderNames.join(', ')
                                  : 'None added yet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: currentClub.coLeaderNames.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Moderators
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'MODERATORS',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentClub.moderatorNames.isNotEmpty
                                  ? currentClub.moderatorNames.join(', ')
                                  : 'None added yet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: currentClub.moderatorNames.isNotEmpty
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Leader actions to add co-leaders and moderators
                      if (isLeader) ...[
                        const SizedBox(height: 14),
                        const Divider(color: AppColors.lightBlueTint),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Soft3DButton(
                                text: '+ Add Co-Leader',
                                height: 38,
                                type: Soft3DButtonType.secondary,
                                onPressed: () => _showAddMemberDialog('Co-Leader'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Soft3DButton(
                                text: '+ Add Moderator',
                                height: 38,
                                type: Soft3DButtonType.secondary,
                                onPressed: () => _showAddMemberDialog('Moderator'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Upcoming Events Hosted by this Club
                if (clubEvents.isNotEmpty) ...[
                  const Text(
                    'Upcoming Events & Workshops',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...clubEvents.map((evt) {
                    final isRegistered = currentUser?.registeredEventIds.contains(evt.id) ?? false;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Soft3DCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: evt.accentColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(evt.icon, color: evt.accentColor, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        evt.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${evt.timeString} • ${evt.venue}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              evt.description,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            Soft3DButton(
                              text: isRegistered ? 'Registered (In Activity Tracker)' : 'Register for Event',
                              height: 38,
                              type: isRegistered ? Soft3DButtonType.secondary : Soft3DButtonType.primary,
                              icon: isRegistered ? Icons.event_available_rounded : Icons.add_circle_outline_rounded,
                              onPressed: () {
                                _dataService.registerForEvent(evt);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
