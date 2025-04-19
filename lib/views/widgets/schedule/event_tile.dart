import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/views/screens/schedule/event_screen.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/widgets/star_widget.dart';

import '../element_icon.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onFavouriteControl;

  EventTile(this.event, {required this.onFavouriteControl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedFavourite = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              event: event,
              onFavouriteControl: onFavouriteControl,
            ),
          ),
        );
        if (updatedFavourite != null) {
          onFavouriteControl();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListTile(
          leading: ElementIcon(
            backgroundColor: AppColors.plenary_session,
            icon: Icons.event,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.formattedTime,
                style: TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              Text(
                event.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          subtitle: Text(
            event.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarWidget(
                isFavourite: event.isFavourite,
                onTap: onFavouriteControl,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[700],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
