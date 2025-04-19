import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/views/widgets/reports/report_tile.dart';
import 'package:krit_app/views/widgets/searchbar_widget.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsScreen> {
  String _searchQuery = '';

  void _filterReportsByName(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarApp(
          onChanged: _filterReportsByName,
        ),
        Expanded(
          child: Consumer<ReportsDataStorage>(
            builder: (context, reportsData, _) {
              final reports = reportsData.reportList.where((report) {
                return report.title.toLowerCase().contains(_searchQuery) ||
                    report.author.toLowerCase().contains(_searchQuery) ||
                    report.keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
              }).toList();

              if (reports.isEmpty) {
                return const Center(child: Text("Brak wyników."));
              }

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ReportTile(
                    report: report,
                    onTap: () {
                      // tu możesz dodać logikę wyświetlania szczegółów itd.
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
