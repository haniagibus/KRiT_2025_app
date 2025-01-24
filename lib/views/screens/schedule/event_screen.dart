import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../../../models/report/report.dart';
import '../../widgets/element_icon.dart';
import '../../widgets/reports/report_tile.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  final VoidCallback onFavouriteControl;

  const EventScreen({
    super.key,
    required this.event,
    required this.onFavouriteControl,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.event.isFavourite;
  }

  void toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });
    widget.onFavouriteControl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme().backgroundColor,
      ),
      body: SingleChildScrollView(
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
                  IconButton(
                    icon: Icon(
                      isFavourite ? Icons.star : Icons.star_border,
                      color: isFavourite ? AppColors.accent : Colors.grey,
                    ),
                    onPressed: toggleFavourite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.room,
                        size: 28,
                        color: AppColors.text_secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.event.room,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'assets/images/floor_map.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 28,
                              color: AppColors.text_primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.formattedDate,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.primary,
                        thickness: 2,
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 28,
                              color: AppColors.accent,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.formattedTime,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.text_secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildReportsSection(widget.event.reports),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reports Section
  Widget _buildReportsSection(List<Report> reports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Raporty",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_primary,
          ),
        ),
        const SizedBox(height: 8),
        if (reports.isEmpty)
          const Text(
            "Brak raportów dla tego wydarzenia.",
            style: TextStyle(fontSize: 16, color: AppColors.text_secondary),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ReportTile(
                  report: report,
                  onTap: () {
                    // Additional logic for tapping a report
                    print("Wybrano raport: ${report.title}");
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
