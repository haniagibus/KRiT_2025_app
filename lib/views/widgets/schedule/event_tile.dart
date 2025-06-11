// import 'package:flutter/material.dart';
// import 'package:krit_app/models/event/event.dart';
// import 'package:krit_app/views/screens/schedule/event_screen.dart';
// import 'package:krit_app/theme/app_colors.dart';
// import 'package:krit_app/views/widgets/star_widget.dart';
// import 'package:krit_app/views/widgets/element_icon.dart';
// import 'package:krit_app/services/favourite_event_service.dart';
//
// class EventTile extends StatefulWidget {
//   final Event event;
//
//   const EventTile(this.event, {super.key});
//
//   @override
//   State<EventTile> createState() => _EventTileState();
// }
//
// class _EventTileState extends State<EventTile> {
//   late bool isFavourite;
//
//   @override
//   void initState() {
//     super.initState();
//     isFavourite = FavoritesService.isFavorite(widget.event.id!);
//     widget.event.isFavourite = isFavourite;
//   }
//
//   void toggleFavourite() {
//     FavoritesService.toggleFavorite(widget.event.id!);
//     final updated = FavoritesService.isFavorite(widget.event.id!);
//
//     setState(() {
//       isFavourite = updated;
//       widget.event.isFavourite = updated;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final updatedFavourite = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => EventScreen(
//               event: widget.event,
//             ),
//           ),
//         );
//
//         if (updatedFavourite != null && updatedFavourite != isFavourite) {
//           setState(() {
//             isFavourite = updatedFavourite;
//             widget.event.isFavourite = updatedFavourite;
//           });
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 2),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//         ),
//         child: ListTile(
//           leading: ElementIcon(
//             backgroundColor: AppColors.plenary_session,
//             icon: Icons.event,
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.event.formattedTime,
//                 style: const TextStyle(
//                     color: AppColors.accent, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.event.title,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           subtitle: Text(
//             widget.event.subtitle,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               StarWidget(
//                 isFavourite: isFavourite,
//                 onTap: toggleFavourite,
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.grey[700],
//                 size: 24,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/views/screens/schedule/event_screen.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/widgets/star_widget.dart';
import 'package:krit_app/views/widgets/element_icon.dart';
import 'package:krit_app/services/favourite_event_service.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final isFavourite = favoritesService.isFavorite(event.id!);

    void toggleFavourite() {
      favoritesService.toggleFavorite(event.id!);
    }

    return GestureDetector(
      onTap: () async {
        final updatedFavourite = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              event: event,
            ),
          ),
        );

        if (updatedFavourite != null && updatedFavourite != isFavourite) {
          toggleFavourite();
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
                style: const TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              Text(
                event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
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

