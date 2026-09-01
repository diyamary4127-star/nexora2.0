import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../data/services/mock_data_service.dart';
import '../profile/profile_view_edit_screen.dart';
import '../admin/developer_admin_screen.dart';
import 'tabs/students_tab.dart';
import 'tabs/clubs_tab.dart';
import 'tabs/activity_tracker_tab.dart';

/// S4: Discover Screen with Instagram-style swipeable toggle for Students, Clubs & Activity Tracker
class DiscoverScreen extends StatefulWidget {
  final int initialTabIndex;

  const DiscoverScreen({super.key, this.initialTabIndex = 0});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentTab;
  final MockDataService _dataService = MockDataService();

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Students', 'icon': Icons.school_rounded},
    {'title': 'Clubs & Groups', 'icon': Icons.groups_rounded},
    {'title': 'Activity Tracker', 'icon': Icons.calendar_today_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTabIndex;
    _pageController = PageController(initialPage: _currentTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentTab = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final currentUser = _dataService.currentUser;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
                  child: Row(
                    children: [
                      // CET Connect Branding
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppShadows.soft3dButton,
                        ),
                        child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CET Connect',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentUser?.isClubAdmin == true ? 'Club Admin Hub' : 'Campus Hub',
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

                      const Spacer(),

                      // Admin Console Quick Shortcut
                      IconButton(
                        tooltip: 'Developer Stats',
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: AppShadows.soft3dChip,
                          ),
                          child: const Icon(Icons.insights_rounded, color: AppColors.primary, size: 18),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DeveloperAdminScreen()),
                          );
                        },
                      ),

                      // Profile Avatar Icon (View & Edit Profile)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileViewEditScreen()),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: currentUser?.avatarColor ?? AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.soft3dChipActive,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              (currentUser?.name.isNotEmpty == true)
                                  ? currentUser!.name.substring(0, 1)
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Instagram-style 3D Swipeable / Tap Toggle Mode Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.lightBlueTint.withValues(alpha: 0.9)),
                    boxShadow: AppShadows.soft3dCard,
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      final isSelected = _currentTab == index;
                      final tabInfo = _tabs[index];

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _onTabSelected(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.primaryGradient : null,
                              color: isSelected ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected ? AppShadows.soft3dChipActive : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  tabInfo['icon'] as IconData,
                                  size: 16,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tabInfo['title'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 4),

                // Swipeable PageView (Instagram-style Swipe Left/Right)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentTab = index;
                      });
                    },
                    children: const [
                      StudentsTab(),
                      ClubsTab(),
                      ActivityTrackerTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
