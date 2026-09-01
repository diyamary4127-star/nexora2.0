import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_card.dart';
import '../../../core/widgets/soft_3d_chip.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/services/mock_data_service.dart';
import '../widgets/add_activity_modal.dart';

/// Activity Tracker Tab: Club events/workshops & private friend activities timeline
class ActivityTrackerTab extends StatefulWidget {
  const ActivityTrackerTab({super.key});

  @override
  State<ActivityTrackerTab> createState() => _ActivityTrackerTabState();
}

class _ActivityTrackerTabState extends State<ActivityTrackerTab> {
  final MockDataService _dataService = MockDataService();
  String _activeFilter = 'All';

  final List<String> _filters = ['All', 'Club Events', 'Private Plans'];

  void _openAddActivity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddActivityModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final allActivities = _dataService.activities;

        final filteredActivities = allActivities.where((act) {
          if (_activeFilter == 'Club Events') {
            return act.type == ActivityType.clubEvent;
          } else if (_activeFilter == 'Private Plans') {
            return act.type != ActivityType.clubEvent;
          }
          return true;
        }).toList();

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                // Top Summary Card
                Soft3DCard(
                  gradient: AppColors.softBlueCardGradient,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.soft3dButton,
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Campus Schedule & Tracker',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${allActivities.where((a) => !a.isCompleted).length} Upcoming Sessions • ${allActivities.where((a) => a.type == ActivityType.clubEvent).length} Registered Workshops',
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
                ),

                const SizedBox(height: 14),

                // Filter Chips & Plan Activity Button
                Row(
                  children: [
                    ..._filters.map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Soft3DChip(
                            label: f,
                            isSelected: _activeFilter == f,
                            onTap: () => setState(() => _activeFilter = f),
                          ),
                        )),
                  ],
                ),

                const SizedBox(height: 16),

                // Activity List
                if (filteredActivities.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.event_busy_rounded, size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          'No activities scheduled',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Register for club workshops or create private study plans with your friends.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...filteredActivities.map((activity) {
                    final isClubEvent = activity.type == ActivityType.clubEvent;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Soft3DCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row: Type Badge + Time + Reminder Toggle
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: activity.badgeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: activity.badgeColor.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isClubEvent ? Icons.groups_rounded : Icons.person_pin_rounded,
                                        size: 12,
                                        color: activity.badgeColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isClubEvent ? 'Club Workshop' : 'Private Plan',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: activity.badgeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Reminder Icon Button
                                GestureDetector(
                                  onTap: () => _dataService.toggleActivityReminder(activity.id),
                                  child: Icon(
                                    activity.isReminderSet ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                                    size: 18,
                                    color: activity.isReminderSet ? AppColors.primary : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Completed Checkbox
                                GestureDetector(
                                  onTap: () => _dataService.toggleActivityCompleted(activity.id),
                                  child: Icon(
                                    activity.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                    size: 18,
                                    color: activity.isCompleted ? AppColors.success : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Activity Title
                            Text(
                              activity.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: activity.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                                decoration: activity.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Timing Row
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  activity.timeDisplay,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Venue Row
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    activity.location,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              activity.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),

                            // Host & Attending friends
                            if (activity.invitedFriends.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.lightBlueTint),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'With: ${activity.invitedFriends.join(", ")}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryDark,
                                      ),
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
              ],
            ),

            // Floating "+ Plan Private Activity" Button at bottom
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Soft3DButton(
                text: '+ Plan Private Activity with Friends',
                icon: Icons.add_circle_outline_rounded,
                onPressed: () => _openAddActivity(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
