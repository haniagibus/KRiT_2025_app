// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:krit_app/models/report/report.dart';
//
// import 'event/event.dart';
//
//
// class ApiService {
//   final String baseUrl = "http://10.0.2.2:8080";
//
//   Future<List<Event>> fetchEvents() async {
//     final response = await http.get(Uri.parse('$baseUrl/api/events'));
//     print("Wysłano zapytanie do: $baseUrl/api/events");
//
//     if (response.statusCode == 200) {
//       print("Otrzymana odpowiedź: ${response.body}");
//
//       List jsonResponse = json.decode(response.body);
//       List<Event> events = jsonResponse.map((event) => Event.fromJson(event)).toList();
//
//       for (var event in events) {
//         print("Event: ${event.title} - ${event.dateTimeStart}");
//       }
//
//       return events;
//     } else {
//       print("Błąd: ${response.statusCode} - ${response.reasonPhrase}");
//       throw Exception('Błąd podczas pobierania eventów');
//     }
//   }
//
//   Future<List<Report>> fetchReports() async {
//     final response = await http.get(Uri.parse('$baseUrl/api/reports'));
//     print("Wysłano zapytanie do: $baseUrl/api/reports");
//
//     if (response.statusCode == 200) {
//       print("Otrzymana odpowiedź: ${response.body}");
//
//       List jsonResponse = json.decode(response.body);
//       List<Report> reports = jsonResponse.map((report) => Report.fromJson(report)).toList();
//
//       for (var report in reports) {
//         print("Raport: ${report.title} - ${report.id}");
//       }
//
//       return reports;
//     } else {
//       print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
//       throw Exception('Błąd podczas pobierania eventów');
//     }
//   }
//
//
// }
//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/models/event/event.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final String baseUrl = "http://10.0.2.2:8080";

  // Cache flag to prevent unnecessary reinitialization
  bool _dataInitialized = false;
  bool get dataInitialized => _dataInitialized;
  set dataInitialized(bool value) => _dataInitialized = value;

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/api/events'));
    print("🔍 Wysłano zapytanie GET do: $baseUrl/api/events");

    if (response.statusCode == 200) {
      print("✅ Otrzymana odpowiedź: ${response.body.substring(0, min(100, response.body.length))}...");

      List jsonResponse = json.decode(response.body);
      List<Event> events = jsonResponse.map((event) => Event.fromJson(event)).toList();

      print("📊 Pobrano ${events.length} wydarzeń");
      return events;
    } else {
      print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania eventów');
    }
  }

  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('$baseUrl/api/reports'));
    print("🔍 Wysłano zapytanie GET do: $baseUrl/api/reports");

    if (response.statusCode == 200) {
      print("✅ Otrzymana odpowiedź: ${response.body.substring(0, min(100, response.body.length))}...");

      List jsonResponse = json.decode(response.body);
      List<Report> reports = jsonResponse.map((report) => Report.fromJson(report)).toList();

      print("📊 Pobrano ${reports.length} raportów");
      return reports;
    } else {
      print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania raportów');
    }
  }

  Future<Report> addReport(Report report) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/reports'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(report.toJson()),
    );

    print("📤 Wysłano zapytanie POST do: $baseUrl/api/reports");

    if (response.statusCode == 201) {
      print("✅ Raport dodany pomyślnie: ${response.body}");
      return Report.fromJson(json.decode(response.body));
    } else {
      print("❌ Błąd dodawania raportu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania raportu');
    }
  }

  Future<Event> addEvent(Event event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );

    print("📤 Wysłano zapytanie POST do: $baseUrl/api/events");

    if (response.statusCode == 201) {
      print("✅ Event dodany pomyślnie: ${response.body}");
      return Event.fromJson(json.decode(response.body));
    } else {
      print("❌ Błąd dodawania eventu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania eventu');
    }
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
}