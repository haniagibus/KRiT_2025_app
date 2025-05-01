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

//BACKEND
//   List<Report> _filteredReports = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _reportsDataStorage = ReportsDataStorage(_refresh);
//     _loadReports();
//   }

//   Future<void> _loadReports() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await _reportsDataStorage.initializeReports();

//     setState(() {
//       _filteredReports = _reportsDataStorage.reportList;
//       _isLoading = false;
//     });
//   }

//   Future<void> _refreshReports() async {
//     setState(() {
//       _isLoading = true;
//     });

//     // Use the new refreshReports method from ReportsDataStorage
//     await _reportsDataStorage.refreshReports();

//     _refresh();
//     setState(() {
//       _isLoading = false;
//     });

//     return Future.value();
//   }

//   void _refresh() {
//     setState(() {
//       if (_searchQuery.isEmpty) {
//         _filteredReports = _reportsDataStorage.reportList;
//       } else {
//         _filteredReports = _reportsDataStorage.filterReports(_searchQuery);
//       }
//     });
//   }

  void _filterReportsByName(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
//BACKEND
//       _filteredReports = _reportsDataStorage.reportList.where((report) {
//         return report.title.toLowerCase().contains(_searchQuery) ||
//             report.author.toLowerCase().contains(_searchQuery) ||
//             report.keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
//       }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarApp(
//BACKEND
//           onChanged: (String value) {
//             _filterReportsByName(value);
//           },
//         ),
//         Expanded(
//           child: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: _refreshReports,
//             child: _filteredReports.isEmpty
//                 ? ListView(
//               children: const [
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 50.0),
//                     child: Text(
//                       "Brak raportów do wyświetlenia",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//                 : ListView.builder(
//               itemCount: _filteredReports.length,
//               itemBuilder: (context, index) {
//                 final report = _filteredReports[index];
//                 return ReportTile(
//                   report: report,
//                   onTap: () {
//                     // Handle report tap
//                   },
//                 );
//               },
//             ),
          onChanged: _filterReportsByName,
        ),
        Expanded(
          child: Consumer<ReportsDataStorage>(
            builder: (context, reportsData, _) {
              final reports = reportsData.filterReportsByQuery(_searchQuery);

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