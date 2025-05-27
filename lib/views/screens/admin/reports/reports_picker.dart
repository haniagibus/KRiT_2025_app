import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/services/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/event/events_data_storage.dart';
import '../../../../models/report/report.dart';
import '../../../../theme/app_colors.dart';
import '../../../widgets/reports/report_tile.dart';
import 'pdf_reader.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportsPicker extends StatefulWidget {
  const ReportsPicker({super.key});

  @override
  State<ReportsPicker> createState() => _ReportsPickerState();
}

class _ReportsPickerState extends State<ReportsPicker> {
  bool isLoadingPdf = false;
  List<Report> _generatedReports = [];

  Future<void> _pickMultiplePdfFiles() async {
    // if (await Permission.storage.request().isDenied) {
    //   print("Brak uprawnień do odczytu plików.");
    //   return;
    // }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    print("Wybieram pliki: $result");

    if (result == null || result.files.isEmpty) return;

    print('Wybrane pliki: ${result.files.length}');
    for (var file in result.files) {
      print('Plik: ${file.name}, path: ${file.path}');
    }

    final pdfFiles = result.files.where((file) =>
    file.extension?.toLowerCase() == 'pdf' &&
        file.path != null
    ).toList();

    setState(() {
      isLoadingPdf = true;
      _generatedReports.clear();
    });

    final pdfReader = PdfReader();
    final apiService = ApiService();

    for (var file in pdfFiles) {
      if (file.path == null) continue;
      final pdfFile = File(file.path!);
      if (!await pdfFile.exists()) continue;

      try {
        // final extractedData = await pdfReader.extractDataFromPdf(pdfFile);
        final extractedData = await apiService.sendPdfToBackend(pdfFile);
        final newReport = Report(
          id: const Uuid().v4(),
          title: extractedData?['title'] ?? 'Nieznany tytuł',
          authors: (extractedData?['authors'] ?? '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          description: extractedData?['abstract'] ?? '',
          keywords: (extractedData?['keywords'] ?? '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          pdfUrl: file.path!,
          eventId: '',
        );

        _generatedReports.add(newReport);
      } catch (e) {
        print("Błąd odczytu PDF: $e");
      }
    }

    setState(() {
      isLoadingPdf = false;
    });
  }

  void _saveAllReports() {
    final storage = Provider.of<ReportsDataStorage>(context, listen: false);

    for (final report in _generatedReports) {
      storage.addReport(report);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dodano ${_generatedReports.length} referatów!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj Referaty"),
        centerTitle: true,
      ),
      body: isLoadingPdf
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.file_upload),
                          label: Text("Wybierz pliki PDF"),
                          onPressed: _pickMultiplePdfFiles,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _generatedReports.isEmpty
                            ? Text("Brak załadowanych referatów.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _generatedReports.length,
                                itemBuilder: (context, index) {
                                  final report = _generatedReports[index];
                                  return ReportTile(
                                    report: report,
                                    onTap: () {},
                                  );
                                },
                              ),
                        if (_generatedReports.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.save, color: AppColors.primary),
                              label: Text("Zapisz wszystkie"),
                              onPressed: _saveAllReports,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.button_background,
                                foregroundColor: AppColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
