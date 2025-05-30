//
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:krit_app/models/report/reports_data_storage.dart';
// import 'package:krit_app/views/screens/home/home_screen.dart';
// import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
// import 'package:krit_app/views/screens/reports/reports_screen.dart';
// import 'package:krit_app/theme/app_theme.dart';
// import 'package:krit_app/views/widgets/side_menu.dart';
// import 'package:krit_app/generated/l10n.dart';
//
// import 'package:provider/provider.dart';
// import 'package:krit_app/services/auth_service.dart';
// import 'package:syncfusion_flutter_core/core.dart';
//
// import 'models/event/events_data_storage.dart';
//
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SyncfusionLicense.registerLicense('TWÓJ_KLUCZ_TUTAJ');
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => ReportsDataStorage()), // No callback needed
//         ChangeNotifierProxyProvider<ReportsDataStorage, EventsDataStorage>(
//           create: (context) => EventsDataStorage(
//             Provider.of<ReportsDataStorage>(context, listen: false),
//           ),
//           update: (_, reportsStorage, previous) =>
//           previous!..updateReportsStorage(reportsStorage),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize both reports and events data after app is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ReportsDataStorage>(context, listen: false).initializeReports();
//       Provider.of<EventsDataStorage>(context, listen: false).initializeEvents();
//     });
//
//     return MaterialApp(
//       title: 'KRiT App',
//       theme: AppTheme.lightTheme,
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en', ''),
//         Locale('pl', ''),
//       ],
//       home: const MyHomePage(),
//     );
//   }
// }
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
//   final PageController controller = PageController(initialPage: 0);
//
//   @override
//   void initState() {
//     super.initState();
//     // Alternative place to initialize data if needed
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   Provider.of<ReportsDataStorage>(context, listen: false).initializeReports();
//     // });
//   }
//
//   void _onItemTapped(int index) {
//     controller.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.ease,
//     );
//     _onPageChanged(index);
//   }
//
//   void _onPageChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int currentYear = DateTime.now().year;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: _selectedIndex == 0
//             ? null
//             : Text(
//           'KRiT $currentYear',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: true,
//         elevation: _selectedIndex == 0 ? 0 : 4,
//       ),
//       body: SafeArea(
//         child: PageView(
//           controller: controller,
//           onPageChanged: _onPageChanged,
//           children: [
//             HomeScreen(),
//             ScheduleScreen(),
//             ReportsScreen(),
//           ],
//         ),
//       ),
//       drawer: SideMenu(
//         selectedIndex: _selectedIndex,
//         onItemSelected: (int index) {
//           Navigator.pop(context);
//           _onItemTapped(index);
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Start",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: "Harmonogram",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: "Referaty",
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/admin/admin_screen.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';
import 'package:krit_app/views/screens/login/login_screen.dart';
import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
import 'package:krit_app/views/screens/reports/reports_screen.dart';
import 'package:krit_app/theme/app_theme.dart';
import 'package:krit_app/views/widgets/side_menu.dart';
import 'package:krit_app/generated/l10n.dart';

import 'package:provider/provider.dart';
import 'package:krit_app/services/auth_service.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'services/api_service.dart';
import 'models/event/events_data_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SyncfusionLicense.registerLicense('TWÓJ_KLUCZ_TUTAJ');

  // Create our data storage instances first
  final reportsStorage = ReportsDataStorage();
  final eventsStorage = EventsDataStorage(reportsStorage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider.value(value: reportsStorage),
        ChangeNotifierProvider.value(value: eventsStorage),
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
        print("🚀 First time initialization");

        Provider.of<ReportsDataStorage>(context, listen: false)
            .initializeReports()
            .then((_) {
          Provider.of<EventsDataStorage>(context, listen: false)
              .initializeEvents();
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
        child: PageView(
          controller: controller,
          onPageChanged: _onPageChanged,
          children: [
            HomeScreen(),
            ScheduleScreen(),
            ReportsScreen(),
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
        // height: 80,
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
