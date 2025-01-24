import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/views/widgets/report_tile.dart';
import '../../widgets/searchbar_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsScreen> {
  late final ReportsDataStorage _reportsDataStorage;
  String _searchQuery = '';
  List<Report> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _reportsDataStorage = ReportsDataStorage(_refresh);
    _filteredReports = _reportsDataStorage.reportList;
  }

  void _refresh() {
    setState(() {
      _filteredReports = _reportsDataStorage.filterReports(_searchQuery);
    });
  }

  void _filterReportsByName(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredReports = _reportsDataStorage.reportList.where((report) {
        return report.title.toLowerCase().contains(_searchQuery) || report.author.toLowerCase().contains(_searchQuery)
        || report.keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pasek wyszukiwania
        SearchBarApp(
          onChanged: (String value) {
            _filterReportsByName(value); // Wywołanie nowej metody filtrowania
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredReports.length,
            itemBuilder: (context, index) {
              final report = _filteredReports[index];
              return ReportTile(
                report: report,
                onTap: () {
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
