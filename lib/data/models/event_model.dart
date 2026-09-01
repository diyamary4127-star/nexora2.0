import 'package:flutter/material.dart';

/// Club event or workshop
class EventModel {
  final String id;
  final String title;
  final String clubId;
  final String clubName;
  final String category;
  final DateTime dateTime;
  final String timeString;
  final String venue;
  final String description;
  final int registeredCount;
  final IconData icon;
  final Color accentColor;

  EventModel({
    required this.id,
    required this.title,
    required this.clubId,
    required this.clubName,
    required this.category,
    required this.dateTime,
    required this.timeString,
    required this.venue,
    required this.description,
    this.registeredCount = 0,
    this.icon = Icons.event_available_rounded,
    this.accentColor = const Color(0xFF2563EB),
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? clubId,
    String? clubName,
    String? category,
    DateTime? dateTime,
    String? timeString,
    String? venue,
    String? description,
    int? registeredCount,
    IconData? icon,
    Color? accentColor,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      timeString: timeString ?? this.timeString,
      venue: venue ?? this.venue,
      description: description ?? this.description,
      registeredCount: registeredCount ?? this.registeredCount,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
