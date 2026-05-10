import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/strings.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/dashboard_screen.dart';
import 'screens/children_screen.dart';
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

  void _showLogin() {
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onLogin: () {
            _login();
            Navigator.of(navigatorKey.currentContext!).popUntil((r) => r.isFirst);
          },
          onRegister: () {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(
                builder: (_) => RegisterScreen(
                  onRegister: () {
                    _login();
                    Navigator.of(navigatorKey.currentContext!).popUntil((r) => r.isFirst);
                  },
                  onLogin: () => Navigator.of(navigatorKey.currentContext!).pop(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRegister() {
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          onRegister: () {
            _login();
            Navigator.of(navigatorKey.currentContext!).popUntil((r) => r.isFirst);
          },
          onLogin: () {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  onLogin: () {
                    _login();
                    Navigator.of(navigatorKey.currentContext!).popUntil((r) => r.isFirst);
                  },
                  onRegister: () => Navigator.of(navigatorKey.currentContext!).pop(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: S.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: _isLoggedIn
          ? const MainShell()
          : LandingScreen(onLogin: _showLogin, onRegister: _showRegister),
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

  @override
  Widget build(BuildContext context) {
    const screens = [
      DashboardScreen(),
      ChildrenScreen(),
      LibraryScreen(),
      NotificationsScreen(),
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
