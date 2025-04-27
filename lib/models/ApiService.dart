import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krit_app/models/report/report.dart';

import 'event/event.dart';


class ApiService {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/api/events'));
    print("Wysłano zapytanie do: $baseUrl/api/events");

    if (response.statusCode == 200) {
      print("Otrzymana odpowiedź: ${response.body}");

      List jsonResponse = json.decode(response.body);
      List<Event> events = jsonResponse.map((event) => Event.fromJson(event)).toList();

      for (var event in events) {
        print("Event: ${event.title} - ${event.dateTimeStart}");
      }

      return events;
    } else {
      print("Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania eventów');
    }
  }

  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('$baseUrl/api/reports'));
    print("Wysłano zapytanie do: $baseUrl/api/reports");

    if (response.statusCode == 200) {
      print("Otrzymana odpowiedź: ${response.body}");

      List jsonResponse = json.decode(response.body);
      List<Report> reports = jsonResponse.map((report) => Report.fromJson(report)).toList();

      for (var report in reports) {
        print("Raport: ${report.title} - ${report.id}");
      }

      return reports;
    } else {
      print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania eventów');
    }
  }


}

