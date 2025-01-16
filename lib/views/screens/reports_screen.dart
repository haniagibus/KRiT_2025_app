import 'package:flutter/material.dart';
import '../widgets/horizontalmenu_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../widgets/event_tile.dart';
import '../widgets/title_widget.dart';
import '../widgets/calendar_widget.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          SearchBarApp(),
          // Flexible(
          //   child: CalendarWidget(),
          // ),
          // Expanded(
          //   child: Container(),
          // )
        ],
    );
  }

}
