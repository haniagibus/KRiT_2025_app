import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/models/event/event.dart';

class ReportForm extends StatefulWidget {
  final List<Event> availableEvents;
  final Function(Report) onSubmit;

  const ReportForm({
    super.key,
    required this.availableEvents,
    required this.onSubmit,
  });

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pdfUrlController = TextEditingController();
  final _keywordsController = TextEditingController();

  String? _selectedEventId;

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedEventId != null) {
      final report = Report(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        pdfUrl: _pdfUrlController.text.trim(),
        keywords: _keywordsController.text
            .split(',')
            .map((k) => k.trim())
            .where((k) => k.isNotEmpty)
            .toList(),
        eventId: _selectedEventId!,
      );

      widget.onSubmit(report);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Tytuł'),
            validator: (value) =>
            value == null || value.isEmpty ? 'Podaj tytuł' : null,
          ),
          TextFormField(
            controller: _authorController,
            decoration: const InputDecoration(labelText: 'Autor'),
            validator: (value) =>
            value == null || value.isEmpty ? 'Podaj autora' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Opis'),
            maxLines: 3,
          ),
          TextFormField(
            controller: _pdfUrlController,
            decoration: const InputDecoration(labelText: 'Link do PDF'),
          ),
          TextFormField(
            controller: _keywordsController,
            decoration: const InputDecoration(
              labelText: 'Słowa kluczowe (oddziel przecinkiem)',
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedEventId,
            hint: const Text("Wybierz wydarzenie"),
            onChanged: (newValue) {
              setState(() {
                _selectedEventId = newValue;
              });
            },
            items: widget.availableEvents
                .map((event) => DropdownMenuItem(
              value: event.id,
              child: Text(event.title),
            ))
                .toList(),
            validator: (value) =>
            value == null ? 'Wybierz wydarzenie' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Zapisz raport'),
          ),
        ],
      ),
    );
  }
}
