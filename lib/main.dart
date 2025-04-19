import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';
import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
import 'package:krit_app/views/screens/reports/reports_screen.dart';
import 'package:krit_app/theme/app_theme.dart';
import 'package:krit_app/views/widgets/side_menu.dart';
import 'package:krit_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/services/auth_service.dart';

import 'models/event/events_data_storage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ReportsDataStorage()),
        ChangeNotifierProvider<ReportsDataStorage>(
          create: (_) => ReportsDataStorage(),
        ),
        ChangeNotifierProxyProvider<ReportsDataStorage, EventsDataStorage>(
          create: (context) => EventsDataStorage(Provider.of<ReportsDataStorage>(context, listen: false)),
          update: (_, reportsStorage, previous) => EventsDataStorage(reportsStorage),
          ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRiT App',
      theme: AppTheme.lightTheme, // Apply the custom theme
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      home: const MyHomePage(),
    );
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
        title: Text(
          'KRiT $currentYear',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onItemSelected: (int index) {
          Navigator.pop(context);
          _onItemTapped(index);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
