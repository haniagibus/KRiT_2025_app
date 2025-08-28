import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/views/screens/admin/admin_screen.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';
import 'package:krit_app/views/screens/info/info_screen.dart';
import 'package:krit_app/views/screens/login/login_screen.dart';
import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
import 'package:krit_app/views/screens/reports/reports_screen.dart';
import 'package:krit_app/theme/app_theme.dart';

import 'package:provider/provider.dart';
import 'package:krit_app/services/auth_service.dart';

import 'services/api_service.dart';
import 'services/favourite_event_service.dart';
import 'models/event/events_data_storage.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create our data storage instances first
  final reportsStorage = ReportsDataStorage();
  final eventsStorage = EventsDataStorage(reportsStorage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider.value(value: reportsStorage),
        ChangeNotifierProvider.value(value: eventsStorage),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize data in a way that won't trigger rebuilds
    _initializeData(context);

    return MaterialApp(
      title: 'KRiT App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      home: const MyHomePage(),
    );
  }

  void _initializeData(BuildContext context) {
    // Only initialize once when the app first starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use a flag on a singleton to ensure we only initialize once
      final apiService = ApiService();
      if (!apiService.dataInitialized) {
        print("First time initialization");
        final favoritesService = Provider.of<FavoritesService>(context, listen: false);
        Provider.of<ReportsDataStorage>(context, listen: false)
            .initializeReports()
            .then((_) {
          Provider.of<EventsDataStorage>(context, listen: false)
              .initializeEvents(favoritesService);
        });

        apiService.dataInitialized = true;
      }
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController controller = PageController(initialPage: 0);
  bool _showInstallHint = false;

  void _onItemTapped(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    _onPageChanged(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkTooltipVisibility();
  }

  void _checkTooltipVisibility() {
    if (!kIsWeb) return;

    final isStandalone = html.window.matchMedia('(display-mode: standalone)').matches;
    final wasDismissed = html.window.localStorage['installHintDismissed'] == 'true';

    if (!isStandalone && !wasDismissed) {
      setState(() => _showInstallHint = true);
    }
  }

  void _dismissTooltip() {
    html.window.localStorage['installHintDismissed'] = 'true';
    setState(() => _showInstallHint = false);
  }

  String _getInstallMessage() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
      return 'Kliknij opcję "Udostępnij" i wybierz „Dodaj do ekranu początkowego”';
    } else {
      return 'Kliknij opcję Menu (⋮) i wybierz „Dodaj do ekranu głównego”';
    }
  }

  Widget _getPlatformIcon() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') || userAgent.contains('ipad') || userAgent.contains('macintosh')) {
      return const Icon(Icons.ios_share, size: 28, color: Colors.black87); // iOS-style share
    } else {
      return const Icon(Icons.more_vert, size: 28, color: Colors.black87); // Android-style menu
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? Text(
                'KRiT $currentYear',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : _selectedIndex == 1
                ? Text('Harmonogram')
                : Text('Referaty'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: _selectedIndex == 0 ? 0 : 4,
        actions: [
          IconButton(
              icon: const Icon(Icons.question_mark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                );
              }),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return IconButton(
                icon: const Icon(Icons.account_circle),
                tooltip: authProvider.role == 'admin'
                    ? 'Panel administracyjny'
                    : 'Logowanie',
                onPressed: () {
                  if (authProvider.role == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              onPageChanged: _onPageChanged,
              children: const [
                HomeScreen(),
                ScheduleScreen(),
                ReportsScreen(),
              ],
            ),
            // Tooltip popup
            if (_showInstallHint)
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _getPlatformIcon(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zainstaluj KRiT $currentYear',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getInstallMessage(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black54),
                            onPressed: _dismissTooltip,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      // drawer: SideMenu(
      //   selectedIndex: _selectedIndex,
      //   onItemSelected: (int index) {
      //     Navigator.pop(context);
      //     _onItemTapped(index);
      //   },
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Start",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: "Harmonogram",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.book),
      //       label: "Referaty",
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Start",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Harmonogram",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Referaty",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 28,
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 26),
        ),
      ),
    );
  }
}
