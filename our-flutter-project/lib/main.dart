import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/strings.dart';
import 'models/models.dart';
import 'screens/landing_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/child_detail_screen.dart';
import 'screens/library_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(const SSCareApp());
}

class SSCareApp extends StatefulWidget {
  const SSCareApp({super.key});

  @override
  State<SSCareApp> createState() => _SSCareAppState();
}

class _SSCareAppState extends State<SSCareApp> {
  bool _isLoggedIn = false;

  void _login() => setState(() => _isLoggedIn = true);
  void _logout() => setState(() => _isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: S.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn
          ? MainShell(onLogout: _logout)
          : LandingScreen(onLogin: _login, onRegister: _login),
    );
  }
}

class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  const MainShell({super.key, required this.onLogout});

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
      DashboardScreen(onChildTap: _onChildTap),
      const LibraryScreen(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: S.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people_rounded),
            label: S.navChildren,
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: S.navLibrary,
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: S.navNotifications,
          ),
        ],
      ),
    );
  }
}
