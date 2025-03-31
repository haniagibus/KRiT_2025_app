import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';
import 'package:krit_app/views/screens/schedule/schedule_screen.dart';
import 'package:krit_app/views/screens/reports/reports_screen.dart';
import 'package:krit_app/theme/app_theme.dart';
import 'package:krit_app/views/widgets/side_menu.dart';
import 'package:krit_app/generated/l10n.dart';
//import 'package:krit_app/api_service.dart';  // Dodaj ApiService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRiT 2025',
      theme: AppTheme.lightTheme,
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
      home: const MyHomePage(title: 'KRiT 2025'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KRiT 2025',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: _onPageChanged,
          children: [
            HomeScreen(),
            ScheduleScreen(),  // <-- Harmonogram będzie pobierał eventy
            ReportsScreen()
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
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// void main() async {
//   const String baseUrl = "http://10.0.2.2:8080/api/events";
//
//   try {
//     final response = await http.get(Uri.parse(baseUrl));
//
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       print("✅ Sukces! Otrzymane eventy:");
//       print(jsonResponse);
//     } else {
//       print("❌ Błąd: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("⚠️ Wystąpił błąd: $e");
//   }
// }
