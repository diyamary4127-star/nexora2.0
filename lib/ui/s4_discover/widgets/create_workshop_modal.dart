import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/soft_3d_button.dart';
import '../../../core/widgets/soft_3d_chip.dart';
import '../../../core/widgets/soft_3d_text_field.dart';
import '../../../data/models/club_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/mock_data_service.dart';

/// Modal for Club Leaders to create and publish campus workshops & events
class CreateWorkshopModal extends StatefulWidget {
  final ClubModel club;

  const CreateWorkshopModal({super.key, required this.club});

  @override
  State<CreateWorkshopModal> createState() => _CreateWorkshopModalState();
}

class _CreateWorkshopModalState extends State<CreateWorkshopModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController(text: 'Saturday, 2:00 PM - 5:30 PM');
  final _locationController = TextEditingController(text: 'Gazebo Mini Stage');
  final _descController = TextEditingController();
  final _seatsController = TextEditingController(text: '60');

  String _selectedCategory = 'Drishti Fest';

  final List<String> _categoryOptions = [
    'Drishti Fest',
    'Dhwani Fest',
    'Disha Fest',
    'Mashi Fest',
    'Technical Workshop',
    'Hands-on Bootcamp',
    'Cultural & Jamming',
  ];

  final List<String> _quickVenues = [
    'Gazebo Mini Stage',
    'CS PG Lab',
    'Central Library',
    'Dhwani Stage',
    'Archie Corner',
    'CET Main Auditorium',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  void _onPublishWorkshop() {
    if (_formKey.currentState?.validate() ?? false) {
      Color accentColor;
      IconData icon;

      switch (_selectedCategory) {
        case 'Drishti Fest':
        case 'Technical Workshop':
        case 'Hands-on Bootcamp':
          accentColor = AppColors.primary;
          icon = Icons.psychology_rounded;
          break;
        case 'Dhwani Fest':
        case 'Cultural & Jamming':
          accentColor = const Color(0xFFEC4899);
          icon = Icons.music_note_rounded;
          break;
        case 'Disha Fest':
          accentColor = const Color(0xFFF59E0B);
          icon = Icons.rocket_launch_rounded;
          break;
        case 'Mashi Fest':
          accentColor = const Color(0xFF10B981);
          icon = Icons.palette_rounded;
          break;
        default:
          accentColor = AppColors.primary;
          icon = Icons.event_available_rounded;
      }

      final newEvent = EventModel(
        id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        clubId: widget.club.id,
        clubName: widget.club.name,
        category: _selectedCategory,
        dateTime: DateTime.now().add(const Duration(days: 4)),
        timeString: _timeController.text.trim().isNotEmpty ? _timeController.text.trim() : 'Upcoming Weekend',
        venue: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : 'CET Campus',
        description: _descController.text.trim().isNotEmpty
            ? _descController.text.trim()
            : 'Interactive workshop organized by ${widget.club.name} for CET students.',
        registeredCount: 1,
        icon: icon,
        accentColor: accentColor,
      );

      MockDataService().createClubEvent(newEvent);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workshop "${newEvent.title}" published successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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

              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Organize Workshop',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Publishing on behalf of ${widget.club.name}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.iceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.club.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Soft3DTextField(
                label: 'Workshop / Event Title',
                hintText: 'e.g. Flutter 3D UI & State Management Bootcamp',
                controller: _titleController,
                prefixIcon: const Icon(Icons.school_rounded, color: AppColors.primary),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a workshop title' : null,
              ),

              const SizedBox(height: 14),

              // Fest / Category Selection
              const Text(
                'Associated Fest / Category',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categoryOptions.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Soft3DChip(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedCategory = cat),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Timing
              Soft3DTextField(
                label: 'Date & Timing',
                hintText: 'e.g. Saturday, 2:00 PM - 5:00 PM',
                controller: _timeController,
                prefixIcon: const Icon(Icons.access_time_rounded, color: AppColors.primary),
              ),

              const SizedBox(height: 14),

              // Venue with Quick Chips
              const Text(
                'Venue / Campus Location',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _quickVenues.map((v) {
                  final isSelected = _locationController.text == v;
                  return GestureDetector(
                    onTap: () => setState(() => _locationController.text = v),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.iceBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? AppShadows.soft3dChipActive : null,
                      ),
                      child: Text(
                        v,
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
              const SizedBox(height: 8),
              Soft3DTextField(
                hintText: 'e.g. Gazebo Mini Stage / CS PG Lab',
                controller: _locationController,
                prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),

              const SizedBox(height: 14),

              // Description
              Soft3DTextField(
                label: 'Description & Prerequisites',
                hintText: 'Describe topics covered, required software or hardware, and certificates provided...',
                controller: _descController,
                maxLines: 3,
                minLines: 2,
              ),

              const SizedBox(height: 20),

              // Publish Button
              Soft3DButton(
                text: 'Publish Campus Workshop',
                icon: Icons.rocket_launch_rounded,
                onPressed: _onPublishWorkshop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
