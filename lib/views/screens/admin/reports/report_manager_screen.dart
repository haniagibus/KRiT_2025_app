import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/reports/report_tile_admin.dart';
import 'package:provider/provider.dart';
import '../../../../models/report/reports_data_storage.dart';
import '../../../widgets/searchbar_widget.dart';

class ReportManagerScreen extends StatefulWidget {
  const ReportManagerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportManagerScreenState();
}

class _ReportManagerScreenState extends State<ReportManagerScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataStorage = context.read<ReportsDataStorage>();
      await dataStorage.refreshReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportsDataStorage = context.watch<ReportsDataStorage>();

    final filteredReports = reportsDataStorage.filterReportsByQuery(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista Referatów"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBarApp(
            onChanged: (String value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          Expanded(
            child: filteredReports.isEmpty
                ? const Center(child: Text("Brak referatów"))
                : ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                return ReportTileAdmin(filteredReports[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
