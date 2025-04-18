import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  List<String> _selectedReports = [];

  final List<String> _reports = [
    'Referat 1: AI i przyszłość',
    'Referat 2: Flutter w praktyce',
    'Referat 3: Cyberbezpieczeństwo',
    'Referat 4: Technologie Web3',
  ];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime({required bool isStart}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelected = [..._selectedReports];

        return AlertDialog(
          title: Text("Wybierz referaty"),
          content: SingleChildScrollView(
            child: Column(
              children: _reports.map((presentation) {
                return CheckboxListTile(
                  value: tempSelected.contains(presentation),
                  title: Text(presentation),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        tempSelected.add(presentation);
                      } else {
                        tempSelected.remove(presentation);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Anuluj"),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Zatwierdź"),
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
    if (_formKey.currentState!.validate() && _selectedReports.isNotEmpty) {
      String formattedDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : 'Nie wybrano';
      String formattedTime = _selectedStartTime != null
          ? _selectedStartTime!.format(context)
          : 'Nie wybrano';

      print("Tytuł: ${_titleController.text}");
      print("Data: $formattedDate");
      print("Godzina: $formattedTime");
      print("Sala: ${_locationController.text}");
      print("Referaty: ${_selectedReports.join(", ")}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Dodaj Wydarzenie",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Tytuł',
                        floatingLabelStyle: TextStyle(
                          color: _formKey.currentState?.validate() == false ? Colors.red : AppColors.secondary,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj tytuł' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Podtytuł',
                        floatingLabelStyle: TextStyle(
                          color: _formKey.currentState?.validate() == false ? Colors.red : AppColors.secondary,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj podtytuł' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Opis',
                        floatingLabelStyle: TextStyle(
                          color: _formKey.currentState?.validate() == false ? Colors.red : AppColors.secondary,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj opis wydarzenia' : null,
                    ),
                    SizedBox(height: 16),
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
                          icon: Icon(Icons.calendar_today),
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
                                ? "Godzina: ${_selectedStartTime!.format(context)}"
                                : "Wybierz godzinę rozpoczęcia",
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () => _pickTime(isStart: true),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedStartTime != null
                                ? "Godzina: ${_selectedStartTime!.format(context)}"
                                : "Wybierz godzinę zakończenia",
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () => _pickTime(isStart: false),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Sala',
                        floatingLabelStyle: TextStyle(
                          color: _formKey.currentState?.validate() == false ? Colors.red : AppColors.secondary,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Podaj salę' : null,
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showMultiSelectDialog,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: 'Referaty',
                          ),
                          controller: TextEditingController(
                            text: _selectedReports.isEmpty
                                ? ''
                                : _selectedReports.join(', '),
                          ),
                          validator: (_) =>
                          _selectedReports.isEmpty ? 'Wybierz referaty' : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add, color: AppColors.primary),
                      label: Text("Dodaj"),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
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
