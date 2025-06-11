import 'package:flutter/material.dart';
import 'package:krit_app/views/widgets/searchbar_widget.dart';
import '../../widgets/schedule/calendar_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<ScheduleScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarApp(
          onChanged: (String value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CalendarWidget(
              searchQuery: _searchQuery,
            ),
          ),
        ),
      ],
    );
  }
}
