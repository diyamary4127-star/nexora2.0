import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/soft_3d_button.dart';
import '../../core/widgets/soft_3d_card.dart';
import '../../core/widgets/soft_3d_chip.dart';
import '../../core/widgets/soft_3d_text_field.dart';
import '../../data/services/mock_data_service.dart';

/// Developer & Admin Statistics Dashboard
class DeveloperAdminScreen extends StatefulWidget {
  const DeveloperAdminScreen({super.key});

  @override
  State<DeveloperAdminScreen> createState() => _DeveloperAdminScreenState();
}

class _DeveloperAdminScreenState extends State<DeveloperAdminScreen> {
  final MockDataService _dataService = MockDataService();
  final _searchController = TextEditingController();
  String _roleFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final totalUsers = _dataService.totalUsers;
        final totalStudents = _dataService.totalStudents;
        final totalClubAdmins = _dataService.totalClubAdmins;
        final totalClubs = _dataService.totalClubs;
        final totalEvents = _dataService.totalEvents;
        final totalActivities = _dataService.totalActivities;

        final query = _searchController.text.trim().toLowerCase();

        // Combine current user and mock students for admin registry
        final allProfiles = [
          if (_dataService.currentUser != null) _dataService.currentUser!,
          ..._dataService.students,
        ];

        final filteredProfiles = allProfiles.where((p) {
          if (_roleFilter == 'Students' && p.isClubAdmin) return false;
          if (_roleFilter == 'Club Admins' && !p.isClubAdmin) return false;

          if (query.isNotEmpty) {
            final matchName = p.name.toLowerCase().contains(query);
            final matchEmail = p.email.toLowerCase().contains(query);
            final matchBranch = p.branch.toLowerCase().contains(query);
            final matchClub = (p.clubName ?? '').toLowerCase().contains(query);
            if (!matchName && !matchEmail && !matchBranch && !matchClub) return false;
          }

          return true;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  'Developer & Admin Console',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              children: [
                // Overview Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.deepBlueGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppShadows.soft3dButton,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.query_stats_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'CET Platform Telemetry & Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Live in-memory database telemetry for students, clubs, registrations, and campus activity trackers.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Key Numerical Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Total Users',
                        '$totalUsers',
                        Icons.people_alt_rounded,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        'Club Admins',
                        '$totalClubAdmins',
                        Icons.shield_rounded,
                        AppColors.success,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Active Clubs',
                        '$totalClubs',
                        Icons.groups_rounded,
                        AppColors.accentPurple,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        'Workshops / Events',
                        '$totalEvents',
                        Icons.event_available_rounded,
                        const Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Students Only',
                        '$totalStudents',
                        Icons.school_rounded,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        'Active Plans',
                        '$totalActivities',
                        Icons.calendar_month_rounded,
                        const Color(0xFFEC4899),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Profiles Registry Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registered Profiles Database',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${filteredProfiles.length} Total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Search & Filter
                Soft3DTextField(
                  hintText: 'Search profiles by name, branch, club...',
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 10),

                Row(
                  children: ['All', 'Students', 'Club Admins'].map((rf) {
                    final isSel = _roleFilter == rf;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Soft3DChip(
                        label: rf,
                        isSelected: isSel,
                        fontSize: 11,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        onTap: () => setState(() => _roleFilter = rf),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // Profile Rows
                ...filteredProfiles.map((p) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Soft3DCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: p.avatarColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                p.name.isNotEmpty ? p.name.substring(0, 1) : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
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
                                        p.name.isNotEmpty ? p.name : 'Registered Student',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: p.isClubAdmin ? AppColors.successBg : AppColors.iceBlue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.isClubAdmin ? 'Club Admin' : 'Student',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: p.isClubAdmin ? AppColors.success : AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${p.degree} ${p.branch} • Sem ${p.semester}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  p.email,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                if (p.isClubAdmin && p.clubName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Club: ${p.clubName} (${p.clubCategory ?? "Technical"})',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentPurple,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Reset mock database button
                Soft3DButton(
                  text: 'Reset Database to Default Mock State',
                  type: Soft3DButtonType.secondary,
                  icon: Icons.restart_alt_rounded,
                  onPressed: () {
                    _dataService.resetToMockData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mock dataset restored to default!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String count, IconData icon, Color color) {
    return Soft3DCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
