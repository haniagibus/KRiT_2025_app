import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/event_tile_admin.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/events_data_storage.dart';

import '../../widgets/searchbar_widget.dart';

class EventManagerScreen extends StatefulWidget {
  const EventManagerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final eventsDataStorage = Provider.of<EventsDataStorage>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista Wydarzeń"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBarApp(
            onChanged: (String value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          Expanded(
            child: eventsDataStorage.eventList.isEmpty
                ? const Center(child: Text("Brak wydarzeń"))
                : ListView.builder(
              itemCount: eventsDataStorage.eventList.length,
              itemBuilder: (context, index) {
                final event = eventsDataStorage.eventList[index];

                // // Jeśli chcesz filtrować po tytule:
                // if (_searchQuery.isNotEmpty &&
                //     !event.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
                //   return const SizedBox.shrink(); // pomiń niewpasowane
                // }

                return EventTileAdmin(event);
              },
            ),
          ),
        ],
      ),


      // body: eventsDataStorage.eventList.isEmpty
      //     ? const Center(child: Text("Brak wydarzeń"))
      //     : ListView.builder(
      //         itemCount: eventsDataStorage.eventList.length,
      //         itemBuilder: (context, index) {
      //           return EventTileAdmin(eventsDataStorage.eventList[index]);
      //         },
      //       ),
    );
  }
}
