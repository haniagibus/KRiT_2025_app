import 'package:flutter/material.dart';
import 'package:krit_app/models/events_data_storage.dart';
import '../widgets/favourites_tile.dart';
import '../widgets/searchbar_widget.dart';

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

  // Funkcja odświeżająca widok
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Pobieramy listę ulubionych wydarzeń
    final favoriteEvents = _eventsDataStorage.favoriteEvents;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Dodanie paddingu do całej zawartości
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),  // Padding tylko dla SearchBarApp
              child: SearchBarApp(),
            ),
            // Tutaj przenosimy całą logikę wyświetlania ulubionych wydarzeń do widgetu FavoritesTile
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
      ),
    );
  }
}
