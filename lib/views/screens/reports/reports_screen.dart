// import 'package:flutter/material.dart';
// import 'package:krit_app/models/report/report.dart';
// import 'package:krit_app/models/report/reports_data_storage.dart';
// import 'package:krit_app/views/widgets/reports/report_tile.dart';
// import '../../widgets/searchbar_widget.dart';
//
// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _ReportsViewState();
// }
//
// class _ReportsViewState extends State<ReportsScreen> {
//   late final ReportsDataStorage _reportsDataStorage;
//   String _searchQuery = '';
//   List<Report> _filteredReports = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _reportsDataStorage = ReportsDataStorage(_refresh);
//     _filteredReports = _reportsDataStorage.reportList;
//     _loadReports();
//   }
//
//   Future<void> _loadReports() async {
//     await _reportsDataStorage.initializeReports();
//   }
//
//   void _refresh() {
//     setState(() {
//       _filteredReports = _reportsDataStorage.filterReports(_searchQuery);
//     });
//   }
//
//   void _filterReportsByName(String query) {
//     setState(() {
//       _searchQuery = query.toLowerCase();
//       _filteredReports = _reportsDataStorage.reportList.where((report) {
//         return report.title.toLowerCase().contains(_searchQuery) || report.author.toLowerCase().contains(_searchQuery)
//         || report.keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SearchBarApp(
//           onChanged: (String value) {
//             _filterReportsByName(value); // Wywołanie nowej metody filtrowania
//           },
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _filteredReports.length,
//             itemBuilder: (context, index) {
//               final report = _filteredReports[index];
//               return ReportTile(
//                 report: report,
//                 onTap: () {
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataStorage = context.read<ReportsDataStorage>();
      await dataStorage.refreshReports();
    });
  }

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
              final reports = reportsData.filterReportsByQuery(_searchQuery);

              if (reports.isEmpty) {
                return const Center(child: Text("Brak wyników"));
              }

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ReportTile(
                    report: report,
                    onTap: () {},
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