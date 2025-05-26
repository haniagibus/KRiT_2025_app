import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../models/event/event.dart';
import '../../../../models/event/event_type.dart';
import '../../../../models/event/events_data_storage.dart';
import '../../../../models/report/report.dart';
import '../../../../models/report/reports_data_storage.dart';
import '../../../../theme/app_colors.dart';
import '../../../widgets/searchbar_widget.dart';

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
  final _buildingController = TextEditingController();
  final _roomController = TextEditingController();

  bool isSubmitted = false;

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  List<Report> _selectedReports = [];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      final event = widget.event!;
      _titleController.text = event.title;
      _subtitleController.text = event.subtitle;
      //_descriptionController.text = event.description;
      _buildingController.text = event.building;
      _roomController.text = event.room;
      _selectedDate = event.dateTimeStart;
      _selectedStartTime = TimeOfDay.fromDateTime(event.dateTimeStart);
      _selectedEndTime = TimeOfDay.fromDateTime(event.dateTimeEnd);
      _selectedReports = event.reports;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _buildingController.dispose();
    _roomController.dispose();
    super.dispose();
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

    showDialog(
      context: context,
      builder: (context) {
        List<Report> tempSelected = [..._selectedReports];

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final filteredReports = reportsData.filterReportsByQuery(_searchQuery);
            return AlertDialog(
              title: const Text("Wybierz referaty"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBarApp(
                    onChanged: (String value) {
                      setStateDialog(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: filteredReports.map((report) {
                          final isSelected =
                              tempSelected.any((r) => r.id == report.id);

                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(
                              report.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              report.authors.join(', '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onChanged: (checked) {
                              setStateDialog(() {
                                if (checked == true) {
                                  tempSelected.add(report);
                                } else {
                                  tempSelected
                                      .removeWhere((r) => r.id == report.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: const Text("Anuluj"),
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
      },
    );
  }

  void _submitForm() {
    setState(() {
      isSubmitted = true;
    });

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
        //description: _descriptionController.text.trim(),
        type: EventType.Other,
        dateTimeStart: startDateTime,
        dateTimeEnd: endDateTime,
        building: _buildingController.text.trim(),
        room: _roomController.text.trim(),
        reports: _selectedReports,
        isFavourite: widget.event?.isFavourite ?? false,
      );

      final storage = Provider.of<EventsDataStorage>(context, listen: false);

      if (widget.event == null) {
        storage.addEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wydarzenie dodane pomyślnie!")),
        );
        // } else {
        //   storage.updateEvent(widget.event!, newEvent);
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Wydarzenie zaktualizowane!")),
        //   );
        // }
      } else {
        // Aktualizacja istniejącego wydarzenia
        final updatedEvent = Event(
          id: widget.event!.id,  // Zachowanie oryginalnego ID
          title: _titleController.text.trim(),
          subtitle: _subtitleController.text.trim(),
          //description: _descriptionController.text.trim(),
          type: EventType.Other,
          dateTimeStart: startDateTime,
          dateTimeEnd: endDateTime,
          building: _buildingController.text.trim(),
          room: _roomController.text.trim(),
          reports: _selectedReports,
          isFavourite: widget.event!.isFavourite,
        );

        storage.updateEvent(widget.event!, updatedEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wydarzenie zaktualizowane!")),
        );
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uzupełnij wszystkie wymagane pola")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edytuj Wydarzenie" : "Dodaj Wydarzenie"),
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
                    _buildTextField(_titleController, "Tytuł"),
                    const SizedBox(height: 16),
                    _buildTextField(_subtitleController, "Podtytuł"),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, "Opis", maxLines: 3),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? "Data: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}"
                                : "Wybierz datę",
                            style: TextStyle(
                              color: isSubmitted && _selectedDate == null
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight: isSubmitted && _selectedDate == null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedStartTime != null
                                ? "Godzina rozpoczęcia: ${_selectedStartTime!.format(context)}"
                                : "Wybierz godzinę rozpoczęcia",
                            style: TextStyle(
                              color: isSubmitted && _selectedStartTime == null
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight:
                                  isSubmitted && _selectedStartTime == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
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
                                ? "Godzina zakończenia: ${_selectedEndTime!.format(context)}"
                                : "Wybierz godzinę zakończenia",
                            style: TextStyle(
                              color: isSubmitted && _selectedEndTime == null
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              fontWeight:
                                  isSubmitted && _selectedEndTime == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _pickTime(isStart: false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_buildingController, "Budynek"),
                    const SizedBox(height: 16),
                    _buildTextField(_roomController, "Sala"),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showMultiSelectDialog,
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text:
                                _selectedReports.map((r) => r.title).join(', '),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Referaty',
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                            labelStyle: TextStyle(
                              color: isSubmitted && _selectedReports.isEmpty
                                  ? Theme.of(context).colorScheme.error
                                  : AppColors.primary,
                            ),
                          ),
                          validator: (_) => _selectedReports.isEmpty
                              ? 'Wybierz referaty'
                              : null,
                        ),
                      ),
                    ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Uzupełnij pole' : null,
    );
  }
}
