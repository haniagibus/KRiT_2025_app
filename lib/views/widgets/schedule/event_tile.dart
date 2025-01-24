import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/views/screens/schedule/event_screen.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../element_icon.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onFavouriteControl;

  EventTile(this.event, {required this.onFavouriteControl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
            ElementIcon(
                backgroundColor: AppColors.plenary_session,
                icon: Icons.event
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    event.formattedTime,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color:  AppColors.text_primary,
                      fontFamily: 'Roboto',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.subtitle,
                    style: const TextStyle(
                      color:  AppColors.text_secondary,
                      fontFamily: 'Roboto',
                      fontSize: 14,
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
