import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/soft_3d_button.dart';
import '../../core/widgets/soft_3d_card.dart';
import '../../core/widgets/soft_3d_chip.dart';
import '../../core/widgets/soft_3d_text_field.dart';
import '../../data/models/user_model.dart';
import '../../data/services/mock_data_service.dart';
import '../s4_discover/discover_screen.dart';

/// S3: Profile Setup Screen with rich selectors, scrollable layout & Club Leader section
class ProfileSetupScreen extends StatefulWidget {
  final String? initialEmail;
  final UserModel? existingUser;

  const ProfileSetupScreen({
    super.key,
    this.initialEmail,
    this.existingUser,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _customHobbyController;

  // Club specific controllers
  late TextEditingController _clubNameController;
  late TextEditingController _clubDescController;

  late int _selectedSemester;
  late String _selectedDegree;
  late String _selectedBranch;
  late List<String> _selectedHobbies;

  bool _isClubAdmin = false;
  String _selectedClubCategory = 'Technical';
  String? _uploadedVerificationDoc;

  final List<String> _degreeOptions = [
    'B.Tech',
    'B.Arch',
    'M.Tech',
    'MCA',
    'Ph.D',
  ];

  final List<String> _branchOptions = [
    'Computer Science & Engg',
    'Electronics & Comm Engg',
    'Electrical & Electronics Engg',
    'Mechanical Engg',
    'Civil Engg',
    'Applied Electronics & Inst.',
    'Architecture',
    'Industrial Engg',
  ];

  final List<String> _availableHobbies = [
    'Coding',
    'AI / ML',
    'Robotics',
    'Web3',
    'UI/UX Design',
    'Music',
    'Dance',
    'Photography',
    'Debating',
    'Gaming',
    'Sports',
    'Literature',
    'Hackathons',
    'IoT',
    'Fitness',
    'Art & Sketching',
  ];

  final List<String> _clubCategories = [
    'Technical',
    'Cultural',
    'Entrepreneurship',
    'Sports',
    'Social & Volunteering',
  ];

  @override
  void initState() {
    super.initState();
    final user = widget.existingUser ?? MockDataService().currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(
      text: user?.bio.isNotEmpty == true
          ? user!.bio
          : 'Passionate CETian eager to learn, build innovative projects, and connect with fellow students.',
    );
    _customHobbyController = TextEditingController();

    _clubNameController = TextEditingController(text: user?.clubName ?? '');
    _clubDescController = TextEditingController(
      text: user?.clubDescription ?? '',
    );

    _selectedSemester = user?.semester ?? 4;
    _selectedDegree = (user?.degree.isNotEmpty == true && _degreeOptions.contains(user!.degree))
        ? user.degree
        : _degreeOptions.first;
    _selectedBranch = (user?.branch.isNotEmpty == true && _branchOptions.contains(user!.branch))
        ? user.branch
        : _branchOptions.first;
    _selectedHobbies = user?.hobbies.isNotEmpty == true
        ? List.from(user!.hobbies)
        : ['Coding', 'Music', 'Robotics'];

    _isClubAdmin = user?.isClubAdmin ?? false;
    _selectedClubCategory = user?.clubCategory ?? 'Technical';
    _uploadedVerificationDoc = user?.verificationDocName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _customHobbyController.dispose();
    _clubNameController.dispose();
    _clubDescController.dispose();
    super.dispose();
  }

  void _addCustomHobby() {
    final text = _customHobbyController.text.trim();
    if (text.isNotEmpty && !_selectedHobbies.contains(text)) {
      setState(() {
        _selectedHobbies.add(text);
        if (!_availableHobbies.contains(text)) {
          _availableHobbies.add(text);
        }
        _customHobbyController.clear();
      });
    }
  }

  void _simulateUploadDoc() {
    setState(() {
      _uploadedVerificationDoc = 'CET_Club_Lead_Auth_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification document uploaded successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSaveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedHobbies.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one hobby or interest'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final email = widget.initialEmail ??
          widget.existingUser?.email ??
          MockDataService().currentUser?.email ??
          'student@cet.ac.in';

      final updatedUser = UserModel(
        id: widget.existingUser?.id ?? MockDataService().currentUser?.id ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        email: email,
        semester: _selectedSemester,
        degree: _selectedDegree,
        branch: _selectedBranch,
        bio: _bioController.text.trim(),
        hobbies: _selectedHobbies,
        isClubAdmin: _isClubAdmin,
        clubName: _isClubAdmin ? _clubNameController.text.trim() : null,
        clubCategory: _isClubAdmin ? _selectedClubCategory : null,
        clubDescription: _isClubAdmin ? _clubDescController.text.trim() : null,
        verificationDocName: _uploadedVerificationDoc,
        isClubVerified: true,
        role: _isClubAdmin ? UserRole.clubLeader : UserRole.student,
        avatarColor: _isClubAdmin ? const Color(0xFF10B981) : const Color(0xFF2563EB),
      );

      MockDataService().saveProfile(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isClubAdmin ? 'Club Leader Profile saved!' : 'Student Profile created successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DiscoverScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.iceBlue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                    boxShadow: AppShadows.soft3dChip,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.looks_two_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'STEP 2 OF 2 : CAMPUS IDENTITY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Set Up Your CET Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Fill in your academic and personal details so peers and clubs can find you.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                // 1. Basic Info Card
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.badge_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Soft3DTextField(
                        label: 'Full Name',
                        hintText: 'e.g. Aditya Varma',
                        controller: _nameController,
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Academic Information Card (Degree, Branch, Semester)
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Academic Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Degree Type Selector
                      const Text(
                        'Type of Degree',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _degreeOptions.map((degree) {
                          final isSelected = _selectedDegree == degree;
                          return Soft3DChip(
                            label: degree,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedDegree = degree),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Branch Dropdown Selector
                      const Text(
                        'Branch / Department',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.lightBlueTint),
                          boxShadow: AppShadows.soft3dInput,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBranch,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                            items: _branchOptions.map((branch) {
                              return DropdownMenuItem<String>(
                                value: branch,
                                child: Text(
                                  branch,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedBranch = val);
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Semester Selector (1 to 8)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Semester (1 - 8)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Sem $_selectedSemester',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(8, (index) {
                          final semNumber = index + 1;
                          final isSelected = _selectedSemester == semNumber;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedSemester = semNumber),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 36,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected ? null : Colors.white,
                                gradient: isSelected ? AppColors.primaryGradient : null,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : AppColors.lightBlueTint,
                                  width: 1.2,
                                ),
                                boxShadow: isSelected ? AppShadows.soft3dChipActive : AppShadows.soft3dChip,
                              ),
                              child: Center(
                                child: Text(
                                  '$semNumber',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Bio & Description Card
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'About Yourself',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Soft3DTextField(
                        label: 'Description / Bio',
                        hintText: 'Share your background, what you love working on, favorite CET spots, or what you are looking to collaborate on...',
                        controller: _bioController,
                        maxLines: 4,
                        minLines: 3,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please write a short bio' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Hobbies & Interests Multi-Selector
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.iceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.favorite_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Hobbies & Interests',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap tags to select topics you are interested in. We use these to match you with peers in S4 Discover!',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableHobbies.map((hobby) {
                          final isSelected = _selectedHobbies.contains(hobby);
                          return Soft3DChip(
                            label: hobby,
                            isSelected: isSelected,
                            icon: isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedHobbies.remove(hobby);
                                } else {
                                  _selectedHobbies.add(hobby);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // Add custom hobby
                      Row(
                        children: [
                          Expanded(
                            child: Soft3DTextField(
                              hintText: 'Add custom interest...',
                              controller: _customHobbyController,
                              prefixIcon: const Icon(Icons.tag_rounded, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Soft3DButton(
                            text: 'Add',
                            width: 75,
                            height: 52,
                            type: Soft3DButtonType.secondary,
                            onPressed: _addCustomHobby,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Optional Club / Community Admin Section
                Soft3DCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _isClubAdmin ? AppColors.successBg : AppColors.iceBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.shield_rounded,
                                  color: _isClubAdmin ? AppColors.success : AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Club / Community Leader?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Optional for student body organizers',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: _isClubAdmin,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _isClubAdmin = val;
                              });
                            },
                          ),
                        ],
                      ),

                      // Expandable Club Setup Area
                      if (_isClubAdmin) ...[
                        const SizedBox(height: 18),
                        const Divider(color: AppColors.lightBlueTint),
                        const SizedBox(height: 14),

                        // Notice Banner
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.iceBlue,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'As a club leader, you will set up the official club portfolio. Later on, you can add more co-leaders and moderators to your club with equivalent leadership permissions.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryDark,
                                    height: 1.35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Soft3DTextField(
                          label: 'Club / Community Name',
                          hintText: 'e.g. CodeCET / CET Robotics / Dhwani',
                          controller: _clubNameController,
                          prefixIcon: const Icon(Icons.groups_rounded, color: AppColors.primary),
                          validator: _isClubAdmin
                              ? (v) => (v == null || v.trim().isEmpty) ? 'Please enter club name' : null
                              : null,
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Club Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _clubCategories.map((cat) {
                            final isSelected = _selectedClubCategory == cat;
                            return Soft3DChip(
                              label: cat,
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedClubCategory = cat),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        Soft3DTextField(
                          label: 'Club Portfolio & Team Description',
                          hintText: 'Describe the vision, past achievements, workshops, and team structure of the club...',
                          controller: _clubDescController,
                          maxLines: 4,
                          minLines: 3,
                          validator: _isClubAdmin
                              ? (v) => (v == null || v.trim().isEmpty) ? 'Please enter club description' : null
                              : null,
                        ),

                        const SizedBox(height: 16),

                        // Verification Image / Document Upload Simulator
                        const Text(
                          'Upload Verification Proof / ID',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _uploadedVerificationDoc != null ? AppColors.success : AppColors.lightBlueTint,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _uploadedVerificationDoc != null ? Icons.verified_rounded : Icons.cloud_upload_outlined,
                                color: _uploadedVerificationDoc != null ? AppColors.success : AppColors.primary,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _uploadedVerificationDoc ?? 'Upload Staff Advisor / HOD Authorization Letter or ID',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _uploadedVerificationDoc != null ? FontWeight.w600 : FontWeight.w500,
                                  color: _uploadedVerificationDoc != null ? AppColors.success : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Soft3DButton(
                                text: _uploadedVerificationDoc != null ? 'Re-upload Proof' : 'Select Document Image',
                                type: Soft3DButtonType.secondary,
                                height: 38,
                                width: 190,
                                icon: Icons.upload_file_rounded,
                                onPressed: _simulateUploadDoc,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Save & Submit Button
                Soft3DButton(
                  text: 'Save Profile & Enter Discover Hub (S4)',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _onSaveProfile,
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
