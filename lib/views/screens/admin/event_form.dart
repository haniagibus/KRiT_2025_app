import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/event/event.dart';
import '../../../models/event/event_type.dart';
import '../../../models/event/events_data_storage.dart';
import '../../../models/report/report.dart';
import '../../../models/report/reports_data_storage.dart';
import '../../../theme/app_colors.dart';

class EventForm extends StatefulWidget {
  final Event? event; // null = tryb dodawania, nie-null = tryb edycji

  const EventForm({super.key, this.event});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  List<Report> _selectedReports = [];

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      final event = widget.event!;
      _titleController.text = event.title;
      _subtitleController.text = event.subtitle;
      _descriptionController.text = event.description;
      _locationController.text = event.room;
      _selectedDate = event.dateTimeStart;
      _selectedStartTime = TimeOfDay.fromDateTime(event.dateTimeStart);
      _selectedEndTime = TimeOfDay.fromDateTime(event.dateTimeEnd);
      _selectedReports = event.reports;
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _pickTime({required bool isStart}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStart
          ? _selectedStartTime ?? TimeOfDay.now()
          : _selectedEndTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
    }
  }


  void _showMultiSelectDialog() {
    final reportsData = Provider.of<ReportsDataStorage>(context, listen: false);
    final allReports = reportsData.reportList;
    List<Report> tempSelected = [..._selectedReports];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Wybierz referaty"),
          content: SingleChildScrollView(
            child: Column(
              children: allReports.map((report) {
                final isSelected = tempSelected.any((r) => r.id == report.id);
                return CheckboxListTile(
                  value: isSelected,
                  title: Text(report.title),
                  subtitle: Text(report.author),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        tempSelected.add(report);
                      } else {
                        tempSelected.removeWhere((r) => r.id == report.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Anuluj"),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Zatwierdź"),
              onPressed: () {
                setState(() {
                  _selectedReports = tempSelected;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedStartTime != null &&
        _selectedEndTime != null &&
        _selectedReports.isNotEmpty) {
      final date = _selectedDate!;
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );
      final endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );

      final newEvent = Event(
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: EventType.Other,
        dateTimeStart: startDateTime,
        dateTimeEnd: endDateTime,
        building: "Budynek A",
        room: _locationController.text.trim(),
        reports: _selectedReports,
        isFavourite: widget.event?.isFavourite ?? false,
      );

      final storage = Provider.of<EventsDataStorage>(context, listen: false);

      if (widget.event == null) {
        storage.addEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wydarzenie dodane pomyślnie!")),
        );
      } else {
        storage.updateEvent(widget.event!, newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wydarzenie zaktualizowane!")),
        );
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uzupełnij wszystkie pola i wybierz datę oraz godzinę")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edytuj Wydarzenie" : "Dodaj Wydarzenie"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Tytuł',
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj tytuł' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Podtytuł',
                        floatingLabelStyle: TextStyle(
                          color: _formKey.currentState?.validate() == false ? Colors.red : AppColors.secondary,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj podtytuł' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Opis',
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj opis wydarzenia' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? "Data: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}"
                                : "Wybierz datę",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedStartTime != null
                                ? "Start: ${_selectedStartTime!.format(context)}"
                                : "Wybierz godzinę rozpoczęcia",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _pickTime(isStart: true),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedEndTime != null
                                ? "Koniec: ${_selectedEndTime!.format(context)}"
                                : "Wybierz godzinę zakończenia",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _pickTime(isStart: false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Sala',
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj salę' : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showMultiSelectDialog,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            labelText: 'Referaty',
                          ),
                          controller: TextEditingController(
                            text: _selectedReports.map((r) => r.title).join(', '),
                          ),
                          validator: (_) => _selectedReports.isEmpty ? 'Wybierz referaty' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.add,
                        color: AppColors.primary,
                      ),
                      label: Text(isEditing ? "Zatwierdź zmiany" : "Dodaj"),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
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
