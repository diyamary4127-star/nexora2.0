import 'package:flutter_test/flutter_test.dart';
import 'package:cet_connect/data/models/user_model.dart';
import 'package:cet_connect/data/models/activity_model.dart';
import 'package:cet_connect/data/services/mock_data_service.dart';

void main() {
  late MockDataService dataService;

  setUp(() {
    dataService = MockDataService();
    dataService.resetToMockData();
  });

  test('User login and role switching', () {
    dataService.loginAsDemo('student');
    expect(dataService.currentUser?.name, 'Aditya Varma');
    expect(dataService.currentUser?.isClubAdmin, false);

    dataService.loginAsDemo('clubLeader');
    expect(dataService.currentUser?.name, 'Sneha Krishnan');
    expect(dataService.currentUser?.isClubAdmin, true);
    expect(dataService.currentUser?.clubName, 'CodeCET');
  });

  test('Connect with peers updates connected list', () {
    dataService.loginAsDemo('student');
    final initialCount = dataService.currentUser!.connectedUserIds.length;

    // Connect to usr_2 (Rohit)
    dataService.toggleConnect('usr_2');
    expect(dataService.currentUser!.connectedUserIds.contains('usr_2'), true);
    expect(dataService.currentUser!.connectedUserIds.length, initialCount + 1);

    // Toggle disconnect
    dataService.toggleConnect('usr_2');
    expect(dataService.currentUser!.connectedUserIds.contains('usr_2'), false);
  });

  test('Join club request and follow toggle', () {
    dataService.loginAsDemo('student');
    const clubId = 'club_2'; // CET Robotics Club

    final initialFollowers = dataService.clubs.firstWhere((c) => c.id == clubId).followerCount;

    // Follow club
    dataService.toggleClubFollow(clubId);
    expect(dataService.currentUser!.followingClubIds.contains(clubId), true);
    expect(dataService.clubs.firstWhere((c) => c.id == clubId).followerCount, initialFollowers + 1);

    // Send Join Request
    dataService.toggleClubJoinRequest(clubId);
    expect(dataService.currentUser!.pendingClubJoinIds.contains(clubId), true);
  });

  test('Registering for a club event adds it automatically to Activity Tracker', () {
    dataService.loginAsDemo('student');
    final event = dataService.events.firstWhere((e) => e.id == 'evt_2');

    // Register
    dataService.registerForEvent(event);
    expect(dataService.currentUser!.registeredEventIds.contains('evt_2'), true);

    // Check presence in activity tracker
    final activity = dataService.activities.firstWhere((a) => a.title == event.title);
    expect(activity.type, ActivityType.clubEvent);
    expect(activity.location, event.venue);
  });

  test('Adding private activity with friends', () {
    dataService.loginAsDemo('student');
    final initialCount = dataService.activities.length;

    final newAct = ActivityModel(
      id: 'act_test_1',
      title: 'Operating Systems Lab Prep',
      type: ActivityType.studyGroup,
      hostName: 'Aditya Varma',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      timeDisplay: 'Tomorrow, 4:00 PM',
      location: 'Central Library',
      description: 'Reviewing semaphores and mutexes',
      invitedFriends: ['Sneha Krishnan', 'Rohit Menon'],
    );

    dataService.addPrivateActivity(newAct);
    expect(dataService.activities.length, initialCount + 1);
    expect(dataService.activities.first.title, 'Operating Systems Lab Prep');
  });

  test('Adding Co-Leaders and Moderators to Club', () {
    const clubId = 'club_1';
    dataService.addClubCoLeader(clubId, 'Arun Prakash');
    expect(dataService.clubs.firstWhere((c) => c.id == clubId).coLeaderNames.contains('Arun Prakash'), true);

    dataService.addClubModerator(clubId, 'Priya S');
    expect(dataService.clubs.firstWhere((c) => c.id == clubId).moderatorNames.contains('Priya S'), true);
  });

  test('Developer Statistics Telemetry', () {
    expect(dataService.totalUsers, greaterThanOrEqualTo(7));
    expect(dataService.totalClubs, 6);
    expect(dataService.totalEvents, 4);
    expect(dataService.totalActivities, greaterThanOrEqualTo(4));
  });
}
