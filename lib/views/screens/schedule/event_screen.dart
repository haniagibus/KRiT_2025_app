import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../../../models/report/report.dart';
import '../../widgets/element_icon.dart';
import '../../widgets/reports/report_tile.dart';
import '../../widgets/star_widget.dart';
import '../../../services/favourite_event_service.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = FavoritesService.isFavorite(widget.event.id!);
    widget.event.isFavourite = isFavourite;
  }

  Future<void> toggleFavourite() async {
    FavoritesService.toggleFavorite(widget.event.id!);

    final updated = FavoritesService.isFavorite(widget.event.id!);

    setState(() {
      isFavourite = updated;
      widget.event.isFavourite = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme().backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, isFavourite);
          },
        ),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Logo and Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            ElementIcon(
                              backgroundColor: AppColors.plenary_session,
                              icon: Icons.event,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.event.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_primary,
                                ),
                              ),
                            ),
                            StarWidget(
                              isFavourite: isFavourite,
                              onTap: toggleFavourite,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.grey, thickness: 1),
                            const SizedBox(height: 8),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 1.6,
                              children: [
                                _buildCard(
                                    Icons.calendar_today,
                                    widget.event.formattedDate,
                                    AppColors.text_primary),
                                _buildCard(
                                    Icons.access_time,
                                    widget.event.formattedTime,
                                    AppColors.accent),
                                _buildCard(Icons.home, widget.event.building,
                                    AppColors.text_secondary),
                                _buildCard(Icons.room, widget.event.room,
                                    AppColors.text_secondary),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "Tytuł:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.subtitle,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.text_secondary,
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // const Divider(color: Colors.grey, thickness: 1),
                            // const SizedBox(height: 8),
                            // Text(
                            //   widget.event.description,
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //     color: AppColors.text_secondary,
                            //   ),
                            // ),
                            const SizedBox(height: 24),
                            _buildReportsSection(widget.event.reports),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection(List<Report> reports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Referaty:",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_primary,
          ),
        ),
        const SizedBox(height: 8),
        if (reports.isEmpty)
          const Text(
            "Brak referatów dla tego wydarzenia",
            style: TextStyle(fontSize: 16, color: AppColors.text_secondary),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ReportTile(
                report: report,
                onTap: () {
                  print("Wybrano referat: ${report.title}");
                },
              );
            },
          ),
      ],
    );
  }
}
