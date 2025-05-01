import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/home/favourites_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final eventsDataStorage = Provider.of<EventsDataStorage>(context);
    final favoriteEvents = eventsDataStorage.favoriteEvents;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/KRiT2025_logo-min.png',
                height: 180,
                width: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Konferencja Radiokomunikacji i Teleinformatyki 2025',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.text_primary,
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
                  eventsDataStorage.controlFavourite(event);
                });
              },
            ),
          ),
        ],
      ),
    ));
  }
}
