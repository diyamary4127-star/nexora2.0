import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_card.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mock_data_service.dart';

/// Modal bottom sheet to view a student's full profile & connect
class StudentDetailModal extends StatelessWidget {
  final UserModel student;

  const StudentDetailModal({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final dataService = MockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final currentUser = dataService.currentUser;
        final isConnected = currentUser?.connectedUserIds.contains(student.id) ?? false;

        // Calculate shared hobbies
        final myHobbies = currentUser?.hobbies ?? [];
        final sharedHobbies = student.hobbies.where((h) => myHobbies.contains(h)).toList();

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 18),

              // Header with Avatar & Name
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: student.avatarColor,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.soft3dChipActive,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        student.name.isNotEmpty ? student.name.substring(0, 1) : 'S',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (student.isClubAdmin) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successBg,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'Club Lead',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${student.degree} ${student.branch} • Sem ${student.semester}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          student.email,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Shared Interests Banner (if any)
              if (sharedHobbies.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.iceBlue,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${sharedHobbies.length} Shared Interests: ${sharedHobbies.join(", ")}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Bio Card
              Soft3DCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      student.bio,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Hobbies Section
              const Text(
                'Hobbies & Interests',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: student.hobbies.map((hobby) {
                  final isShared = myHobbies.contains(hobby);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isShared ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isShared ? Colors.transparent : AppColors.lightBlueTint,
                      ),
                      boxShadow: isShared ? AppShadows.soft3dChipActive : AppShadows.soft3dChip,
                    ),
                    child: Text(
                      hobby,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isShared ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // Connect Button
              Row(
                children: [
                  Expanded(
                    child: Soft3DButton(
                      text: isConnected ? 'Connected (Tap to Disconnect)' : 'Send Connect Request',
                      type: isConnected ? Soft3DButtonType.secondary : Soft3DButtonType.primary,
                      icon: isConnected ? Icons.how_to_reg_rounded : Icons.person_add_alt_1_rounded,
                      onPressed: () {
                        dataService.toggleConnect(student.id);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
