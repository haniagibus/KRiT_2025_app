import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/events/event_tile_admin.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/events_data_storage.dart';

import '../../../../theme/app_colors.dart';
import '../../../widgets/searchbar_widget.dart';

class EventManagerScreen extends StatefulWidget {
  const EventManagerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataStorage = context.read<EventsDataStorage>();
      await dataStorage.refreshEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsDataStorage = context.watch<EventsDataStorage>();
    final filteredEvents = eventsDataStorage.filterEventsByQuery(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj Wydarzenia"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              SearchBarApp(
                onChanged: (String value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 1,
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.arrow_back, color: AppColors.primary),
                        Icon(Icons.delete, color: Colors.redAccent),
                        Text("Usuń"),
                        SizedBox(width: 32),
                        Icon(Icons.edit, color: AppColors.secondary),
                        Text("Edytuj"),
                        Icon(Icons.arrow_forward, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: eventsDataStorage.eventList.isEmpty
                    ? const Center(child: Text("Brak wydarzeń"))
                    : ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return EventTileAdmin(event);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
