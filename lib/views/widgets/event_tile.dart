import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';
import 'package:krit_app/views/screens/event_screen.dart';
import 'package:krit_app/theme/app_colors.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onFavouriteControl;

  EventTile(this.event, {required this.onFavouriteControl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the EventScreen when the tile is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(event: event),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(
                    event.logoUrl,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "${event.timeBegin} - ${event.timeEnd}",
                    style: const TextStyle(
                      color: Color.fromRGBO(29, 27, 32, 1),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    event.date.toLocal().toString().split(' ')[0],
                    style: const TextStyle(
                      color: Color.fromRGBO(29, 27, 32, 1),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromRGBO(73, 69, 79, 1),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      letterSpacing: 0.25,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      event.isFavourite ? Icons.star : Icons.star_border,
                      color: event.isFavourite
                          ? AppColors.accent
                          : Colors.grey,
                    ),
                    onPressed: onFavouriteControl,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
