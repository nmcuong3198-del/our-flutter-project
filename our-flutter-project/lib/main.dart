import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/strings.dart';
import 'models/models.dart';
import 'screens/dashboard_screen.dart';
import 'screens/child_detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SSCareApp());
}

class SSCareApp extends StatelessWidget {
  const SSCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: S.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onChildTap(ChildProfile child) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChildDetailScreen(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onChildTap: _onChildTap),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: S.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: S.profile,
          ),
        ],
      ),
    );
  }
}
