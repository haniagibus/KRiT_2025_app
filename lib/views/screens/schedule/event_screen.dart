import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/theme/app_colors.dart';
import '../../widgets/star_widget.dart'; // Widget ulubionych
import '../../widgets/report_tile.dart'; // Importujemy ReportTile

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
    final String formattedDate = DateFormat('d MMM', 'pl_PL').format(widget.event.date);
    final String timeRange = "${widget.event.timeBegin} - ${widget.event.timeEnd}";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: AppBarTheme().backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventImage(widget.event.coverImageUrl),
            const SizedBox(height: 10),
            _buildHeader(widget.event),
            const SizedBox(height: 16),
            _buildDetailsSection(formattedDate, timeRange),
            const SizedBox(height: 16),
            _buildDescription(widget.event.description),
            const SizedBox(height: 16),
            _buildReportsSection(widget.event.reports), // Użycie ReportTile
          ],
        ),
      ),
    );
  }

  /// Sekcja: Obraz wydarzenia
  Widget _buildEventImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  /// Sekcja: Nagłówek z logo i nazwą wydarzenia
  Widget _buildHeader(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(event.logoUrl),
            radius: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              event.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sekcja: Szczegóły wydarzenia (data, czas, pokój, ulubione)
  Widget _buildDetailsSection(String formattedDate, String timeRange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconDetail(Icons.calendar_today, formattedDate, AppColors.textPrimary),
              const VerticalDivider(color: AppColors.primary, thickness: 2, width: 20),
              _buildIconDetail(Icons.access_time, timeRange, AppColors.accent),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              StarWidget(
                isFavourite: isFavourite,
                onTap: toggleFavourite,
              ),
              const SizedBox(width: 8),
              Icon(Icons.room, size: 28, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.event.room,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Pomocnicza metoda: Ikona z tekstem (detale)
  Widget _buildIconDetail(IconData icon, String text, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Sekcja: Opis wydarzenia
  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  /// Sekcja: Raporty wydarzenia
  Widget _buildReportsSection(List<Report> reports) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Raporty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (reports.isEmpty)
            const Text(
              "Brak raportów dla tego wydarzenia.",
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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
                      // Można dodać dodatkową logikę na tap
                      print("Wybrano raport: ${report.title}");
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
