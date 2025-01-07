import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krit_app/views/widgets/searchbar_widget.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/schedule_screen.dart';
import 'views/screens/reports_screen.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRiT 2025',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.grey,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/schedule': (context) => ScheduleScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
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
  // VersionInfo vi = VersionInfo();

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

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var locale = AppLocalizations.of(context)!;
    // vi.getVersionInfo().then((value) => {
    //   if (!vi.isSupported())
    //     {
    //       showDialog(
    //           barrierDismissible: false,
    //           context: context,
    //           builder: (BuildContext context) {
    //             return WillPopScope(
    //               child: AlertDialog(
    //                 title: Text(locale.unsupportedVersionTitle),
    //                 content: Text(locale.unsupportedVersionMessage
    //                     .replaceAllMapped(
    //                     RegExp(r'\%\d'),
    //                         (match) => [
    //                       vi.currentVersion,
    //                       vi.minimumVersion
    //                     ][int.parse(match.input.substring(
    //                         match.start + 1, match.end))])),
    //                 actions: [
    //                   TextButton(
    //                       onPressed: () {
    //                         //Open link to app store when we will have it
    //                       },
    //                       child: Text("OK"))
    //                 ],
    //                 icon: Icon(Icons.app_blocking),
    //               ),
    //               onWillPop: () async => false,
    //             );
    //           })
    //     }
    // });
    return Scaffold(
        appBar: AppBar(
          title: const Text('KRiT 2025'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () {
            },
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
                ])),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Start", //locale.start
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Harmonogram", //locale.schedule
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: "Raporty", //locale.reports
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped));
  }
}