import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/views/screens/admin/events/event_form.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../models/event/events_data_storage.dart';
import '../../../widgets/element_icon.dart';

class EventTileAdmin extends StatelessWidget {
  final Event event;

  const EventTileAdmin(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<EventsDataStorage>(context, listen: false);
    return Dismissible(
      key: ValueKey(event.id ?? 'temp-${DateTime.now().millisecondsSinceEpoch}'),
      background: Container(
        color: AppColors.secondary,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Edycja
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventForm(event: event),
            ),
          );
          return false;
        } else if (direction == DismissDirection.endToStart) {
          // Usuwanie
          final confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Potwierdź usunięcie"),
              content: Text("Czy na pewno chcesz usunąć to wydarzenie?"),
              actions: [
                TextButton(
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: Text("Anuluj"),
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
                ElevatedButton(
                  child: Text("Usuń"),
                  onPressed: () {
                    storage.removeEvent(event);
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
          if (confirm == true) {
            // eventsData.deleteEvent(event.id);
            return true;
          }
        }
        return false;
      },
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
        subtitle: Text(event.subtitle),
        trailing: Icon(Icons.drag_handle),
      ),
    );
  }
}
