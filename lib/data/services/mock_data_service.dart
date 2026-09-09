import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../models/activity_model.dart';
import '../models/chat_message_model.dart';

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
  final Map<String, List<ChatMessage>> _conversations = {};

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
  int get totalMessages => _conversations.values.fold(0, (sum, list) => sum + list.length);

  void _initMockData() {
    // Current user default (Aditya Varma - CSE S6)
    _currentUser = UserModel(
      id: 'usr_me',
      name: 'Aditya Varma',
      email: 'aditya.varma@cet.ac.in',
      semester: 6,
      degree: 'B.Tech',
      branch: 'Computer Science & Engg',
      bio: 'Full-stack builder passionate about Flutter, Distributed Systems, and campus hackathons. Usually hanging out around Gazebo or PG Lab with a filter coffee!',
      hobbies: ['Coding', 'AI / ML', 'Hackathons', 'Gaming', 'UI/UX Design'],
      isClubAdmin: false,
      role: UserRole.student,
      avatarColor: const Color(0xFF2563EB),
      connectedUserIds: ['usr_1', 'usr_3', 'usr_4'],
      followingClubIds: ['club_1', 'club_3', 'club_4'],
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
        bio: 'Robotics enthusiast, IoT hardware tinkerer, and amateur vocalist. Organizing drone challenges for Drishti tech fest @ Gazebo stage.',
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
        bio: 'Formula Student aerodynamics lead & 3D CAD designer. Always up for football at CET Ground and chai near Archie Corner.',
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
        bio: 'Competitive programmer, open-source contributor, and lead of CodeCET. Coordinating the 36-hr HackFest for Drishti 2026.',
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
        bio: 'Final year Architecture student. Co-organizing Mashi Arts & Design Fest at Archie Corner. Passionate about sustainable urban spaces and sketching.',
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
        bio: 'Lead vocalist at Dhwani Music Club. Catch our sunset acoustic jamming sessions every Thursday at Gazebo stage & Dhwani Main Stage.',
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
        bio: 'First year CETian exploring debate society, football team, and student startups for Disha fest.',
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
        bio: 'Cloud architecture & cybersecurity enthusiast. Organizing workshop tracks for Disha techno-management summit.',
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
        description: 'The official Computer Science & Coding Club of CET. Hosting the flagship Drishti Hackathon, weekly algorithmic leagues, and open-source jams in PG Lab.',
        leaderId: 'usr_3',
        leaderName: 'Sneha Krishnan',
        coLeaderNames: ['Arjun Ramesh', 'Gokul Krishna'],
        moderatorNames: ['Maya Suresh', 'Nikhil Raj'],
        isVerified: true,
        memberCount: 420,
        followerCount: 1250,
        icon: Icons.code_rounded,
        themeColor: const Color(0xFF2563EB),
        tags: ['Drishti 2026', 'Coding', 'AI / ML', 'Hackathons'],
      ),
      ClubModel(
        id: 'club_2',
        name: 'CET Robotics Club',
        category: 'Technical',
        description: 'Pioneering robotics, autonomous rovers, and drone technology at CET. Outdoor drone flight testing at Gazebo and national rover challenge preparations.',
        leaderId: 'usr_1',
        leaderName: 'Ananya Nair',
        coLeaderNames: ['Vipin Das'],
        moderatorNames: ['Rahul K', 'Aswin B'],
        isVerified: true,
        memberCount: 280,
        followerCount: 890,
        icon: Icons.precision_manufacturing_rounded,
        themeColor: const Color(0xFF0284C7),
        tags: ['Robotics', 'Drishti 2026', 'IoT', 'Drones'],
      ),
      ClubModel(
        id: 'club_3',
        name: 'Dhwani - CET Music Club',
        category: 'Cultural',
        description: 'The musical heartbeat of CET. Organizers of Dhwani Cultural Fest, Battle of the Bands on the iconic Dhwani Stage, and Thursday sunset jamming sessions at the Gazebo.',
        leaderId: 'usr_5',
        leaderName: 'Devika Pillai',
        coLeaderNames: ['Shankar G'],
        moderatorNames: ['Tara Mohan'],
        isVerified: true,
        memberCount: 190,
        followerCount: 2100,
        icon: Icons.music_note_rounded,
        themeColor: const Color(0xFF8B5CF6),
        tags: ['Dhwani Fest', 'Music', 'Live Bands', 'Gazebo Jam'],
      ),
      ClubModel(
        id: 'club_4',
        name: 'IEDC CET',
        category: 'Entrepreneurship',
        description: 'Innovation and Entrepreneurship Development Centre. Organizers of Disha Techno-Management Summit, student startup seed incubation, and investor pitch sessions.',
        leaderId: 'usr_iedc',
        leaderName: 'Prof. Harikrishnan (Faculty) / Vivek S',
        coLeaderNames: ['Alen John', 'Pooja Varma'],
        moderatorNames: ['Sreejith N'],
        isVerified: true,
        memberCount: 510,
        followerCount: 1780,
        icon: Icons.rocket_launch_rounded,
        themeColor: const Color(0xFFF59E0B),
        tags: ['Disha Conclave', 'Startups', 'Incubation', 'Pitchathons'],
      ),
      ClubModel(
        id: 'club_5',
        name: 'CET Literary & Debating Society (LDS)',
        category: 'Cultural',
        description: 'Parliamentary debates, elocution, creative writing, and quizzing. Organizers of Mashi Arts & Literary Fest exhibitions at Archie Corner.',
        leaderId: 'usr_lds',
        leaderName: 'Tarun Mathew',
        coLeaderNames: ['Riya Philip'],
        moderatorNames: ['Varun Nair'],
        isVerified: true,
        memberCount: 145,
        followerCount: 620,
        icon: Icons.record_voice_over_rounded,
        themeColor: const Color(0xFFEC4899),
        tags: ['Mashi Fest', 'Debating', 'Literature', 'Quizzing'],
      ),
      ClubModel(
        id: 'club_6',
        name: 'CET Sports & Athletics Council',
        category: 'Sports',
        description: 'Inter-department leagues and university sports tournaments across Football, Basketball, Badminton, and Athletics @ CET Stadium & Courts.',
        leaderId: 'usr_sports',
        leaderName: 'Vishnu Prasad',
        coLeaderNames: ['Abhishek S'],
        moderatorNames: ['Kiran J'],
        isVerified: true,
        memberCount: 380,
        followerCount: 1400,
        icon: Icons.sports_soccer_rounded,
        themeColor: const Color(0xFF10B981),
        tags: ['Sports', 'Football', 'Athletics', 'Tournaments'],
      ),
    ];

    // Campus Events & Fests (Drishti, Dhwani, Disha, Mashi, Gazebo sessions)
    _events = [
      EventModel(
        id: 'evt_1',
        title: 'Drishti 2026: 36-Hour National AI & Systems Hackathon',
        clubId: 'club_1',
        clubName: 'CodeCET & Drishti Team',
        category: 'Drishti Fest',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        timeString: 'Fri, 6:00 PM - Sun, 6:00 AM',
        venue: 'CS Seminar Hall & PG Lab, CET',
        description: 'Flagship national hackathon of Drishti 2026 Tech Fest. Build next-gen AI agents and decentralized systems with mentors and ₹1,00,000 prize pool!',
        registeredCount: 248,
        icon: Icons.psychology_rounded,
        accentColor: const Color(0xFF2563EB),
      ),
      EventModel(
        id: 'evt_2',
        title: 'Gazebo Open Mic & Sunset Jam Session',
        clubId: 'club_3',
        clubName: 'Dhwani - CET Music Club',
        category: 'Campus Culture',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        timeString: 'Thursday, 5:00 PM - 7:00 PM',
        venue: 'Gazebo Mini Stage & Lawn',
        description: 'Acoustic unplugged guitars, beatboxing, and open jamming at the Gazebo as classes wrap up. Bring your instruments or just come enjoy!',
        registeredCount: 185,
        icon: Icons.music_note_rounded,
        accentColor: const Color(0xFF8B5CF6),
      ),
      EventModel(
        id: 'evt_3',
        title: 'Dhwani 2026: Battle of the Bands (Pro-Show Preliminary)',
        clubId: 'club_3',
        clubName: 'Dhwani Cultural Fest Committee',
        category: 'Dhwani Fest',
        dateTime: DateTime.now().add(const Duration(days: 7)),
        timeString: 'Next Friday, 5:30 PM - 9:30 PM',
        venue: 'Dhwani Stage (Main Open-Air Amphitheatre)',
        description: 'The annual musical clash of top collegiate rock and fusion bands on the iconic Dhwani Stage leading to the grand cultural fest pro-night.',
        registeredCount: 420,
        icon: Icons.mic_external_on_rounded,
        accentColor: const Color(0xFFEC4899),
      ),
      EventModel(
        id: 'evt_4',
        title: 'Disha 2026: Student Venture Pitch & Startup Conclave',
        clubId: 'club_4',
        clubName: 'IEDC CET',
        category: 'Disha Fest',
        dateTime: DateTime.now().add(const Duration(days: 10)),
        timeString: 'Tue, 10:00 AM - 4:30 PM',
        venue: 'CET Main Auditorium',
        description: 'Annual techno-management and venture pitching fest. Present student prototypes to KSUM venture partners and angel investors.',
        registeredCount: 160,
        icon: Icons.rocket_launch_rounded,
        accentColor: const Color(0xFFF59E0B),
      ),
      EventModel(
        id: 'evt_5',
        title: 'Mashi 2026: Archie Corner Design Sprint & Art Expo',
        clubId: 'club_5',
        clubName: 'CET LDS & Architecture Association',
        category: 'Mashi Fest',
        dateTime: DateTime.now().add(const Duration(days: 14)),
        timeString: 'Saturday, 11:00 AM - 5:00 PM',
        venue: 'Archie Corner Courtyard',
        description: 'Live sketching competitions, UI/UX design sprints, calligraphy workshops, and architectural photo galleries across Archie Corner.',
        registeredCount: 130,
        icon: Icons.palette_rounded,
        accentColor: const Color(0xFF10B981),
      ),
    ];

    // Activity Tracker Default Items (Club Events + Private Friend Activities with CET spots)
    _activities = [
      ActivityModel(
        id: 'act_1',
        title: 'Drishti 2026: 36-Hour AI Hackathon Team Prep',
        type: ActivityType.clubEvent,
        hostName: 'CodeCET',
        clubId: 'club_1',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        timeDisplay: 'Fri, 6:00 PM - Sun, 6:00 AM',
        location: 'CS PG Lab & Seminar Hall',
        description: 'Registered for Drishti flagship hackathon. Team formed with Sneha and Aditya.',
        invitedFriends: ['Sneha Krishnan', 'Aditya Varma'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFF2563EB),
      ),
      ActivityModel(
        id: 'act_2',
        title: 'Gazebo Project Brainstorming & Coding',
        type: ActivityType.studyGroup,
        hostName: 'Aditya Varma (You)',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        timeDisplay: 'Tomorrow, 4:30 PM - 6:30 PM',
        location: 'Gazebo Mini Stage / Lawn',
        description: 'Informal Flutter app prototyping and algorithm review over snacks at the Gazebo.',
        invitedFriends: ['Sneha Krishnan', 'Ananya Nair'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFF10B981),
      ),
      ActivityModel(
        id: 'act_3',
        title: 'Dhwani Stage Sunset Jam & Band Soundcheck',
        type: ActivityType.clubEvent,
        hostName: 'Dhwani CET',
        clubId: 'club_3',
        dateTime: DateTime.now().add(const Duration(days: 7)),
        timeDisplay: 'Next Friday, 5:30 PM - 9:30 PM',
        location: 'Dhwani Stage (Main Amphitheatre)',
        description: 'Live performance and support for inter-college band preliminary rounds.',
        invitedFriends: ['Devika Pillai', 'Rohit Menon'],
        isCompleted: false,
        isReminderSet: true,
        badgeColor: const Color(0xFFEC4899),
      ),
      ActivityModel(
        id: 'act_4',
        title: 'Archie Corner UI/UX Design & Coffee Sprint',
        type: ActivityType.privatePlan,
        hostName: 'Farhan Ali',
        dateTime: DateTime.now().add(const Duration(days: 4)),
        timeDisplay: 'Saturday, 3:00 PM - 5:00 PM',
        location: 'Archie Corner Courtyard',
        description: 'Wireframing Mashi fest posters and design system components.',
        invitedFriends: ['Farhan Ali', 'Aditya Varma'],
        isCompleted: false,
        isReminderSet: false,
        badgeColor: const Color(0xFFF59E0B),
      ),
    ];

    // Seed realistic friend chat conversations
    _conversations['usr_3'] = [
      ChatMessage(
        id: 'msg_1',
        senderId: 'usr_3',
        senderName: 'Sneha Krishnan',
        recipientId: 'usr_me',
        text: 'Hey Aditya! Are you ready for the Drishti Hackathon this weekend?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isMe: false,
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'usr_me',
        senderName: 'Aditya Varma',
        recipientId: 'usr_3',
        text: 'Hey Sneha! Yes, almost done setting up the repo. Shall we meet at Gazebo tomorrow around 4:30 PM to finalize our architecture?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: true,
      ),
      ChatMessage(
        id: 'msg_3',
        senderId: 'usr_3',
        senderName: 'Sneha Krishnan',
        recipientId: 'usr_me',
        text: 'Sounds great! I will bring the problem statement breakdowns. See you at Gazebo!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isMe: false,
      ),
    ];

    _conversations['usr_1'] = [
      ChatMessage(
        id: 'msg_4',
        senderId: 'usr_1',
        senderName: 'Ananya Nair',
        recipientId: 'usr_me',
        text: 'Hi Aditya, we are testing the obstacle avoidance drone tomorrow afternoon near the Gazebo lawn if you want to check it out.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: 'msg_5',
        senderId: 'usr_me',
        senderName: 'Aditya Varma',
        recipientId: 'usr_1',
        text: 'Awesome Ananya! Would love to see the ROS2 telemetry in action.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: true,
      ),
    ];

    _conversations['usr_4'] = [
      ChatMessage(
        id: 'msg_6',
        senderId: 'usr_4',
        senderName: 'Farhan Ali',
        recipientId: 'usr_me',
        text: 'Aditya, we are setting up the Mashi fest installations at Archie Corner. Drop by when you are free!',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isMe: false,
      ),
    ];
  }

  // --- Auth & Session Methods ---

  void login(String email, String password) {
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
        bio: 'Enthusiastic CETian exploring campus opportunities, clubs, and fests.',
        hobbies: ['Coding', 'Gaming', 'Music'],
        role: UserRole.student,
      );
    }
    notifyListeners();
  }

  void loginAsDemo(String roleType) {
    if (roleType == 'clubLeader') {
      _currentUser = UserModel(
        id: 'usr_lead_demo',
        name: 'Sneha Krishnan',
        email: 'sneha.k@cet.ac.in',
        semester: 6,
        degree: 'B.Tech',
        branch: 'Computer Science & Engg',
        bio: 'Lead of CodeCET. Passionate about distributed systems, Drishti fest hackathons, and building student developer communities at CET.',
        hobbies: ['Coding', 'Algorithms', 'AI / ML', 'Debating', 'Literature'],
        isClubAdmin: true,
        clubName: 'CodeCET',
        clubCategory: 'Technical',
        clubDescription: 'The official Computer Science & Coding Club of CET. Organizers of the Drishti National Hackathon.',
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
        bio: 'Full-stack builder passionate about Flutter, Distributed Systems, and campus hackathons. Usually hanging out around Gazebo or PG Lab with a filter coffee!',
        hobbies: ['Coding', 'AI / ML', 'Hackathons', 'Gaming', 'UI/UX Design'],
        isClubAdmin: false,
        role: UserRole.student,
        avatarColor: const Color(0xFF2563EB),
        connectedUserIds: ['usr_1', 'usr_3', 'usr_4'],
        followingClubIds: ['club_1', 'club_3', 'club_4'],
        joinedClubIds: ['club_1'],
        registeredEventIds: ['evt_1', 'evt_3'],
      );
    }
    notifyListeners();
  }

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

  void saveProfile(UserModel updatedUser) {
    _currentUser = updatedUser;

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

  void toggleClubJoinRequest(String clubId) {
    if (_currentUser == null) return;
    final pendingJoins = List<String>.from(_currentUser!.pendingClubJoinIds);
    final joined = List<String>.from(_currentUser!.joinedClubIds);

    if (joined.contains(clubId)) {
      joined.remove(clubId);
    } else if (pendingJoins.contains(clubId)) {
      pendingJoins.remove(clubId);
      joined.add(clubId);
    } else {
      pendingJoins.add(clubId);
    }

    _currentUser = _currentUser!.copyWith(
      pendingClubJoinIds: pendingJoins,
      joinedClubIds: joined,
    );
    notifyListeners();
  }

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

  void registerForEvent(EventModel event) {
    if (_currentUser == null) return;
    final registered = List<String>.from(_currentUser!.registeredEventIds);

    if (registered.contains(event.id)) {
      registered.remove(event.id);
      _activities.removeWhere((a) => a.id == 'act_evt_${event.id}' || a.title == event.title);
    } else {
      registered.add(event.id);
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

  void createClubEvent(EventModel event) {
    _events.insert(0, event);

    // Automatically add to Activity Tracker for the leader as the Host
    final leaderActivity = ActivityModel(
      id: 'act_evt_${event.id}',
      title: event.title,
      type: ActivityType.clubEvent,
      hostName: '${event.clubName} (You are Host)',
      clubId: event.clubId,
      dateTime: event.dateTime,
      timeDisplay: event.timeString,
      location: event.venue,
      description: event.description,
      invitedFriends: [_currentUser?.name ?? 'You'],
      isCompleted: false,
      isReminderSet: true,
      badgeColor: event.accentColor,
    );
    _activities.insert(0, leaderActivity);

    notifyListeners();
  }

  void addPrivateActivity(ActivityModel activity) {
    _activities.insert(0, activity);
    notifyListeners();
  }

  void toggleActivityReminder(String activityId) {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx != -1) {
      _activities[idx] = _activities[idx].copyWith(
        isReminderSet: !_activities[idx].isReminderSet,
      );
      notifyListeners();
    }
  }

  void toggleActivityCompleted(String activityId) {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx != -1) {
      _activities[idx] = _activities[idx].copyWith(
        isCompleted: !_activities[idx].isCompleted,
      );
      notifyListeners();
    }
  }

  // --- Chat / Direct Messaging Feature ---

  List<ChatMessage> getMessagesWith(String peerId) {
    return _conversations[peerId] ?? [];
  }

  Map<String, List<ChatMessage>> get allConversations => Map.unmodifiable(_conversations);

  void sendMessage({required String recipientId, required String text}) {
    if (_currentUser == null || text.trim().isEmpty) return;

    final myMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser!.id,
      senderName: _currentUser!.name.isNotEmpty ? _currentUser!.name : 'You',
      recipientId: recipientId,
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    _conversations.putIfAbsent(recipientId, () => []);
    _conversations[recipientId]!.add(myMsg);
    notifyListeners();

    // Simulate smart friendly peer response after a brief realistic pause
    final peer = _students.where((s) => s.id == recipientId).firstOrNull;
    if (peer != null) {
      Timer(const Duration(milliseconds: 900), () {
        final responses = [
          'Awesome! Let us meet up near Gazebo and discuss this.',
          'Got it! Looking forward to collaborating for Drishti 2026.',
          'Sounds great! I will share the notes before our session.',
          'Perfect! See you at Archie Corner soon.',
          'Thanks for reaching out! Let us get started on this project.',
        ];
        final replyText = responses[(_conversations[recipientId]!.length) % responses.length];

        final replyMsg = ChatMessage(
          id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
          senderId: peer.id,
          senderName: peer.name,
          recipientId: _currentUser!.id,
          text: replyText,
          timestamp: DateTime.now(),
          isMe: false,
        );

        _conversations[recipientId]!.add(replyMsg);
        notifyListeners();
      });
    }
  }

  void resetToMockData() {
    _conversations.clear();
    _initMockData();
    notifyListeners();
  }
}
