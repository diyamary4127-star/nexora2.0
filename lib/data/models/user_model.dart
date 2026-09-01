import 'package:flutter/material.dart';

enum UserRole { student, clubLeader, developerAdmin }

/// Student and Club Admin Profile Model
class UserModel {
  final String id;
  final String name;
  final String email;
  final int semester;
  final String degree;
  final String branch;
  final String bio;
  final List<String> hobbies;
  final bool isClubAdmin;
  final String? clubName;
  final String? clubCategory;
  final String? clubDescription;
  final String? verificationDocName;
  final bool isClubVerified;
  final UserRole role;
  final Color avatarColor;
  final List<String> connectedUserIds;
  final List<String> pendingConnectUserIds;
  final List<String> followingClubIds;
  final List<String> joinedClubIds;
  final List<String> pendingClubJoinIds;
  final List<String> registeredEventIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.semester,
    required this.degree,
    required this.branch,
    required this.bio,
    required this.hobbies,
    this.isClubAdmin = false,
    this.clubName,
    this.clubCategory,
    this.clubDescription,
    this.verificationDocName,
    this.isClubVerified = true,
    this.role = UserRole.student,
    this.avatarColor = const Color(0xFF2563EB),
    List<String>? connectedUserIds,
    List<String>? pendingConnectUserIds,
    List<String>? followingClubIds,
    List<String>? joinedClubIds,
    List<String>? pendingClubJoinIds,
    List<String>? registeredEventIds,
  })  : connectedUserIds = connectedUserIds ?? [],
        pendingConnectUserIds = pendingConnectUserIds ?? [],
        followingClubIds = followingClubIds ?? [],
        joinedClubIds = joinedClubIds ?? [],
        pendingClubJoinIds = pendingClubJoinIds ?? [],
        registeredEventIds = registeredEventIds ?? [];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? semester,
    String? degree,
    String? branch,
    String? bio,
    List<String>? hobbies,
    bool? isClubAdmin,
    String? clubName,
    String? clubCategory,
    String? clubDescription,
    String? verificationDocName,
    bool? isClubVerified,
    UserRole? role,
    Color? avatarColor,
    List<String>? connectedUserIds,
    List<String>? pendingConnectUserIds,
    List<String>? followingClubIds,
    List<String>? joinedClubIds,
    List<String>? pendingClubJoinIds,
    List<String>? registeredEventIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      semester: semester ?? this.semester,
      degree: degree ?? this.degree,
      branch: branch ?? this.branch,
      bio: bio ?? this.bio,
      hobbies: hobbies ?? List.from(this.hobbies),
      isClubAdmin: isClubAdmin ?? this.isClubAdmin,
      clubName: clubName ?? this.clubName,
      clubCategory: clubCategory ?? this.clubCategory,
      clubDescription: clubDescription ?? this.clubDescription,
      verificationDocName: verificationDocName ?? this.verificationDocName,
      isClubVerified: isClubVerified ?? this.isClubVerified,
      role: role ?? this.role,
      avatarColor: avatarColor ?? this.avatarColor,
      connectedUserIds: connectedUserIds ?? List.from(this.connectedUserIds),
      pendingConnectUserIds: pendingConnectUserIds ?? List.from(this.pendingConnectUserIds),
      followingClubIds: followingClubIds ?? List.from(this.followingClubIds),
      joinedClubIds: joinedClubIds ?? List.from(this.joinedClubIds),
      pendingClubJoinIds: pendingClubJoinIds ?? List.from(this.pendingClubJoinIds),
      registeredEventIds: registeredEventIds ?? List.from(this.registeredEventIds),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'semester': semester,
      'degree': degree,
      'branch': branch,
      'bio': bio,
      'hobbies': hobbies,
      'isClubAdmin': isClubAdmin,
      'clubName': clubName,
      'clubCategory': clubCategory,
      'clubDescription': clubDescription,
      'verificationDocName': verificationDocName,
      'isClubVerified': isClubVerified,
      'role': role.name,
      'connectedUserIds': connectedUserIds,
      'pendingConnectUserIds': pendingConnectUserIds,
      'followingClubIds': followingClubIds,
      'joinedClubIds': joinedClubIds,
      'pendingClubJoinIds': pendingClubJoinIds,
      'registeredEventIds': registeredEventIds,
    };
  }
}
