import 'package:flutter/material.dart';

enum Gender { male, female }

class ChildProfile {
  final String id;
  final String nickname;
  final DateTime dateOfBirth;
  final Gender gender;
  final Color avatarColor;
  final DateTime? lastCheckinDate;
  final int streakDays;

  const ChildProfile({
    required this.id,
    required this.nickname,
    required this.dateOfBirth,
    required this.gender,
    required this.avatarColor,
    this.lastCheckinDate,
    this.streakDays = 0,
  });

  int get age => DateTime.now().difference(dateOfBirth).inDays ~/ 365;
  String get initials => nickname.isNotEmpty ? nickname[0].toUpperCase() : '?';
  bool get isFemale => gender == Gender.female;
}

class EmotionEntry {
  final String emoji;
  final String label;
  bool selected;

  EmotionEntry({required this.emoji, required this.label, this.selected = false});
}

class BodyStatusOption {
  final IconData icon;
  final String label;
  bool selected;

  BodyStatusOption({required this.icon, required this.label, this.selected = false});
}

class SymptomOption {
  final IconData icon;
  final String label;
  bool selected;

  SymptomOption({required this.icon, required this.label, this.selected = false});
}

class DailyCheckin {
  final String childId;
  final DateTime date;
  final List<String> emotions;
  final String? bodyStatus;
  final List<String> symptoms;
  final String? notes;

  const DailyCheckin({
    required this.childId,
    required this.date,
    this.emotions = const [],
    this.bodyStatus,
    this.symptoms = const [],
    this.notes,
  });
}

class BodyMeasurement {
  final String childId;
  final String month; // YYYY-MM
  final double height;
  final double weight;

  const BodyMeasurement({
    required this.childId,
    required this.month,
    required this.height,
    required this.weight,
  });

  double get bmi => weight / ((height / 100) * (height / 100));
}

class CycleMonth {
  final String month; // YYYY-MM
  final String status; // 'yes' | 'no' | 'nodata'

  const CycleMonth({required this.month, required this.status});
}
