import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';
import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
import 'package:krit_app/views/screens/reports/reports_screen.dart';
import 'package:krit_app/theme/app_theme.dart'; // Import theme
import 'package:krit_app/generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRiT 2025',
      theme: AppTheme.lightTheme, // Apply the custom theme
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      home: MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final PageController controller = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    _onPageChanged(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KRiT 2025'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: _onPageChanged,
          children: [
            HomeScreen(),
            ScheduleScreen(),
            ReportsScreen()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
            label: "Raporty",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}