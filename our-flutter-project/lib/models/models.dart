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

class PracticeItem {
  final String id;
  final String childId;
  final String category; // quan_sat | giao_tiep | ho_tro
  final String title;
  final String monthYear; // YYYY-MM
  String executor; // Ông|Bà|Bố|Mẹ
  int plannedWeek; // 1-4
  bool isCompleted;
  String? notes;

  PracticeItem({
    required this.id,
    required this.childId,
    required this.category,
    required this.title,
    required this.monthYear,
    this.executor = 'Mẹ',
    this.plannedWeek = 1,
    this.isCompleted = false,
    this.notes,
  });
}

class Reminder {
  final String id;
  final String childId;
  final DateTime date;
  final String label;
  final String? note;
  bool isActive;

  Reminder({
    required this.id,
    required this.childId,
    required this.date,
    required this.label,
    this.note,
    this.isActive = true,
  });
}

class Article {
  final String id;
  final String title;
  final String excerpt;
  final String body;
  final String category; // mental | physical | skills | alerts
  final int readMinutes;
  final bool isFeatured;
  int rating; // 0 = unrated, 1-5
  bool isRead;
  bool isSaved;

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.category,
    required this.readMinutes,
    this.isFeatured = false,
    this.rating = 0,
    this.isRead = false,
    this.isSaved = false,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final String type; // article | checkin | system
  final String category; // child | other
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.type,
    this.category = 'other',
    this.isRead = false,
  });
}
