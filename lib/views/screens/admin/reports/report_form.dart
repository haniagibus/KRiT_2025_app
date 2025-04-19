import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/event/events_data_storage.dart';
import '../../../../models/report/report.dart';
import '../../../../theme/app_colors.dart';

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
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _keywordsController = TextEditingController();

  bool isSubmitted = false;
  String? _selectedEventId;
  String? _selectedPdfPath;

  @override
  void initState() {
    super.initState();
    final report = widget.report;
    if (report != null) {
      _titleController.text = report.title;
      _authorController.text = report.author;
      _descriptionController.text = report.description;
      _keywordsController.text = report.keywords.join(', ');
      _selectedEventId = report.eventId;
      _selectedPdfPath = report.pdfUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => isSubmitted = true);

    if (_formKey.currentState!.validate() &&
        _selectedEventId != null &&
        _selectedPdfPath != null) {
      final report = Report(
        id: widget.report?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        pdfUrl: _selectedPdfPath!,
        keywords: _keywordsController.text
            .split(',')
            .map((k) => k.trim())
            .where((k) => k.isNotEmpty)
            .toList(),
        eventId: _selectedEventId!,
      );

      if (widget.onSubmit != null) {
        widget.onSubmit!(report);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Referat zapisany pomyślnie!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uzupełnij wszystkie wymagane pola")),
      );
    }
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedPdfPath = result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.report != null;
    final eventsDataStorage = Provider.of<EventsDataStorage>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edytuj Referat" : "Dodaj Referat"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // PDF Picker
                    GestureDetector(
                      onTap: _pickPdfFile,
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: _selectedPdfPath != null
                                ? _selectedPdfPath!.split('/').last
                                : "Wybierz plik PDF",
                            labelStyle: TextStyle(
                              color: isSubmitted &&
                                      _titleController.text.trim().isEmpty
                                  ? null
                                  : AppColors.primary,
                            ),
                            suffixIcon: const Icon(Icons.file_upload),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (_) => _selectedPdfPath == null
                              ? 'Wybierz plik PDF'
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedEventId,
                      hint: Text(
                        "Wybierz wydarzenie",
                        style: TextStyle(
                          color: isSubmitted &&
                                  _titleController.text.trim().isEmpty
                              ? Color(0xFFB00020)
                              : AppColors.primary,
                        ),
                      ),
                      onChanged: (newValue) => setState(() {
                        _selectedEventId = newValue;
                      }),
                      items: eventsDataStorage.eventList
                          .map((event) => DropdownMenuItem(
                                value: event.id,
                                child: Text(event.title),
                              ))
                          .toList(),
                      validator: (value) =>
                          value == null ? 'Wybierz wydarzenie' : null,
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    const SizedBox(height: 8.0),
                    _buildTextField(_titleController, "Tytuł"),
                    const SizedBox(height: 16),
                    _buildTextField(_authorController, "Autor"),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, "Opis",
                        maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField(_keywordsController,
                        "Słowa kluczowe (oddziel przecinkiem)"),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.add,
                        color: AppColors.primary,
                      ),
                      label: Text(isEditing ? "Zapisz zmiany" : "Dodaj"),
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
