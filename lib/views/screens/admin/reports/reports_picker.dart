//import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:krit_app/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/report/report.dart';
import '../../../../theme/app_colors.dart';
import '../../../widgets/reports/report_tile.dart';
import 'pdf_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';


class ReportsPicker extends StatefulWidget {
  const ReportsPicker({super.key});

  @override
  State<ReportsPicker> createState() => _ReportsPickerState();
}

class _ReportsPickerState extends State<ReportsPicker> {
  bool isLoadingPdf = false;
  List<Report> _generatedReports = [];
  List<String> fileNames = [];

  Future<List<int>?> extractFirstPage(Uint8List originalBytes) async {
    try {
      final PdfDocument originalDocument = PdfDocument(inputBytes: originalBytes);
      final PdfDocument newDoc = PdfDocument();
      newDoc.pages.removeAt(0);

      newDoc.pages.add().graphics.drawPdfTemplate(
        originalDocument.pages[0].createTemplate(),
        const Offset(0, 0),
      );

      final List<int> newBytes = newDoc.saveSync();
      originalDocument.dispose();
      newDoc.dispose();

      return newBytes;
    } catch (e) {
      print("Błąd przy wycinaniu pierwszej strony: $e");
      return null;
    }
  }

  Future<void> _pickMultiplePdfFiles() async {

    final apiService = ApiService();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final pdfFiles = result.files
        .where((file) =>
            file.extension?.toLowerCase() == 'pdf' && file.path != null)
        .toList();

    setState(() {
      isLoadingPdf = true;
    });

    for (var file in pdfFiles) {
      if (file.path == null || file.bytes == null) continue;
      if (fileNames.contains(file.name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Ten plik PDF już został dodany"),
              backgroundColor: Colors.red),
        );
        continue;
      }

      final firstPageBytes = await extractFirstPage(file.bytes!);
      if (firstPageBytes == null) continue;

      final extractedData = await apiService.sendPdfToBackend(file.bytes);
      try {
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
            pdfUrl: extractedData?['pdfUrl'] ?? '',
            eventId: '',
            pdfBytes: file.bytes);

        _generatedReports.add(newReport);
        fileNames.add(file.name);
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

    String tmp = "referatów";
    if (_generatedReports.length == 1) tmp = "referat";
    else if (_generatedReports.length > 1 && _generatedReports.length < 5) tmp = "referaty";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Dodano ${_generatedReports.length} $tmp!"),
          backgroundColor: Colors.green),
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
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: Align(
                    alignment: Alignment.topCenter,
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
                                icon: Icon(Icons.file_upload, color: AppColors.primary,),
                                label: Text("Wybierz pliki PDF"),
                                onPressed: _pickMultiplePdfFiles,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
                                  padding: const EdgeInsets.only(top: 16),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.save,
                                        color: AppColors.primary),
                                    label: Text("Zapisz wszystkie"),
                                    onPressed: _saveAllReports,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.button_background,
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
