import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/soft_3d_card.dart';
import '../../data/services/mock_data_service.dart';
import 'chat_screen.dart';

/// Direct Messages & Friend Inbox sheet
class MessagesInboxSheet extends StatelessWidget {
  const MessagesInboxSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = MockDataService();

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final currentUser = dataService.currentUser;
        final connectedIds = currentUser?.connectedUserIds ?? [];
        final connectedFriends = dataService.students.where((s) => connectedIds.contains(s.id)).toList();

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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Direct Messages',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.iceBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${connectedFriends.length} Friends',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chat in real-time with connected peers across CET branches',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 16),

                if (connectedFriends.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 10),
                        const Text(
                          'No connected friends yet',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Connect with students in the Discover tab to start chatting.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  ...connectedFriends.map((friend) {
                    final msgs = dataService.getMessagesWith(friend.id);
                    final lastMsg = msgs.isNotEmpty ? msgs.last.text : 'Tap to start conversation';
                    final lastTime = msgs.isNotEmpty
                        ? '${msgs.last.timestamp.hour.toString().padLeft(2, '0')}:${msgs.last.timestamp.minute.toString().padLeft(2, '0')}'
                        : '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Soft3DCard(
                        padding: const EdgeInsets.all(12),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ChatScreen(peer: friend)),
                          );
                        },
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: friend.avatarColor,
                                    shape: BoxShape.circle,
                                    boxShadow: AppShadows.soft3dChipActive,
                                  ),
                                  child: Center(
                                    child: Text(
                                      friend.name.isNotEmpty ? friend.name.substring(0, 1) : 'S',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 11,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        friend.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (lastTime.isNotEmpty)
                                        Text(
                                          lastTime,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lastMsg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: msgs.isNotEmpty ? AppColors.textSecondary : AppColors.primary,
                                      fontWeight: msgs.isNotEmpty ? FontWeight.w400 : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
