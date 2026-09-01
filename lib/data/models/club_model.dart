import 'package:flutter/material.dart';

/// Club & Community model with leadership, co-leaders, moderators, and portfolio
class ClubModel {
  final String id;
  final String name;
  final String category; // Technical, Cultural, Sports, Entrepreneurship, Social
  final String description; // Portfolio description
  final String leaderId;
  final String leaderName;
  final List<String> coLeaderNames;
  final List<String> moderatorNames;
  final bool isVerified;
  final int memberCount;
  final int followerCount;
  final IconData icon;
  final Color themeColor;
  final List<String> tags;

  ClubModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.leaderId,
    required this.leaderName,
    List<String>? coLeaderNames,
    List<String>? moderatorNames,
    this.isVerified = true,
    this.memberCount = 0,
    this.followerCount = 0,
    this.icon = Icons.groups_rounded,
    this.themeColor = const Color(0xFF2563EB),
    List<String>? tags,
  })  : coLeaderNames = coLeaderNames ?? [],
        moderatorNames = moderatorNames ?? [],
        tags = tags ?? [];

  ClubModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? leaderId,
    String? leaderName,
    List<String>? coLeaderNames,
    List<String>? moderatorNames,
    bool? isVerified,
    int? memberCount,
    int? followerCount,
    IconData? icon,
    Color? themeColor,
    List<String>? tags,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      leaderId: leaderId ?? this.leaderId,
      leaderName: leaderName ?? this.leaderName,
      coLeaderNames: coLeaderNames ?? List.from(this.coLeaderNames),
      moderatorNames: moderatorNames ?? List.from(this.moderatorNames),
      isVerified: isVerified ?? this.isVerified,
      memberCount: memberCount ?? this.memberCount,
      followerCount: followerCount ?? this.followerCount,
      icon: icon ?? this.icon,
      themeColor: themeColor ?? this.themeColor,
      tags: tags ?? List.from(this.tags),
    );
  }
}
