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
    final emotionPool = ['Vui', 'Bình thường', 'Chán, mệt', 'Buồn', 'Cáu', 'Lo lắng', 'Uể oải'];
    return List.generate(30, (i) {
      final date = now.subtract(Duration(days: i));
      // Skip some days to simulate missing check-ins
      if (i == 0 || i == 5 || i == 12 || i == 20 || i == 25) {
        return DailyCheckin(childId: childId, date: date);
      }
      final emoIndex = (date.day + (childId == '1' ? 0 : 3)) % emotionPool.length;
      final emo2Index = (date.day * 2 + 1) % emotionPool.length;
      return DailyCheckin(
        childId: childId,
        date: date,
        emotions: emo2Index != emoIndex
            ? [emotionPool[emoIndex], emotionPool[emo2Index]]
            : [emotionPool[emoIndex]],
        bodyStatus: childId == '1' ? 'Không trong kỳ' : 'Không có gì',
        symptoms: i % 3 == 0 ? ['Mệt', 'Đau đầu'] : ['Khỏe'],
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

  // Practice items per child
  static List<PracticeItem> practiceFor(String childId) {
    final now = DateTime.now();
    final monthYear = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return [
      // Quan sát
      PracticeItem(
        id: 'p1', childId: childId, category: 'quan_sat',
        title: 'Quan sát biểu hiện cảm xúc của con khi tan học',
        monthYear: monthYear, executor: 'Mẹ', plannedWeek: 1,
      ),
      PracticeItem(
        id: 'p2', childId: childId, category: 'quan_sat',
        title: 'Ghi nhận thời gian con ngủ và thức dậy trong 1 tuần',
        monthYear: monthYear, executor: 'Bố', plannedWeek: 2,
      ),
      PracticeItem(
        id: 'p3', childId: childId, category: 'quan_sat',
        title: 'Quan sát con tương tác với bạn bè',
        monthYear: monthYear, executor: 'Mẹ', plannedWeek: 3, isCompleted: true,
        notes: 'Con chơi vui vẻ với bạn Linh, có vẻ tự tin hơn.',
      ),
      // Giao tiếp
      PracticeItem(
        id: 'p4', childId: childId, category: 'giao_tiep',
        title: 'Hỏi con về 1 điều thú vị nhất trong ngày',
        monthYear: monthYear, executor: 'Mẹ', plannedWeek: 1, isCompleted: true,
        notes: 'Con kể về tiết thí nghiệm khoa học.',
      ),
      PracticeItem(
        id: 'p5', childId: childId, category: 'giao_tiep',
        title: 'Nói chuyện về sự thay đổi cơ thể một cách tự nhiên',
        monthYear: monthYear, executor: 'Mẹ', plannedWeek: 2,
      ),
      PracticeItem(
        id: 'p6', childId: childId, category: 'giao_tiep',
        title: 'Khen ngợi con về 1 nỗ lực cụ thể (không chỉ kết quả)',
        monthYear: monthYear, executor: 'Bố', plannedWeek: 3,
      ),
      // Hỗ trợ
      PracticeItem(
        id: 'p7', childId: childId, category: 'ho_tro',
        title: 'Chuẩn bị sẵn băng vệ sinh trong cặp sách của con',
        monthYear: monthYear, executor: 'Mẹ', plannedWeek: 1, isCompleted: true,
      ),
      PracticeItem(
        id: 'p8', childId: childId, category: 'ho_tro',
        title: 'Đưa con đi khám sức khỏe định kỳ',
        monthYear: monthYear, executor: 'Bố', plannedWeek: 4,
      ),
      PracticeItem(
        id: 'p9', childId: childId, category: 'ho_tro',
        title: 'Tạo góc riêng tư cho con trong nhà',
        monthYear: monthYear, executor: 'Bố', plannedWeek: 2,
      ),
    ];
  }

  // Reminders per child
  static List<Reminder> remindersFor(String childId) {
    final now = DateTime.now();
    return [
      Reminder(
        id: 'r1', childId: childId,
        date: now.add(const Duration(days: 2)),
        label: 'Đưa con đi khám răng',
      ),
      Reminder(
        id: 'r2', childId: childId,
        date: now.add(const Duration(days: 5)),
        label: 'Họp phụ huynh trường',
      ),
      Reminder(
        id: 'r3', childId: childId,
        date: now.add(const Duration(days: 10)),
        label: 'Mua vitamin cho con',
      ),
      Reminder(
        id: 'r4', childId: childId,
        date: now.subtract(const Duration(days: 1)),
        label: 'Nhắc con uống thuốc sắt',
        isActive: false,
      ),
      Reminder(
        id: 'r5', childId: childId,
        date: now.add(const Duration(days: 14)),
        label: 'Sinh nhật bạn Linh — mua quà',
      ),
    ];
  }

  // Symptom summary for last 30 days (precomputed from check-ins)
  static Map<String, int> symptomSummaryFor(String childId) {
    final checkins = checkinsFor(childId);
    final counts = <String, int>{};
    for (final c in checkins) {
      for (final s in c.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
      if (c.bodyStatus != null && c.bodyStatus!.isNotEmpty) {
        counts[c.bodyStatus!] = (counts[c.bodyStatus!] ?? 0) + 1;
      }
    }
    return counts;
  }

  // Emotion summary for last 30 days
  static Map<String, int> emotionSummaryFor(String childId) {
    final checkins = checkinsFor(childId);
    final counts = <String, int>{};
    for (final c in checkins) {
      for (final e in c.emotions) {
        counts[e] = (counts[e] ?? 0) + 1;
      }
    }
    return counts;
  }

  // Mock user profile
  static const userName = 'Nguyễn Thị Hương';
  static const userRole = 'Mẹ';
  static const userPhone = '0912 345 678';
  static const userEmail = 'huong.nguyen@email.com';

  // Mock articles
  static final articles = [
    Article(
      id: 'a1',
      title: 'Dậy thì ở bé gái: Những thay đổi bố mẹ cần biết',
      excerpt: 'Giai đoạn dậy thì bắt đầu từ 8-13 tuổi với nhiều thay đổi về thể chất và tâm lý. Bố mẹ cần hiểu để đồng hành cùng con.',
      body: 'Dậy thì là giai đoạn chuyển tiếp quan trọng trong cuộc đời mỗi đứa trẻ. Ở bé gái, dậy thì thường bắt đầu từ 8-13 tuổi, sớm hơn bé trai khoảng 1-2 năm.\n\nNhững thay đổi thể chất bao gồm:\n• Phát triển ngực\n• Mọc lông ở nách và vùng kín\n• Tăng chiều cao nhanh\n• Bắt đầu có kinh nguyệt\n• Da thay đổi, có thể nổi mụn\n\nNhững thay đổi tâm lý:\n• Nhạy cảm hơn với lời nói\n• Thay đổi tâm trạng thất thường\n• Quan tâm đến ngoại hình\n• Muốn được tôn trọng sự riêng tư\n\nĐiều quan trọng nhất là bố mẹ hãy tạo không gian an toàn để con có thể hỏi bất cứ điều gì. Đừng chờ con hỏi — hãy chủ động nói chuyện một cách tự nhiên.',
      category: 'physical',
      readMinutes: 5,
      isFeatured: true,
    ),
    Article(
      id: 'a2',
      title: 'Cách nói chuyện với con về cơ thể mà không gây xấu hổ',
      excerpt: 'Nhiều bố mẹ lúng túng khi nói về cơ thể với con. Đây là hướng dẫn giúp cuộc trò chuyện trở nên tự nhiên.',
      body: 'Nói chuyện về cơ thể với con tuổi dậy thì có thể khiến cả bố mẹ và con đều ngại ngùng. Nhưng đây là cuộc trò chuyện cần thiết.\n\n5 nguyên tắc vàng:\n\n1. Dùng tên gọi đúng: Gọi tên các bộ phận cơ thể bằng tên khoa học. Điều này giúp con hiểu rằng cơ thể không có gì đáng xấu hổ.\n\n2. Bình thường hóa: "Ai cũng trải qua giai đoạn này" — câu nói đơn giản nhưng rất hiệu quả.\n\n3. Chọn thời điểm tự nhiên: Không cần ngồi xuống "nói chuyện nghiêm túc". Có thể nói trong lúc đi xe, nấu ăn, hoặc xem phim.\n\n4. Lắng nghe nhiều hơn nói: Hỏi con "Con nghĩ sao?" thay vì giảng bài.\n\n5. Chấp nhận sự lúng túng: Nói "Mẹ cũng thấy hơi ngại khi nói chuyện này, nhưng mẹ muốn con biết..."',
      category: 'mental',
      readMinutes: 4,
      isFeatured: true,
    ),
    Article(
      id: 'a3',
      title: 'Kinh nguyệt lần đầu: Hướng dẫn chuẩn bị cho con',
      excerpt: 'Kinh nguyệt lần đầu có thể khiến trẻ lo lắng nếu không được chuẩn bị. Đây là cách giúp con sẵn sàng.',
      body: 'Kinh nguyệt lần đầu (menarche) thường đến ở tuổi 10-15. Bố mẹ nên nói chuyện với con về kinh nguyệt TRƯỚC khi nó xảy ra.\n\nChuẩn bị thế nào:\n• Giải thích kinh nguyệt là gì bằng ngôn ngữ đơn giản\n• Chuẩn bị sẵn băng vệ sinh trong cặp sách của con\n• Dạy con cách sử dụng băng vệ sinh\n• Nói rõ: "Nếu con có kinh ở trường, con có thể đến phòng y tế hoặc gọi cho mẹ"\n\nKhi kinh nguyệt đến:\n• Bình tĩnh và tích cực: "Chúc mừng con, cơ thể con đang phát triển khỏe mạnh"\n• Hướng dẫn theo dõi chu kỳ\n• Giải thích về đau bụng kinh và cách giảm đau\n• Nhắc con uống nhiều nước và nghỉ ngơi',
      category: 'physical',
      readMinutes: 6,
      isFeatured: false,
    ),
    Article(
      id: 'a4',
      title: '5 cách giúp con quản lý cảm xúc tuổi dậy thì',
      excerpt: 'Thay đổi hormone khiến cảm xúc con thất thường. Dưới đây là 5 kỹ năng đơn giản bố mẹ có thể dạy con.',
      body: 'Hormone thay đổi trong giai đoạn dậy thì khiến cảm xúc của trẻ như "tàu lượn siêu tốc". Đây không phải lỗi của con — đó là sinh học.\n\n5 kỹ năng giúp con:\n\n1. Đặt tên cảm xúc: Thay vì nói "Con bực", giúp con nói cụ thể hơn: "Con thất vọng vì..." hoặc "Con lo lắng về..."\n\n2. Hít thở 4-7-8: Hít vào 4 giây, giữ 7 giây, thở ra 8 giây. Làm 3 lần khi cảm thấy quá tải.\n\n3. Viết nhật ký: Khuyến khích con ghi lại cảm xúc mỗi ngày. App SSCare có tính năng check-in cảm xúc giúp con làm điều này dễ dàng.\n\n4. Vận động: 30 phút đi bộ hoặc thể dục giúp giảm căng thẳng hiệu quả.\n\n5. Nói chuyện với người tin tưởng: Có thể là bố mẹ, anh chị, hoặc thầy cô.',
      category: 'skills',
      readMinutes: 4,
      isFeatured: true,
    ),
    Article(
      id: 'a5',
      title: 'Khi nào cần đưa con đi khám bác sĩ?',
      excerpt: 'Một số dấu hiệu trong giai đoạn dậy thì cần sự tư vấn y tế. Bố mẹ nên biết để can thiệp kịp thời.',
      body: 'Hầu hết thay đổi trong giai đoạn dậy thì là bình thường. Tuy nhiên, một số dấu hiệu cần đưa con đi khám:\n\n🚨 Dấu hiệu cần khám ngay:\n• Dậy thì trước 8 tuổi (bé gái) hoặc 9 tuổi (bé trai)\n• Chưa có dấu hiệu dậy thì sau 13 tuổi (bé gái) hoặc 14 tuổi (bé trai)\n• Kinh nguyệt rất đau, ảnh hưởng đến sinh hoạt\n• Chu kỳ kinh nguyệt dưới 21 ngày hoặc trên 45 ngày\n• Chảy máu kinh kéo dài hơn 7 ngày\n• Tăng hoặc giảm cân bất thường\n\n⚠️ Dấu hiệu cần theo dõi:\n• Mụn trứng cá nặng\n• Rối loạn giấc ngủ kéo dài\n• Thay đổi tâm trạng nghiêm trọng\n• Đau đầu thường xuyên',
      category: 'alerts',
      readMinutes: 5,
      isFeatured: false,
    ),
    Article(
      id: 'a6',
      title: 'Dinh dưỡng cho trẻ tuổi dậy thì',
      excerpt: 'Giai đoạn dậy thì cần nhiều dinh dưỡng hơn. Bố mẹ cần biết con cần ăn gì và tránh gì.',
      body: 'Trẻ tuổi dậy thì đang tăng trưởng nhanh chóng, cần năng lượng và dưỡng chất nhiều hơn.\n\nDưỡng chất quan trọng:\n• Canxi: 1300mg/ngày — sữa, phô mai, rau xanh đậm\n• Sắt: đặc biệt quan trọng cho bé gái khi có kinh — thịt đỏ, rau bina, đậu\n• Protein: cần cho phát triển cơ — thịt, cá, trứng, đậu\n• Kẽm: hỗ trợ phát triển và miễn dịch — hải sản, hạt\n\nThói quen ăn uống tốt:\n• Ăn sáng đầy đủ mỗi ngày\n• Uống đủ 1.5-2 lít nước\n• Hạn chế đồ ăn nhanh, nước ngọt\n• Không bỏ bữa để giảm cân\n\nLưu ý: Trẻ tuổi dậy thì dễ bị ảnh hưởng bởi hình ảnh cơ thể trên mạng xã hội. Bố mẹ cần nhấn mạnh rằng sức khỏe quan trọng hơn ngoại hình.',
      category: 'physical',
      readMinutes: 5,
      isFeatured: false,
    ),
    Article(
      id: 'a7',
      title: 'Ranh giới cá nhân: Dạy con nói "Không"',
      excerpt: 'Trẻ cần biết cách đặt ranh giới an toàn cho bản thân. Đây là kỹ năng sống quan trọng.',
      body: 'Dạy con về ranh giới cá nhân là bảo vệ con trước nhiều tình huống nguy hiểm.\n\nDạy con:\n• Cơ thể con thuộc về con: Không ai được chạm vào cơ thể con nếu con không đồng ý\n• Quyền nói "Không": Con có quyền từ chối bất cứ điều gì khiến con khó chịu\n• Bí mật tốt vs bí mật xấu: Bí mật tốt (quà sinh nhật) vs bí mật xấu (ai đó bảo con giấu việc họ chạm vào con)\n• Nói với người lớn tin tưởng: Nếu ai đó làm con khó chịu, hãy nói với bố mẹ hoặc thầy cô\n\nBố mẹ cũng cần:\n• Tôn trọng ranh giới của con (gõ cửa trước khi vào phòng con)\n• Không ép con ôm hôn người thân nếu con không muốn\n• Làm gương: cho con thấy bố mẹ cũng đặt ranh giới',
      category: 'skills',
      readMinutes: 4,
      isFeatured: false,
    ),
    Article(
      id: 'a8',
      title: 'Dậy thì ở bé trai: Điều bố mẹ nên biết',
      excerpt: 'Bé trai cũng trải qua nhiều thay đổi lớn khi dậy thì. Hiểu biết giúp bố mẹ hỗ trợ con tốt hơn.',
      body: 'Dậy thì ở bé trai thường bắt đầu từ 9-14 tuổi. Nhiều bố mẹ tập trung vào bé gái mà quên rằng bé trai cũng cần được hỗ trợ.\n\nThay đổi thể chất:\n• Giọng nói trầm hơn (vỡ giọng)\n• Mọc râu, lông nách, lông chân\n• Tăng chiều cao nhanh\n• Phát triển cơ bắp\n• Mộng tinh — hoàn toàn bình thường\n\nThay đổi tâm lý:\n• Muốn chứng tỏ bản thân\n• Dễ nổi nóng\n• Quan tâm đến bạn khác giới\n• Cần không gian riêng\n\nBố mẹ nên:\n• Nói chuyện về mộng tinh, thay đổi cơ thể — đặc biệt bố nên tham gia\n• Không chế giễu khi con vỡ giọng\n• Hướng dẫn vệ sinh cá nhân (đặc biệt khi bắt đầu ra mồ hôi nhiều)\n• Tôn trọng nhu cầu riêng tư của con',
      category: 'physical',
      readMinutes: 5,
      isFeatured: false,
    ),
  ];

  static List<Article> articlesByCategory(String category) =>
      articles.where((a) => a.category == category).toList();

  static List<Article> get featuredArticles =>
      articles.where((a) => a.isFeatured).toList();

  // Mock notifications
  static final notifications = [
    AppNotification(
      id: 'n1',
      title: 'Bài viết mới',
      body: 'Thư viện vừa cập nhật: "Dậy thì ở bé gái: Những thay đổi bố mẹ cần biết"',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'article',
    ),
    AppNotification(
      id: 'n2',
      title: 'Nhắc cập nhật',
      body: 'Đừng quên cập nhật thông tin của bé Minh Anh hôm nay nhé!',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      type: 'checkin',
    ),
    AppNotification(
      id: 'n3',
      title: 'Bài viết mới',
      body: '"5 cách giúp con quản lý cảm xúc tuổi dậy thì" — Đọc ngay!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'article',
    ),
    AppNotification(
      id: 'n4',
      title: 'Nhắc cập nhật',
      body: '3 ngày rồi chưa cập nhật bé Đức Minh, thực hiện ngay nhé!',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: 'checkin',
      isRead: true,
    ),
    AppNotification(
      id: 'n5',
      title: 'SSCare',
      body: 'Giai đoạn này con dễ nhạy cảm hơn bình thường. Chỉ cần lắng nghe, chưa cần góp ý.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: 'system',
      isRead: true,
    ),
  ];
}
