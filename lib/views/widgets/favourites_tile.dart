import 'package:flutter/material.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import 'package:krit_app/views/widgets/event_tile.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../../models/event/event.dart';

class FavoritesTile extends StatelessWidget {
  final List<Event> favoriteEvents;
  final Function(Event) onFavouriteControl;

  const FavoritesTile({
    super.key,
    required this.favoriteEvents,
    required this.onFavouriteControl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            'Ulubione Wydarzenia',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Wyświetl ulubione wydarzenia, jeśli istnieją
        favoriteEvents.isEmpty
            ? const Center(
          child: Text(
            "Brak ulubionych wydarzeń",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : Container(
          height: 300, // Maksymalna wysokość na 3 wydarzenia
          child: ListView.builder(
            itemCount: favoriteEvents.length,
            itemBuilder: (context, index) {
              final event = favoriteEvents[index];
              return EventTile(
                event,
                onFavouriteControl: () {
                  onFavouriteControl(event);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}