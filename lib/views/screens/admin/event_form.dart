import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String formattedDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : 'Nie wybrano';
      String formattedTime = _selectedTime != null
          ? _selectedTime!.format(context)
          : 'Nie wybrano';

      print("Tytuł: \${_titleController.text}");
      print("Autorzy: \${_authorsController.text}");
      print("Data: \$formattedDate");
      print("Godzina: \$formattedTime");
      print("Miejsce: \${_locationController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dodaj Wydarzenie")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Tytuł"),
                validator: (value) => value!.isEmpty ? 'Podaj tytuł' : null,
              ),
              TextFormField(
                controller: _authorsController,
                decoration: InputDecoration(labelText: "Autorzy"),
                validator: (value) => value!.isEmpty ? 'Podaj autorów' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? "Data: \${DateFormat('yyyy-MM-dd').format(_selectedDate!)}"
                          : "Wybierz datę",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime != null
                          ? "Godzina: \${_selectedTime!.format(context)}"
                          : "Wybierz godzinę",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ],
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Lokalizacja"),
                validator: (value) => value!.isEmpty ? 'Podaj lokalizację' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Zapisz Wydarzenie"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}