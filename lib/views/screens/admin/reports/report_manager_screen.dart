import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/reports/report_tile_admin.dart';
import 'package:provider/provider.dart';
import '../../../../models/report/reports_data_storage.dart';
import '../../../../theme/app_colors.dart';
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

    final filteredReports =
        reportsDataStorage.filterReportsByQuery(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista Referatów"),
        centerTitle: true,
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                SearchBarApp(
                  onChanged: (String value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 1,
                    color: AppColors.background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.arrow_back, color: AppColors.primary),
                          Icon(Icons.delete, color: Colors.redAccent),
                          Text("Usuń"),
                          SizedBox(width: 32),
                          Icon(Icons.edit, color: AppColors.secondary),
                          Text("Edytuj"),
                          Icon(Icons.arrow_forward, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
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
          ),
        ),
      ),
    );
  }
}
