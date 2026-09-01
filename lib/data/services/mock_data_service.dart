import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../models/activity_model.dart';

/// Centralized In-Memory Mock Data Store with Reactive State
class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;

  MockDataService._internal() {
    _initMockData();
  }

  UserModel? _currentUser;
  List<UserModel> _students = [];
  List<ClubModel> _clubs = [];
  List<EventModel> _events = [];
  List<ActivityModel> _activities = [];

  // Getters
  UserModel? get currentUser => _currentUser;
  List<UserModel> get students => List.unmodifiable(_students);
  List<ClubModel> get clubs => List.unmodifiable(_clubs);
  List<EventModel> get events => List.unmodifiable(_events);
  List<ActivityModel> get activities => List.unmodifiable(_activities);

  // Developer Statistics
  int get totalUsers => _students.length + (_currentUser != null ? 1 : 0);
  int get totalStudents => _students.where((u) => !u.isClubAdmin).length + ((_currentUser != null && !_currentUser!.isClubAdmin) ? 1 : 0);
  int get totalClubAdmins => _students.where((u) => u.isClubAdmin).length + ((_currentUser != null && _currentUser!.isClubAdmin) ? 1 : 0);
  int get totalClubs => _clubs.length;
  int get totalEvents => _events.length;
  int get totalActivities => _activities.length;

  void _initMockData() {
    // Current user default (demo student)
    _currentUser = UserModel(
      id: 'usr_me',
      name: 'Aditya Varma',
      email: 'aditya.varma@cet.ac.in',
      semester: 6,
      degree: 'B.Tech',
      branch: 'Computer Science & Engg',
      bio: 'Full-stack builder passionate about Flutter, Distributed Systems, and campus hackathons. Always up for filter coffee & coding!',
      hobbies: ['Coding', 'AI / ML', 'Hackathons', 'Gaming', 'UI/UX Design'],
      isClubAdmin: false,
      role: UserRole.student,
      avatarColor: const Color(0xFF2563EB),
      connectedUserIds: ['usr_1', 'usr_3'],
      followingClubIds: ['club_1', 'club_3'],
      joinedClubIds: ['club_1'],
      registeredEventIds: ['evt_1', 'evt_3'],
    );

    // Other CET students for Discover page
    _students = [
      UserModel(
        id: 'usr_1',
        name: 'Ananya Nair',
        email: 'ananya.nair@cet.ac.in',
        semester: 6,
        degree: 'B.Tech',
        branch: 'Electronics & Comm Engg',
        bio: 'Robotics enthusiast, IoT hardware tinkerer, and amateur classical singer. Building autonomous rover prototypes @ CET.',
        hobbies: ['Robotics', 'IoT', 'Music', 'Coding', 'Photography'],
        isClubAdmin: true,
        clubName: 'CET Robotics Club',
        clubCategory: 'Technical',
        role: UserRole.clubLeader,
        avatarColor: const Color(0xFF8B5CF6),
      ),
      UserModel(
        id: 'usr_2',
        name: 'Rohit Menon',
        email: 'rohit.m@cet.ac.in',
        semester: 4,
        degree: 'B.Tech',
        branch: 'Mechanical Engg',
        bio: 'Formula Student aerodynamics lead & 3D CAD designer. Love Formula 1, sim racing, and robotics mechanisms.',
        hobbies: ['3D Modeling', 'Automotive', 'Gaming', 'Robotics', 'Sports'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFF0EA5E9),
      ),
      UserModel(
        id: 'usr_3',
        name: 'Sneha Krishnan',
        email: 'sneha.k@cet.ac.in',
        semester: 6,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Competitive programmer, open-source contributor, and lead of CodeCET. Let us build cool algorithms together!',
        hobbies: ['Coding', 'Algorithms', 'AI / ML', 'Debating', 'Literature'],
        isClubAdmin: true,
        clubName: 'CodeCET',
        clubCategory: 'Technical',
        role: UserRole.clubLeader,
        avatarColor: const Color(0xFF10B981),
      ),
      UserModel(
        id: 'usr_4',
        name: 'Farhan Ali',
        email: 'farhan.ali@cet.ac.in',
        semester: 8,
        degree: 'B.Arch',
        branch: 'Architecture',
        bio: 'Final year Architecture student fascinated by sustainable urban spaces, minimalist sketching, and graphic design.',
        hobbies: ['UI/UX Design', 'Photography', 'Art & Sketching', 'Literature'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFFF59E0B),
      ),
      UserModel(
        id: 'usr_5',
        name: 'Devika Pillai',
        email: 'devika.p@cet.ac.in',
        semester: 4,
        degree: 'B.Tech',
        branch: 'Electrical & Electronics Engg',
        bio: 'Vocalist at Dhwani Music Club. Electric vehicle circuitry researcher and keyboard player.',
        hobbies: ['Music', 'Dance', 'Photography', 'IoT'],
        isClubAdmin: true,
        clubName: 'Dhwani - CET Music Club',
        clubCategory: 'Cultural',
        role: UserRole.clubLeader,
        avatarColor: const Color(0xFFEC4899),
      ),
      UserModel(
        id: 'usr_6',
        name: 'Kiran Joseph',
        email: 'kiran.j@cet.ac.in',
        semester: 2,
        degree: 'B.Tech',
        branch: 'Civil Engg',
        bio: 'First year CETian exploring clubs, debate society, football, and student startups.',
        hobbies: ['Sports', 'Debating', 'Literature', 'Hackathons'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFF6366F1),
      ),
      UserModel(
        id: 'usr_7',
        name: 'Meera Thomas',
        email: 'meera.t@cet.ac.in',
        semester: 6,
        degree: 'MCA',
        branch: 'Computer Applications',
        bio: 'Cloud architecture & cybersecurity enthusiast. Passionate about organizing student hackathons and workshops.',
        hobbies: ['Coding', 'AI / ML', 'UI/UX Design', 'Gaming'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFF14B8A6),
      ),
    ];

    // CET Campus Clubs & Communities
    _clubs = [
      ClubModel(
        id: 'club_1',
        name: 'CodeCET',
        category: 'Technical',
        description: 'The official Computer Science & Coding Club of CET. We organize weekly coding leagues, open source jams, web3 & AI bootcamps, and the annual CET HackFest.',
        leaderId: 'usr_3',
        leaderName: 'Sneha Krishnan',
        coLeaderNames: ['Arjun Ramesh', 'Gokul Krishna'],
        moderatorNames: ['Maya Suresh', 'Nikhil Raj'],
        isVerified: true,
        memberCount: 420,
        followerCount: 1250,
        icon: Icons.code_rounded,
        themeColor: const Color(0xFF2563EB),
        tags: ['Coding', 'AI / ML', 'Hackathons', 'Open Source'],
      ),
      ClubModel(
        id: 'club_2',
        name: 'CET Robotics Club',
        category: 'Technical',
        description: 'Pioneering robotics, computer vision, autonomous rovers, and drone technology at CET. Hands-on hardware labs, PCB design workshops, and national rover challenge teams.',
        leaderId: 'usr_1',
        leaderName: 'Ananya Nair',
        coLeaderNames: ['Vipin Das'],
        moderatorNames: ['Rahul K', 'Aswin B'],
        isVerified: true,
        memberCount: 280,
        followerCount: 890,
        icon: Icons.precision_manufacturing_rounded,
        themeColor: const Color(0xFF0284C7),
        tags: ['Robotics', 'IoT', 'Hardware', 'Drones'],
      ),
      ClubModel(
        id: 'club_3',
        name: 'Dhwani - CET Music Club',
        category: 'Cultural',
        description: 'The heartbeat of music in CET. From classical fusion to rock bands, acoustic unplugged sessions on Diamond Jubilee stage, and inter-college cultural fests.',
        leaderId: 'usr_5',
        leaderName: 'Devika Pillai',
        coLeaderNames: ['Shankar G'],
        moderatorNames: ['Tara Mohan'],
        isVerified: true,
        memberCount: 190,
        followerCount: 2100,
        icon: Icons.music_note_rounded,
        themeColor: const Color(0xFF8B5CF6),
        tags: ['Music', 'Instruments', 'Vocals', 'Concerts'],
      ),
      ClubModel(
        id: 'club_4',
        name: 'IEDC CET',
        category: 'Entrepreneurship',
        description: 'Innovation and Entrepreneurship Development Centre. Fostering student startups, incubation funding, venture pitch competitions, and industry mentorship at CET.',
        leaderId: 'usr_iedc',
        leaderName: 'Prof. Harikrishnan (Faculty) / Vivek S',
        coLeaderNames: ['Alen John', 'Pooja Varma'],
        moderatorNames: ['Sreejith N'],
        isVerified: true,
        memberCount: 510,
        followerCount: 1780,
        icon: Icons.rocket_launch_rounded,
        themeColor: const Color(0xFFF59E0B),
        tags: ['Startups', 'Innovation', 'Hackathons', 'Mentorship'],
      ),
      ClubModel(
        id: 'club_5',
        name: 'CET Literary & Debating Society (LDS)',
        category: 'Cultural',
        description: 'Engaging minds in parliamentary debates, creative writing, elocution, model UNs, and quizzes. Elevating CET voice across national podiums.',
        leaderId: 'usr_lds',
        leaderName: 'Tarun Mathew',
        coLeaderNames: ['Riya Philip'],
        moderatorNames: ['Varun Nair'],
        isVerified: true,
        memberCount: 145,
        followerCount: 620,
        icon: Icons.record_voice_over_rounded,
        themeColor: const Color(0xFFEC4899),
        tags: ['Debating', 'Literature', 'Quizzing', 'Public Speaking'],
      ),
      ClubModel(
        id: 'club_6',
        name: 'CET Sports & Athletics Council',
        category: 'Sports',
        description: 'Uniting sports athletes across Football, Basketball, Badminton, Cricket, and Athletics. Annual inter-branch tournaments & university leagues.',
        leaderId: 'usr_sports',
        leaderName: 'Vishnu Prasad',
        coLeaderNames: ['Abhishek S'],
        moderatorNames: ['Kiran J'],
        isVerified: true,
        memberCount: 380,
        followerCount: 1400,
        icon: Icons.sports_soccer_rounded,
        themeColor: const Color(0xFF10B981),
        tags: ['Sports', 'Fitness', 'Football', 'Tournaments'],
      ),
    ];

    // Campus Events & Workshops
    _events = [
      EventModel(
        id: 'evt_1',
        title: 'CET AI & LLM Agent Hackathon 2026',
        clubId: 'club_1',
        clubName: 'CodeCET',
        category: 'Hackathon',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        timeString: 'Sat, 10:00 AM - Sun, 4:00 PM',
        venue: 'CS Seminar Hall & PG Lab, CET',
        description: '30-hour offline hackathon to build intelligent autonomous agents, multi-modal apps, and developer tools with mentorship and prizes worth ₹50,000!',
        registeredCount: 142,
        icon: Icons.psychology_rounded,
        accentColor: const Color(0xFF2563EB),
      ),
      EventModel(
        id: 'evt_2',
        title: 'Hands-on Autonomous Drone Flight Workshop',
        clubId: 'club_2',
        clubName: 'CET Robotics Club',
        category: 'Workshop',
        dateTime: DateTime.now().add(const Duration(days: 6)),
        timeString: 'Tue, 3:30 PM - 6:00 PM',
        venue: 'Robotics Lab, Mech Dept',
        description: 'Learn ROS2, sensor calibration, optical flow positioning, and autopilot PID tuning on quadcopter drones.',
        registeredCount: 68,
        icon: Icons.flight_takeoff_rounded,
        accentColor: const Color(0xFF0284C7),
      ),
      EventModel(
        id: 'evt_3',
        title: 'Dhwani Acoustic Unplugged & Open Mic',
        clubId: 'club_3',
        clubName: 'Dhwani - CET Music Club',
        category: 'Cultural',
        dateTime: DateTime.now().add(const Duration(days: 8)),
        timeString: 'Fri, 5:00 PM - 7:30 PM',
        venue: 'Diamond Jubilee Open Amphitheatre',
        description: 'Unwind with soulful vocals, acoustic guitar jams, beatboxing, and open mic performances by fellow CETians as the sun sets.',
        registeredCount: 215,
        icon: Icons.mic_external_on_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
      EventModel(
        id: 'evt_4',
        title: 'Startup Pitch & Seed Grant Orientation',
        clubId: 'club_4',
        clubName: 'IEDC CET',
        category: 'Orientation',
        dateTime: DateTime.now().add(const Duration(days: 12)),
        timeString: 'Thu, 4:00 PM - 5:30 PM',
        venue: 'Main Auditorium, CET',
        description: 'Discover how to pitch student tech prototypes for Kerala Startup Mission (KSUM) grant support and CET Incubation space.',
        registeredCount: 95,
        icon: Icons.monetization_on_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
    ];

    // Activity Tracker Default Items (Club Events + Private Friend Activities)
    _activities = [
      ActivityModel(
        id: 'act_1',
        title: 'CET AI & LLM Agent Hackathon 2026',
        type: ActivityType.clubEvent,
        hostName: 'CodeCET',
        clubId: 'club_1',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        timeDisplay: 'Sat, 10:00 AM - Sun, 4:00 PM',
        location: 'CS Seminar Hall & PG Lab',
        description: 'Registered for the 30-hour offline hackathon. Team formation done.',
        invitedFriends: ['Sneha Krishnan', 'Aditya Varma'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFF2563EB),
      ),
      ActivityModel(
        id: 'act_2',
        title: 'DSA LeetCode Grinding & Algo Prep',
        type: ActivityType.studyGroup,
        hostName: 'Aditya Varma (You)',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        timeDisplay: 'Tomorrow, 5:30 PM - 7:00 PM',
        location: 'Central Library 2nd Floor Study Room',
        description: 'Solving Dynamic Programming & Graph problems on LeetCode with friends before placement tests.',
        invitedFriends: ['Sneha Krishnan', 'Ananya Nair'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFF10B981),
      ),
      ActivityModel(
        id: 'act_3',
        title: 'Dhwani Acoustic Unplugged & Open Mic',
        type: ActivityType.clubEvent,
        hostName: 'Dhwani CET',
        clubId: 'club_3',
        dateTime: DateTime.now().add(const Duration(days: 8)),
        timeDisplay: 'Next Friday, 5:00 PM - 7:30 PM',
        location: 'Diamond Jubilee Amphitheatre',
        description: 'Attending with hostel friends to watch live band performances.',
        invitedFriends: ['Devika Pillai', 'Rohit Menon'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFF8B5CF6),
      ),
      ActivityModel(
        id: 'act_4',
        title: 'Weekend 5v5 Football Friendly @ CET Ground',
        type: ActivityType.sports,
        hostName: 'Kiran Joseph',
        dateTime: DateTime.now().add(const Duration(days: 4)),
        timeDisplay: 'Sunday, 6:30 AM - 8:00 AM',
        location: 'CET Football Ground',
        description: 'Inter-hostel morning football friendly match.',
        invitedFriends: ['Rohit Menon', 'Farhan Ali', 'Aditya Varma'],
        isCompleted: false,
        isReminderSet: false,
        badgeColor: const Color(0xFFF59E0B),
      ),
    ];
  }

  // --- Auth & Session Methods ---

  /// Quick Login with predefined or custom credentials
  void login(String email, String password) {
    // Check if matches existing student or create active session
    final existing = _students.where((u) => u.email.toLowerCase() == email.toLowerCase()).firstOrNull;
    if (existing != null) {
      _currentUser = existing;
    } else {
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first.replaceAll('.', ' ').toUpperCase(),
        email: email,
        semester: 4,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Enthusiastic CETian ready to explore campus opportunities and connect with fellow students.',
        hobbies: ['Coding', 'Gaming', 'Music'],
        role: UserRole.student,
      );
    }
    notifyListeners();
  }

  /// Switch to Demo Account for fast testing
  void loginAsDemo(String roleType) {
    if (roleType == 'clubLeader') {
      _currentUser = UserModel(
        id: 'usr_lead_demo',
        name: 'Sneha Krishnan',
        email: 'sneha.k@cet.ac.in',
        semester: 6,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Lead of CodeCET. Passionate about distributed systems, algorithm design, and building student developer communities at CET.',
        hobbies: ['Coding', 'Algorithms', 'AI / ML', 'Debating', 'Literature'],
        isClubAdmin: true,
        clubName: 'CodeCET',
        clubCategory: 'Technical',
        clubDescription: 'The official Computer Science & Coding Club of CET. We organize weekly coding leagues, open source jams, web3 & AI bootcamps.',
        role: UserRole.clubLeader,
        avatarColor: const Color(0xFF10B981),
        connectedUserIds: ['usr_1', 'usr_2', 'usr_5'],
        followingClubIds: ['club_1', 'club_2', 'club_4'],
        joinedClubIds: ['club_1'],
        registeredEventIds: ['evt_1'],
      );
    } else if (roleType == 'developerAdmin') {
      _currentUser = UserModel(
        id: 'usr_admin_dev',
        name: 'CET Dev Admin',
        email: 'admin.dev@cet.ac.in',
        semester: 8,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Core Platform Administrator & Developer for CET Connect ecosystem.',
        hobbies: ['Fullstack Dev', 'Cloud Infra', 'System Design'],
        isClubAdmin: true,
        clubName: 'CET Dev Team',
        clubCategory: 'Technical',
        role: UserRole.developerAdmin,
        avatarColor: const Color(0xFF0F172A),
      );
    } else {
      // Default Demo Student
      _currentUser = UserModel(
        id: 'usr_me',
        name: 'Aditya Varma',
        email: 'aditya.varma@cet.ac.in',
        semester: 6,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Full-stack builder passionate about Flutter, Distributed Systems, and campus hackathons. Always up for filter coffee & coding!',
        hobbies: ['Coding', 'AI / ML', 'Hackathons', 'Gaming', 'UI/UX Design'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFF2563EB),
        connectedUserIds: ['usr_1', 'usr_3'],
        followingClubIds: ['club_1', 'club_3'],
        joinedClubIds: ['club_1'],
        registeredEventIds: ['evt_1', 'evt_3'],
      );
    }
    notifyListeners();
  }

  /// Signup new draft user profile (S2 -> S3)
  void startSignup({required String email, required String password}) {
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: '',
      email: email,
      semester: 1,
      degree: 'B.Tech',
      branch: 'Computer Science & Engg',
      bio: '',
      hobbies: ['Coding', 'Music'],
      isClubAdmin: false,
      role: UserRole.student,
    );
    notifyListeners();
  }

  /// Save completed profile (from S3 or Profile Edit)
  void saveProfile(UserModel updatedUser) {
    _currentUser = updatedUser;

    // If this user is a club admin and created a new club, add or update club in list
    if (updatedUser.isClubAdmin && (updatedUser.clubName?.isNotEmpty ?? false)) {
      final existingClubIndex = _clubs.indexWhere((c) => c.name.toLowerCase() == updatedUser.clubName!.toLowerCase() || c.leaderId == updatedUser.id);
      if (existingClubIndex != -1) {
        _clubs[existingClubIndex] = _clubs[existingClubIndex].copyWith(
          name: updatedUser.clubName,
          category: updatedUser.clubCategory ?? 'Technical',
          description: updatedUser.clubDescription ?? _clubs[existingClubIndex].description,
          leaderName: updatedUser.name,
        );
      } else {
        final newClub = ClubModel(
          id: 'club_${DateTime.now().millisecondsSinceEpoch}',
          name: updatedUser.clubName!,
          category: updatedUser.clubCategory ?? 'Technical',
          description: updatedUser.clubDescription ?? 'Official student community at CET.',
          leaderId: updatedUser.id,
          leaderName: updatedUser.name,
          isVerified: updatedUser.isClubVerified,
          memberCount: 1,
          followerCount: 5,
          icon: Icons.groups_rounded,
          themeColor: const Color(0xFF2563EB),
          tags: updatedUser.hobbies.take(4).toList(),
        );
        _clubs.insert(0, newClub);
      }
    }

    notifyListeners();
  }

  // --- Student Interactions ---

  /// Toggle connect / request with a student
  void toggleConnect(String targetUserId) {
    if (_currentUser == null) return;
    final connected = List<String>.from(_currentUser!.connectedUserIds);
    if (connected.contains(targetUserId)) {
      connected.remove(targetUserId);
    } else {
      connected.add(targetUserId);
    }
    _currentUser = _currentUser!.copyWith(connectedUserIds: connected);
    notifyListeners();
  }

  // --- Club Interactions ---

  /// Toggle sending a join request to a club
  void toggleClubJoinRequest(String clubId) {
    if (_currentUser == null) return;
    final pendingJoins = List<String>.from(_currentUser!.pendingClubJoinIds);
    final joined = List<String>.from(_currentUser!.joinedClubIds);

    if (joined.contains(clubId)) {
      joined.remove(clubId);
    } else if (pendingJoins.contains(clubId)) {
      pendingJoins.remove(clubId);
      joined.add(clubId); // Auto-approve simulation for demo ease!
    } else {
      pendingJoins.add(clubId);
    }

    _currentUser = _currentUser!.copyWith(
      pendingClubJoinIds: pendingJoins,
      joinedClubIds: joined,
    );
    notifyListeners();
  }

  /// Toggle following a club for updates
  void toggleClubFollow(String clubId) {
    if (_currentUser == null) return;
    final following = List<String>.from(_currentUser!.followingClubIds);
    final clubIndex = _clubs.indexWhere((c) => c.id == clubId);

    if (following.contains(clubId)) {
      following.remove(clubId);
      if (clubIndex != -1) {
        _clubs[clubIndex] = _clubs[clubIndex].copyWith(
          followerCount: (_clubs[clubIndex].followerCount - 1).clamp(0, 999999),
        );
      }
    } else {
      following.add(clubId);
      if (clubIndex != -1) {
        _clubs[clubIndex] = _clubs[clubIndex].copyWith(
          followerCount: _clubs[clubIndex].followerCount + 1,
        );
      }
    }

    _currentUser = _currentUser!.copyWith(followingClubIds: following);
    notifyListeners();
  }

  /// Add Co-Leader to a club
  void addClubCoLeader(String clubId, String name) {
    final idx = _clubs.indexWhere((c) => c.id == clubId);
    if (idx != -1) {
      final list = List<String>.from(_clubs[idx].coLeaderNames);
      if (!list.contains(name)) {
        list.add(name);
        _clubs[idx] = _clubs[idx].copyWith(coLeaderNames: list);
        notifyListeners();
      }
    }
  }

  /// Add Moderator to a club
  void addClubModerator(String clubId, String name) {
    final idx = _clubs.indexWhere((c) => c.id == clubId);
    if (idx != -1) {
      final list = List<String>.from(_clubs[idx].moderatorNames);
      if (!list.contains(name)) {
        list.add(name);
        _clubs[idx] = _clubs[idx].copyWith(moderatorNames: list);
        notifyListeners();
      }
    }
  }

  // --- Events & Activity Tracker ---

  /// Register for an event and automatically add it to Activity Tracker
  void registerForEvent(EventModel event) {
    if (_currentUser == null) return;
    final registered = List<String>.from(_currentUser!.registeredEventIds);

    if (registered.contains(event.id)) {
      registered.remove(event.id);
      // Remove from activities
      _activities.removeWhere((a) => a.id == 'act_evt_${event.id}' || a.title == event.title);
    } else {
      registered.add(event.id);
      // Automatically add to Activity Tracker
      final newActivity = ActivityModel(
        id: 'act_evt_${event.id}',
        title: event.title,
        type: ActivityType.clubEvent,
        hostName: event.clubName,
        clubId: event.clubId,
        dateTime: event.dateTime,
        timeDisplay: event.timeString,
        location: event.venue,
        description: event.description,
        invitedFriends: [_currentUser!.name],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: event.accentColor,
      );
      _activities.insert(0, newActivity);
    }

    _currentUser = _currentUser!.copyWith(registeredEventIds: registered);
    notifyListeners();
  }

  /// Add a private activity or study session with friends
  void addPrivateActivity(ActivityModel activity) {
    _activities.insert(0, activity);
    notifyListeners();
  }

  /// Toggle activity reminder
  void toggleActivityReminder(String activityId) {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx != -1) {
      _activities[idx] = _activities[idx].copyWith(
        isReminderSet: !_activities[idx].isReminderSet,
      );
      notifyListeners();
    }
  }

  /// Toggle activity completion status
  void toggleActivityCompleted(String activityId) {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx != -1) {
      _activities[idx] = _activities[idx].copyWith(
        isCompleted: !_activities[idx].isCompleted,
      );
      notifyListeners();
    }
  }

  /// Reset all data to mock baseline
  void resetToMockData() {
    _initMockData();
    notifyListeners();
  }
}
