import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sscare/core/strings.dart';
import 'package:sscare/core/theme.dart';
import 'package:sscare/mock/mock_data.dart';
import 'package:sscare/screens/add_child_flow.dart';
import 'package:sscare/screens/article_detail_screen.dart';
import 'package:sscare/screens/article_editor_screen.dart';
import 'package:sscare/screens/all_states_report_screen.dart';
import 'package:sscare/screens/auth_screens.dart';
import 'package:sscare/screens/child_detail_screen.dart';
import 'package:sscare/screens/children_screen.dart';
import 'package:sscare/screens/cycle_tab.dart';
import 'package:sscare/screens/daily_journal_screen.dart';
import 'package:sscare/screens/height_prediction_screen.dart';
import 'package:sscare/screens/landing_screen.dart';
import 'package:sscare/screens/library_screen.dart';
import 'package:sscare/screens/library_search_screen.dart';
import 'package:sscare/screens/notifications_screen.dart';
import 'package:sscare/screens/profile_screen.dart';
import 'package:sscare/shared/child_picker.dart';

/// Wraps a screen in a MaterialApp using the real app theme so the build
/// methods run exactly as they would in the app.
Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

/// Pumps [widget] one frame plus a short settle window and asserts no
/// exception (render overflow, null deref, etc.) was thrown while building.
Future<void> _expectRenders(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  await tester.pump(const Duration(milliseconds: 350));
  expect(tester.takeException(), isNull);
}

void main() {
  final child = MockData.children.first;
  final article = MockData.articles.first;

  testWidgets('AddChildScreen renders', (t) async {
    await _expectRenders(t, _wrap(const AddChildScreen()));
    expect(find.text('Thêm hồ sơ con'), findsWidgets);
    expect(find.text('Tên gọi của con'), findsOneWidget);
  });

  testWidgets('LibrarySearchScreen renders', (t) async {
    await _expectRenders(t, _wrap(const LibrarySearchScreen()));
    expect(find.text('Gợi ý tìm kiếm'), findsOneWidget);
  });

  testWidgets('LibrarySearchScreen returns results for a query', (t) async {
    await t.pumpWidget(_wrap(const LibrarySearchScreen()));
    await t.pump(const Duration(milliseconds: 350));
    await t.enterText(find.byType(TextField).first, 'dậy thì');
    await t.pump(const Duration(milliseconds: 350));
    expect(t.takeException(), isNull);
    // Matching mock articles ("Dậy thì ở bé gái/trai") should be listed.
    expect(find.textContaining('Dậy thì'), findsWidgets);
  });

  testWidgets('ArticleEditorScreen renders', (t) async {
    await _expectRenders(t, _wrap(const ArticleEditorScreen()));
    expect(find.text('Tạo bài viết'), findsWidgets);
    expect(find.text('Gửi bài viết'), findsOneWidget);
  });

  testWidgets('HeightPredictionScreen renders + predicts', (t) async {
    await _expectRenders(t, _wrap(HeightPredictionScreen(child: child)));
    expect(find.text('Dự báo chiều cao'), findsWidgets);
    // Fill parent heights and predict.
    final fields = find.byType(TextField);
    await t.enterText(fields.at(1), '175');
    await t.enterText(fields.at(2), '162');
    await t.pump(const Duration(milliseconds: 200));
    await t.tap(find.text('Dự báo'));
    await t.pump(const Duration(milliseconds: 350));
    expect(t.takeException(), isNull);
    expect(find.textContaining('Chiều cao dự báo'), findsOneWidget);
  });

  testWidgets('AllStatesReportScreen renders', (t) async {
    await _expectRenders(t, _wrap(AllStatesReportScreen(child: child)));
    expect(find.text('Tất cả trạng thái'), findsWidgets);
    expect(find.text('Cảm xúc'), findsOneWidget);
  });

  testWidgets('DailyJournalScreen renders', (t) async {
    await _expectRenders(t, _wrap(DailyJournalScreen(child: child)));
    expect(find.text('Nhật ký hôm nay'), findsWidgets);
    expect(find.text('Bữa ăn'), findsOneWidget);
  });

  testWidgets('ChildPickerScreen renders a grid', (t) async {
    await _expectRenders(t, _wrap(const ChildPickerScreen()));
    expect(find.text('Chọn hồ sơ con'), findsWidgets);
    await t.scrollUntilVisible(find.text('Thêm hồ sơ'), 200);
    expect(find.text('Thêm hồ sơ'), findsOneWidget);
  });

  testWidgets('RegisterScreen steps through role -> account', (t) async {
    await _expectRenders(
      t,
      _wrap(RegisterScreen(onRegister: () {}, onLogin: () {})),
    );
    expect(find.text('Bạn là:'), findsOneWidget);
    await t.tap(find.text('Tiếp tục'));
    await t.pump(const Duration(milliseconds: 350));
    expect(t.takeException(), isNull);
    expect(find.text('Tạo tài khoản mới'), findsOneWidget);
    expect(find.text('Nhắc lại mật khẩu'), findsOneWidget);
  });

  testWidgets('LoginScreen renders', (t) async {
    await _expectRenders(
      t,
      _wrap(LoginScreen(onLogin: () {}, onRegister: () {})),
    );
    expect(find.text('Đăng nhập'), findsWidgets);
  });

  testWidgets('NotificationsScreen renders with filter pills', (t) async {
    await _expectRenders(t, _wrap(const NotificationsScreen()));
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Quản lý con'), findsOneWidget);
  });

  testWidgets('ArticleDetailScreen renders', (t) async {
    await _expectRenders(t, _wrap(ArticleDetailScreen(article: article)));
    expect(find.text(article.title), findsWidgets);
  });

  testWidgets('LibraryScreen renders with search + write actions', (t) async {
    await _expectRenders(t, _wrap(const LibraryScreen()));
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
  });

  testWidgets('Landing library is readable without login', (t) async {
    await t.pumpWidget(_wrap(LandingScreen(onLogin: () {}, onRegister: () {})));
    await t.pump(const Duration(milliseconds: 350));
    await t.tap(find.text(S.navLibrary.toUpperCase()));
    await t.pumpAndSettle();

    expect(find.text('Đăng nhập cần thiết'), findsNothing);
    expect(find.text(S.library), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.edit_note_rounded), findsNothing);
  });

  testWidgets('ProfileScreen renders', (t) async {
    await _expectRenders(t, _wrap(const ProfileScreen()));
    expect(find.text('Quản lý hồ sơ con'), findsOneWidget);
  });

  testWidgets('ChildrenScreen renders', (t) async {
    await _expectRenders(t, _wrap(const ChildrenScreen()));
    expect(find.text(child.nickname), findsWidgets);
  });

  testWidgets('CycleTab shows calendar + summary for a female child', (
    t,
  ) async {
    final female = MockData.children.firstWhere((c) => c.isFemale);
    await _expectRenders(t, _wrap(Scaffold(body: CycleTab(child: female))));
    expect(find.textContaining('Kinh nguyệt bình thường'), findsOneWidget);
    expect(find.text('Hành kinh'), findsOneWidget);
    expect(find.text('Dự kiến'), findsOneWidget);
    // Month navigation forward reveals the 'back to today' affordance.
    await t.tap(find.byIcon(Icons.chevron_right_rounded));
    await t.pump(const Duration(milliseconds: 300));
    expect(t.takeException(), isNull);
    expect(find.text('Về hôm nay'), findsOneWidget);
  });

  testWidgets('ChildDetailScreen hides Chu kỳ tab for boys, shows for girls', (
    t,
  ) async {
    final female = MockData.children.firstWhere((c) => c.isFemale);
    final male = MockData.children.firstWhere((c) => !c.isFemale);

    await _expectRenders(t, _wrap(ChildDetailScreen(child: female)));
    expect(find.text(S.tabCycle), findsOneWidget);

    await _expectRenders(t, _wrap(ChildDetailScreen(child: male)));
    expect(find.text(S.tabCycle), findsNothing);
  });

  // Renders every screen built/modified in this gap-implementation pass at a
  // realistic phone width (390x844) and asserts no layout overflow. The test
  // font is wider than the real Inter/Plus Jakarta Sans, so passing here is a
  // strong guarantee the screens fit on real devices.
  testWidgets('new screens render overflow-free at phone width', (t) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);

    final screens = <String, Widget>{
      'AddChildScreen': const AddChildScreen(),
      'LibrarySearchScreen': const LibrarySearchScreen(),
      'ArticleEditorScreen': const ArticleEditorScreen(),
      'HeightPredictionScreen': HeightPredictionScreen(child: child),
      'AllStatesReportScreen': AllStatesReportScreen(child: child),
      'DailyJournalScreen': DailyJournalScreen(child: child),
      'ChildPickerScreen': const ChildPickerScreen(),
      'RegisterScreen': RegisterScreen(onRegister: () {}, onLogin: () {}),
      'NotificationsScreen': const NotificationsScreen(),
      'ArticleDetailScreen': ArticleDetailScreen(article: article),
    };

    for (final entry in screens.entries) {
      await t.pumpWidget(_wrap(entry.value));
      await t.pump(const Duration(milliseconds: 300));
      expect(
        t.takeException(),
        isNull,
        reason: '${entry.key} overflowed at 390px',
      );
    }
  });
}
