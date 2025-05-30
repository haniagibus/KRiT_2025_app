import 'package:flutter/material.dart';
import 'package:krit_app/models/report/reports_data_storage.dart';
import 'package:provider/provider.dart';

import '../../../../models/event/events_data_storage.dart';
import '../../../../models/report/report.dart';
import '../../../../theme/app_colors.dart';
import 'dart:html' as html;

class ReportForm extends StatefulWidget {
  final Report? report;
  final void Function(Report)? onSubmit;

  const ReportForm({super.key, this.report, this.onSubmit});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _keywordsController = TextEditingController();

  bool isSubmitted = false;
  bool isLoadingPdf = false;
  String? _selectedEventId;
  String? _selectedPdfPath;

  @override
  void initState() {
    super.initState();
    final report = widget.report;
    if (report != null) {
      _titleController.text = report.title;
      _authorsController.text = report.authors.join(', ');
      _descriptionController.text = report.description;
      _keywordsController.text = report.keywords.join(', ');
      _selectedEventId = report.eventId;
      _selectedPdfPath = report.pdfUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _descriptionController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => isSubmitted = true);

    if (_formKey.currentState!.validate() &&
        _selectedEventId != null &&
        _selectedPdfPath != null) {
      final updatedReport = Report(
        id: widget.report!.id,
        title: _titleController.text.trim(),
        authors: _authorsController.text
            .split(',')
            .map((a) => a.trim())
            .where((a) => a.isNotEmpty)
            .toList(),
        description: _descriptionController.text.trim(),
        pdfUrl: _selectedPdfPath!,
        keywords: _keywordsController.text
            .split(',')
            .map((k) => k.trim())
            .where((k) => k.isNotEmpty)
            .toList(),
        eventId: _selectedEventId!,
        pdfBytes: null,
      );

      final storage = Provider.of<ReportsDataStorage>(context, listen: false);
      storage.updateReport(widget.report!, updatedReport);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Referat zaktualizowany!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uzupełnij wszystkie wymagane pola"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void openPdfInNewTab(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final eventsDataStorage = Provider.of<EventsDataStorage>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edytuj Referat"),
        centerTitle: true,
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: isLoadingPdf
                        ? Center(child: CircularProgressIndicator())
                        : Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.open_in_new,
                                      color: Colors.white),
                                  label: Text("Wyświetl referat"),
                                  onPressed: () {
                                    openPdfInNewTab(
                                        '${widget.report?.pdfUrl}?t=${DateTime.now().millisecondsSinceEpoch}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildTextField(_titleController, "Tytuł",
                                    maxLines: 2),
                                const SizedBox(height: 16),
                                _buildTextField(_authorsController, "Autorzy"),
                                const SizedBox(height: 16),
                                _buildTextField(_descriptionController, "Opis",
                                    maxLines: 3),
                                const SizedBox(height: 16),
                                _buildTextField(_keywordsController,
                                    "Słowa kluczowe (oddziel przecinkiem)",
                                    maxLines: 2),
                                const SizedBox(height: 30),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.save,
                                      color: AppColors.primary),
                                  label: Text("Zapisz zmiany"),
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isSubmitted && _titleController.text.trim().isEmpty
              ? null
              : AppColors.primary,
        ),
        floatingLabelStyle: TextStyle(
          color: isSubmitted && _titleController.text.isEmpty
              ? null
              : AppColors.secondary,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Uzupełnij pole' : null,
    );
  }
}
