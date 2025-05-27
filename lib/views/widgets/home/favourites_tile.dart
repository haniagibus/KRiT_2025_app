import 'package:flutter/material.dart';
import 'package:krit_app/views/widgets/schedule/event_tile.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../../../models/event/event.dart';

class FavoritesTile extends StatelessWidget {
  final List<Event> favoriteEvents;
  final Future<void> Function(Event) onFavouriteControl;

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
              color: AppColors.text_primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: favoriteEvents.isEmpty
              ? const Center(
            child: Text(
              "Brak ulubionych wydarzeń",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: favoriteEvents.length,
            itemBuilder: (context, index) {
              final event = favoriteEvents[index];
              return EventTile(
                event,
                onFavouriteControl: (updatedEvent) async {
                  await onFavouriteControl(updatedEvent);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
