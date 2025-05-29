import 'package:flutter/material.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/admin/reports/report_form.dart';
import 'package:provider/provider.dart';
import '../../../../models/report/report.dart';
import '../../../../models/report/reports_data_storage.dart';
import '../../../../models/event/events_data_storage.dart';
import '../../../widgets/element_icon.dart';

class ReportTileAdmin extends StatelessWidget {
  final Report report;

  const ReportTileAdmin(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    final reportsDataStorage =
        Provider.of<ReportsDataStorage>(context, listen: false);
    final eventsDataStorage =
        Provider.of<EventsDataStorage>(context, listen: false);
    return Dismissible(
      key: Key(report.id),
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
              builder: (_) => ReportForm(report: report),
            ),
          );
          return false;
        } else if (direction == DismissDirection.endToStart) {
          // Usuwanie
          final confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Potwierdź usunięcie"),
              content: Text("Czy na pewno chcesz usunąć to referat?"),
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
                    //eventsDataStorage.removeReportFromEvent(report);
                    reportsDataStorage.removeReport(report);
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
          backgroundColor: AppColors.report,
          icon: Icons.article,
        ),
        title: Text(
          report.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          report.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.drag_handle),
      ),
    );
  }
}
