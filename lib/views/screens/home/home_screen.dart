import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/home/favourites_tile.dart';
import '../../../services/favourite_event_service.dart';
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openLinkInNewTab(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();
    final eventsDataStorage = context.watch<EventsDataStorage>();
    final favoriteEvents = eventsDataStorage.eventList.where((event) => favoritesService.isFavorite(event.id!)).toList();
    int currentYear = DateTime.now().year;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/KRiT2025_logo-min.png',
                    height: 160,
                    width: 320,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Konferencja Radiokomunikacji i Teleinformatyki $currentYear',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text_primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      label: const Text("Przejdź do strony"),
                      onPressed: () {
                        openLinkInNewTab('https://krit.com.pl/#/');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8.0),
          // Text(
          //   'Konferencja Radiokomunikacji i Teleinformatyki $currentYear',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //     color: AppColors.text_primary,
          //   ),
          // ),
          // const SizedBox(height: 16.0),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: ElevatedButton.icon(
          //       icon: Icon(Icons.open_in_new, color: AppColors.primary),
          //       label: Text("Przejdź do strony"),
          //       onPressed: () {
          //         // openPdfInNewTab(
          //         //     '${report.pdfUrl}?t=${DateTime.now().millisecondsSinceEpoch}');
          //       },
          //       style: ElevatedButton.styleFrom(
          //         padding: const EdgeInsets.symmetric(
          //             vertical: 14, horizontal: 32),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 8.0),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FavoritesTile(
              favoriteEvents: favoriteEvents,
              // onFavouriteControl: (event) async {
              //   setState(() {
              //     eventsDataStorage.controlFavourite(event);
              //   });
              // },
            ),
          ),
        ],
      ),
    ));
  }
}
