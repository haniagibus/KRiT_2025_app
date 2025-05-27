import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/views/screens/schedule/event_screen.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/widgets/star_widget.dart';

import '../element_icon.dart';

class EventTile extends StatefulWidget {
  final Event event;
  final Future<void> Function(Event event) onFavouriteControl;

  const EventTile(this.event, {super.key, required this.onFavouriteControl});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.event.isFavourite;
  }

  Future<void> toggleFavourite() async {
    setState(() {
      isFavourite = !isFavourite;
      widget.event.isFavourite = isFavourite;
    });

    try {
      await widget.onFavouriteControl(widget.event);
    } catch (e) {
      print("[!] ERROR favourite control: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedFavourite = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              event: widget.event,
              onFavouriteControl: widget.onFavouriteControl,
            ),
          ),
        );
        if (updatedFavourite != null && updatedFavourite != isFavourite) {
          setState(() {
            isFavourite = updatedFavourite;
          });
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
                widget.event.formattedTime,
                style: TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.event.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          subtitle: Text(
            widget.event.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarWidget(
                isFavourite: isFavourite,
                onTap: toggleFavourite,
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
