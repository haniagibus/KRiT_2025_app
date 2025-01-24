import 'package:flutter/material.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import '../../widgets/home/favourites_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final EventsDataStorage _eventsDataStorage;

  @override
  void initState() {
    super.initState();
    _eventsDataStorage = EventsDataStorage(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoriteEvents = _eventsDataStorage.favoriteEvents;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/images/map.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: FavoritesTile(
                favoriteEvents: favoriteEvents,
                onFavouriteControl: (event) {
                  setState(() {
                    _eventsDataStorage.controlFavourite(event);
                  });
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}


