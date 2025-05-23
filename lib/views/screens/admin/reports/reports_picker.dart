import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/event/events_data_storage.dart';
import '../../../../models/report/report.dart';
import '../../../../theme/app_colors.dart';
import '../../../widgets/reports/report_tile.dart';
import 'pdf_reader.dart';

class ReportsPicker extends StatefulWidget {
  const ReportsPicker({super.key});

  @override
  State<ReportsPicker> createState() => _ReportsPickerState();
}

class _ReportsPickerState extends State<ReportsPicker> {
  bool isLoadingPdf = false;
  List<Report> _generatedReports = [];

  Future<void> _pickMultiplePdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
      isLoadingPdf = true;
      _generatedReports.clear();
    });

    final pdfReader = PdfReader();

    for (var file in result.files) {
      if (file.path == null) continue;
      final pdfFile = File(file.path!);
      if (!await pdfFile.exists()) continue;

      try {
        final extractedData = await pdfReader.extractDataFromPdf(pdfFile);
        final newReport = Report(
          id: const Uuid().v4(),
          title: extractedData['title'] ?? 'Nieznany tytuł',
          author: extractedData['authors'] ?? 'Nieznany autor',
          description: extractedData['abstract'] ?? '',
          keywords: (extractedData['keywords'] ?? '')
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
                                  // return Card(
                                  //   margin:
                                  //       const EdgeInsets.symmetric(vertical: 8),
                                  //   child: ListTile(
                                  //     title: Text(report.title),
                                  //     subtitle: Text("Autor: ${report.author}"),
                                  //     trailing: Icon(Icons.picture_as_pdf),
                                  //   ),
                                  // );
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
