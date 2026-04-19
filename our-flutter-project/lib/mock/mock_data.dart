import 'package:flutter/material.dart';
import '../models/models.dart';

class MockData {
  static final children = [
    ChildProfile(
      id: '1',
      nickname: 'Minh Anh',
      dateOfBirth: DateTime(2014, 3, 15),
      gender: Gender.female,
      avatarColor: const Color(0xFFFF6B9D),
      lastCheckinDate: DateTime.now(),
      streakDays: 5,
    ),
    ChildProfile(
      id: '2',
      nickname: 'Đức Minh',
      dateOfBirth: DateTime(2012, 8, 22),
      gender: Gender.male,
      avatarColor: const Color(0xFF6C63FF),
      lastCheckinDate: DateTime.now().subtract(const Duration(days: 2)),
      streakDays: 3,
    ),
  ];

  static List<DailyCheckin> checkinsFor(String childId) {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: i));
      return DailyCheckin(
        childId: childId,
        date: date,
        emotions: i == 0 ? [] : ['Vui', 'Bình thường'].take(i % 3 + 1).toList(),
        bodyStatus: childId == '1' ? 'Không trong kỳ' : 'Không có gì',
        symptoms: i % 2 == 0 ? ['Khỏe'] : ['Mệt', 'Đau đầu'],
        notes: i == 1 ? 'Hôm nay con vui vẻ, đi học về kể nhiều chuyện.' : null,
      );
    });
  }

  static List<BodyMeasurement> measurementsFor(String childId) {
    final now = DateTime.now();
    final isChild1 = childId == '1';
    final baseHeight = isChild1 ? 148.0 : 160.0;
    final baseWeight = isChild1 ? 38.0 : 48.0;

    return List.generate(6, (i) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthStr =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      return BodyMeasurement(
        childId: childId,
        month: monthStr,
        height: baseHeight + (5 - i) * 0.5,
        weight: baseWeight + (5 - i) * 0.3,
      );
    });
  }

  static List<CycleMonth> cycleDataFor(String childId) {
    if (childId != '1') return [];
    final now = DateTime.now();
    return List.generate(12, (i) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthStr =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      String status;
      if (i < 2) {
        status = 'yes';
      } else if (i < 5) {
        status = i % 2 == 0 ? 'yes' : 'no';
      } else if (i < 8) {
        status = 'yes';
      } else {
        status = 'nodata';
      }
      return CycleMonth(month: monthStr, status: status);
    });
  }

  // WHO median data for comparison
  static Map<int, Map<String, double>> whoGirls = {
    10: {'height': 138, 'weight': 32, 'bmi': 16.6},
    11: {'height': 145, 'weight': 36, 'bmi': 17.2},
    12: {'height': 154, 'weight': 41, 'bmi': 18.0},
    13: {'height': 156, 'weight': 45, 'bmi': 18.8},
    14: {'height': 160, 'weight': 50, 'bmi': 19.6},
  };

  static Map<int, Map<String, double>> whoBoys = {
    12: {'height': 151, 'weight': 41, 'bmi': 17.5},
    13: {'height': 157, 'weight': 46, 'bmi': 18.2},
    14: {'height': 163, 'weight': 49, 'bmi': 19.0},
    15: {'height': 169, 'weight': 55, 'bmi': 19.8},
  };

  static Map<String, double>? whoFor(ChildProfile child) {
    final table = child.isFemale ? whoGirls : whoBoys;
    return table[child.age];
  }

  // Mock user profile
  static const userName = 'Nguyễn Thị Hương';
  static const userRole = 'Mẹ';
  static const userPhone = '0912 345 678';
  static const userEmail = 'huong.nguyen@email.com';
}
