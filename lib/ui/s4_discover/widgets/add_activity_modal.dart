import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_chip.dart';
import '../../../core/widgets/soft_3d_text_field.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/services/mock_data_service.dart';

/// Modal to schedule a private activity or study group with friends
class AddActivityModal extends StatefulWidget {
  const AddActivityModal({super.key});

  @override
  State<AddActivityModal> createState() => _AddActivityModalState();
}

class _AddActivityModalState extends State<AddActivityModal> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController(text: 'Central Library 2nd Floor');
  final _timeController = TextEditingController(text: 'Tomorrow, 5:00 PM - 6:30 PM');
  final _descController = TextEditingController();

  ActivityType _selectedType = ActivityType.studyGroup;
  final List<String> _selectedFriends = [];

  final List<Map<String, dynamic>> _typeOptions = [
    {'type': ActivityType.studyGroup, 'label': 'Study Group', 'icon': Icons.menu_book_rounded},
    {'type': ActivityType.privatePlan, 'label': 'Hackathon / Project', 'icon': Icons.code_rounded},
    {'type': ActivityType.sports, 'label': 'Sports / Fitness', 'icon': Icons.sports_soccer_rounded},
    {'type': ActivityType.clubEvent, 'label': 'Club Activity', 'icon': Icons.groups_rounded},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSaveActivity() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an activity title')),
      );
      return;
    }

    final dataService = MockDataService();
    final currentUser = dataService.currentUser;

    Color badgeColor;
    switch (_selectedType) {
      case ActivityType.studyGroup:
        badgeColor = const Color(0xFF10B981);
        break;
      case ActivityType.privatePlan:
        badgeColor = const Color(0xFF2563EB);
        break;
      case ActivityType.sports:
        badgeColor = const Color(0xFFF59E0B);
        break;
      case ActivityType.clubEvent:
        badgeColor = const Color(0xFF8B5CF6);
        break;
    }

    final newActivity = ActivityModel(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: _selectedType,
      hostName: '${currentUser?.name ?? "You"} (Host)',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      timeDisplay: _timeController.text.trim().isNotEmpty
          ? _timeController.text.trim()
          : 'Tomorrow, 4:00 PM',
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : 'CET Campus',
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : 'Private collaborative activity planned with peers.',
      invitedFriends: _selectedFriends.isNotEmpty
          ? _selectedFriends
          : [currentUser?.name ?? 'You'],
      isCompleted: false,
      isReminderSet: true,
      badgeColor: badgeColor,
    );

    dataService.addPrivateActivity(newActivity);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity scheduled and added to your Activity Tracker!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = MockDataService();
    final allStudents = dataService.students;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
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

            const Text(
              'Plan Activity with Friends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Schedule private study sessions, lab practice, or sports matches with your connected peers.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 18),

            // Activity Type Selector
            const Text(
              'Activity Type',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _typeOptions.map((opt) {
                final isSelected = _selectedType == opt['type'];
                return Soft3DChip(
                  label: opt['label'] as String,
                  icon: opt['icon'] as IconData,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedType = opt['type'] as ActivityType),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            Soft3DTextField(
              label: 'Activity Title',
              hintText: 'e.g. Graph Algorithms & LeetCode Sprint',
              controller: _titleController,
              prefixIcon: const Icon(Icons.event_note_rounded, color: AppColors.primary),
            ),

            const SizedBox(height: 14),

            Soft3DTextField(
              label: 'Timing & Schedule',
              hintText: 'e.g. Tomorrow, 5:00 PM - 7:00 PM',
              controller: _timeController,
              prefixIcon: const Icon(Icons.access_time_rounded, color: AppColors.primary),
            ),

            const SizedBox(height: 14),

            // Quick CET Locations
            const Text(
              'Location / Venue',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                'Gazebo Lawn',
                'Archie Corner',
                'Dhwani Stage',
                'Central Library',
                'CS PG Lab',
                'CET Ground',
              ].map((spot) {
                final isSelected = _locationController.text == spot;
                return GestureDetector(
                  onTap: () => setState(() => _locationController.text = spot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.iceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      spot,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.primaryDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            Soft3DTextField(
              hintText: 'e.g. Gazebo / Archie Corner / CS Lab 3',
              controller: _locationController,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            ),

            const SizedBox(height: 14),

            Soft3DTextField(
              label: 'Description / Notes',
              hintText: 'Topic syllabus, equipment needed, or meeting goal...',
              controller: _descController,
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // Tag Friends / Peers
            const Text(
              'Invite Friends / Group Members',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allStudents.map((s) {
                final isInvited = _selectedFriends.contains(s.name);
                return Soft3DChip(
                  label: s.name,
                  isSelected: isInvited,
                  icon: isInvited ? Icons.check_circle_rounded : Icons.person_add_alt,
                  onTap: () {
                    setState(() {
                      if (isInvited) {
                        _selectedFriends.remove(s.name);
                      } else {
                        _selectedFriends.add(s.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Soft3DButton(
              text: 'Save & Add to Activity Tracker',
              icon: Icons.calendar_today_rounded,
              onPressed: _onSaveActivity,
            ),
          ],
        ),
      ),
    );
  }
}
