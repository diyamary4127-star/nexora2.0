import 'package:flutter/material.dart';

enum ActivityType { clubEvent, privatePlan, studyGroup, sports }

/// Activity Tracker item (club workshops, events, private friend activities)
class ActivityModel {
  final String id;
  final String title;
  final ActivityType type;
  final String hostName;
  final String? clubId;
  final DateTime dateTime;
  final String timeDisplay;
  final String location;
  final String description;
  final List<String> invitedFriends;
  final bool isCompleted;
  final bool isReminderSet;
  final Color badgeColor;

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.hostName,
    this.clubId,
    required this.dateTime,
    required this.timeDisplay,
    required this.location,
    required this.description,
    List<String>? invitedFriends,
    this.isCompleted = false,
    this.isReminderSet = true,
    this.badgeColor = const Color(0xFF2563EB),
  }) : invitedFriends = invitedFriends ?? [];

  ActivityModel copyWith({
    String? id,
    String? title,
    ActivityType? type,
    String? hostName,
    String? clubId,
    DateTime? dateTime,
    String? timeDisplay,
    String? location,
    String? description,
    List<String>? invitedFriends,
    bool? isCompleted,
    bool? isReminderSet,
    Color? badgeColor,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      hostName: hostName ?? this.hostName,
      clubId: clubId ?? this.clubId,
      dateTime: dateTime ?? this.dateTime,
      timeDisplay: timeDisplay ?? this.timeDisplay,
      location: location ?? this.location,
      description: description ?? this.description,
      invitedFriends: invitedFriends ?? List.from(this.invitedFriends),
      isCompleted: isCompleted ?? this.isCompleted,
      isReminderSet: isReminderSet ?? this.isReminderSet,
      badgeColor: badgeColor ?? this.badgeColor,
    );
  }
}
