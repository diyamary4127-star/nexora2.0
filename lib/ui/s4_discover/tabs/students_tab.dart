import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_card.dart';
import '../../../core/widgets/soft_3d_chip.dart';
import '../../../core/widgets/soft_3d_text_field.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mock_data_service.dart';
import '../widgets/student_detail_modal.dart';

/// Students Tab: Connect with students based on matching hobbies, interests, branch & semester
class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  final MockDataService _dataService = MockDataService();
  final _searchController = TextEditingController();

  String _selectedBranchFilter = 'All';
  String _selectedSemesterFilter = 'All';
  String _selectedHobbyFilter = 'All';

  final List<String> _branchFilters = [
    'All',
    'Computer Science & Engg',
    'Electronics & Comm Engg',
    'Electrical & Electronics Engg',
    'Mechanical Engg',
    'Civil Engg',
    'Architecture',
  ];

  final List<String> _semFilters = ['All', 'Sem 1-2', 'Sem 3-4', 'Sem 5-6', 'Sem 7-8'];

  final List<String> _hobbyFilters = [
    'All',
    'Coding',
    'AI / ML',
    'Robotics',
    'Music',
    'Gaming',
    'Sports',
    'UI/UX Design',
    'Debating',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openStudentDetail(BuildContext context, UserModel student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StudentDetailModal(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final currentUser = _dataService.currentUser;
        final myHobbies = currentUser?.hobbies ?? [];
        final query = _searchController.text.trim().toLowerCase();

        final filteredStudents = _dataService.students.where((student) {
          // Exclude self if present
          if (currentUser != null && student.id == currentUser.id) return false;

          // Search query matching
          if (query.isNotEmpty) {
            final matchName = student.name.toLowerCase().contains(query);
            final matchBranch = student.branch.toLowerCase().contains(query);
            final matchHobbies = student.hobbies.any((h) => h.toLowerCase().contains(query));
            final matchBio = student.bio.toLowerCase().contains(query);
            if (!matchName && !matchBranch && !matchHobbies && !matchBio) return false;
          }

          // Branch filter
          if (_selectedBranchFilter != 'All' && student.branch != _selectedBranchFilter) {
            return false;
          }

          // Semester filter
          if (_selectedSemesterFilter != 'All') {
            if (_selectedSemesterFilter == 'Sem 1-2' && (student.semester < 1 || student.semester > 2)) return false;
            if (_selectedSemesterFilter == 'Sem 3-4' && (student.semester < 3 || student.semester > 4)) return false;
            if (_selectedSemesterFilter == 'Sem 5-6' && (student.semester < 5 || student.semester > 6)) return false;
            if (_selectedSemesterFilter == 'Sem 7-8' && (student.semester < 7 || student.semester > 8)) return false;
          }

          // Hobby filter
          if (_selectedHobbyFilter != 'All') {
            if (!student.hobbies.contains(_selectedHobbyFilter)) return false;
          }

          return true;
        }).toList();

        // Sort by number of shared hobbies descending (Matchmaker score!)
        filteredStudents.sort((a, b) {
          final countA = a.hobbies.where((h) => myHobbies.contains(h)).length;
          final countB = b.hobbies.where((h) => myHobbies.contains(h)).length;
          return countB.compareTo(countA);
        });

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // Search Bar
            Soft3DTextField(
              hintText: 'Search students by name, hobby, or branch...',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted, size: 18),
                      onPressed: () => setState(() => _searchController.clear()),
                    )
                  : null,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // Hobby Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._hobbyFilters.map((h) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Soft3DChip(
                          label: h == 'All' ? 'All Interests' : h,
                          isSelected: _selectedHobbyFilter == h,
                          onTap: () => setState(() => _selectedHobbyFilter = h),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Branch Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._branchFilters.map((bf) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Soft3DChip(
                          label: bf == 'All' ? 'All Branches' : bf.replaceAll(' & Engg', '').replaceAll(' Engg', ''),
                          isSelected: _selectedBranchFilter == bf,
                          fontSize: 11,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          onTap: () => setState(() => _selectedBranchFilter = bf),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Semester Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._semFilters.map((sem) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Soft3DChip(
                          label: sem,
                          isSelected: _selectedSemesterFilter == sem,
                          fontSize: 11,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          onTap: () => setState(() => _selectedSemesterFilter = sem),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Header stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredStudents.length} Students Found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Ranked by Shared Interests',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (filteredStudents.isEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.person_search_rounded, size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    const Text(
                      'No students match your filter',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Try resetting filters or searching with another keyword.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...filteredStudents.map((student) {
                final isConnected = currentUser?.connectedUserIds.contains(student.id) ?? false;
                final shared = student.hobbies.where((h) => myHobbies.contains(h)).toList();

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Soft3DCard(
                    onTap: () => _openStudentDetail(context, student),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: Avatar, Info, Connect Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 3D Avatar
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: student.avatarColor,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.soft3dChipActive,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  student.name.isNotEmpty ? student.name.substring(0, 1) : 'S',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name & Department
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (student.isClubAdmin) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.successBg,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Lead',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${student.degree} ${student.branch} • S${student.semester}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quick Connect Button
                            GestureDetector(
                              onTap: () => _dataService.toggleConnect(student.id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isConnected ? AppColors.iceBlue : AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isConnected ? AppShadows.soft3dChip : AppShadows.soft3dChipActive,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isConnected ? Icons.check_rounded : Icons.person_add_rounded,
                                      size: 14,
                                      color: isConnected ? AppColors.primaryDark : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isConnected ? 'Connected' : 'Connect',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isConnected ? AppColors.primaryDark : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Shared interests tag banner
                        if (shared.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '${shared.length} Shared: ${shared.take(3).join(", ")}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Bio Snippet
                        const SizedBox(height: 8),
                        Text(
                          student.bio,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),

                        // Hobbies Chips Row
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: student.hobbies.take(4).map((h) {
                            final isShared = myHobbies.contains(h);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isShared ? AppColors.lightBlueTint : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isShared ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderSubtle,
                                ),
                              ),
                              child: Text(
                                h,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isShared ? FontWeight.w700 : FontWeight.w500,
                                  color: isShared ? AppColors.primaryDark : AppColors.textSecondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
