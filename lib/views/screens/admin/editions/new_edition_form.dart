import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';

class NewEditionForm extends StatefulWidget {
  @override
  _NewEditionFormState createState() => _NewEditionFormState();
}

class _NewEditionFormState extends State<NewEditionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isSubmitted = false;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<String> _selectedReports = [];
  String? _selectedLogoPath;

  void _pickDate({required bool isStart}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  void _submitForm() {
    setState(() {
      isSubmitted = true;
    });

    if (_formKey.currentState!.validate() && _selectedReports.isNotEmpty) {
      String formattedStartDate = _selectedStartDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedStartDate!)
          : 'Nie wybrano';
      String formattedEndDate = _selectedEndDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedEndDate!)
          : 'Nie wybrano';

      print("Tytuł: ${_titleController.text}");
      print("Data rozpoczęcia: $formattedStartDate");
      print("Data zakończenia: $formattedEndDate");
    }
  }

  Future<void> _pickLogoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedLogoPath = result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stwórz Nową Edycję"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Tytuł',
                        labelStyle: TextStyle(
                          color: isSubmitted &&
                                  _titleController.text.trim().isEmpty
                              ? null
                              : AppColors.primary,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: isSubmitted && _titleController.text.isEmpty
                              ? null
                              : AppColors.secondary,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Podaj tytuł' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Opis',
                        labelStyle: TextStyle(
                          color: isSubmitted &&
                                  _titleController.text.trim().isEmpty
                              ? null
                              : AppColors.primary,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: isSubmitted && _titleController.text.isEmpty
                              ? null
                              : AppColors.secondary,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Podaj opis' : null,
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickLogoFile,
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: _selectedLogoPath != null
                                ? _selectedLogoPath!.split('/').last
                                : "Wybierz logo (PNG, JPG)",
                            labelStyle: TextStyle(
                              color: isSubmitted && _selectedLogoPath == null
                                  ? Theme.of(context).colorScheme.error
                                  : AppColors.primary,
                            ),
                            suffixIcon: const Icon(Icons.image),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (_) => _selectedLogoPath == null
                              ? 'Wybierz plik logo'
                              : null,
                        ),
                      ),
                    ),
                    if (_selectedLogoPath != null &&
                        File(_selectedLogoPath!).existsSync())
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Image.file(
                          File(_selectedLogoPath!),
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Nie udało się załadować obrazu'),
                        ),
                      ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedStartDate != null
                                ? "Data: ${DateFormat('dd.MM.yyyy').format(_selectedStartDate!)}"
                                : "Wybierz datę rozpoczęcia",
                            style: TextStyle(
                              color: isSubmitted && _selectedStartDate == null
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight:
                                  isSubmitted && _selectedStartDate == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(isStart: true),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedEndDate != null
                                ? "Data: ${DateFormat('dd.MM.yyyy').format(_selectedEndDate!)}"
                                : "Wybierz datę zakończenia",
                            style: TextStyle(
                              color: isSubmitted && _selectedEndDate == null
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight:
                                  isSubmitted && _selectedEndDate == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(isStart: false),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, color: AppColors.primary),
                      label: Text("Dodaj"),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 32),
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
}
