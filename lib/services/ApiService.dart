import 'dart:convert';
import 'dart:io';
import 'dart:math';
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';


class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final String baseUrl1 = "http://172.20.10.6:8080";
  final String baseUrl3 = "http://192.168.0.43:8080";
  final String baseUrl2 = "http://10.0.2.2:8080";
  final String baseUrl = "http://localhost:8080";

  // Cache flag to prevent unnecessary reinitialization
  bool _dataInitialized = false;
  bool get dataInitialized => _dataInitialized;
  set dataInitialized(bool value) => _dataInitialized = value;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Event>> fetchEvents() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/events'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print("🔍 Wysłano zapytanie GET do: $baseUrl/api/events");

    if (response.statusCode == 200) {
      print("✅ Otrzymana odpowiedź: ${response.body.substring(0, min(100, response.body.length))}...");

      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Event> events = jsonResponse.map((event) => Event.fromJson(event)).toList();

      print("📊 Pobrano ${events.length} wydarzeń");
      return events;
    } else {
      print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania eventów');
    }
  }

  Future<List<Report>> fetchReports() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse(
        '$baseUrl/api/reports'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print("🔍 Wysłano zapytanie GET do: $baseUrl/api/reports");

    if (response.statusCode == 200) {
      print("✅ Otrzymana odpowiedź: ${response.body.substring(0, min(100, response.body.length))}...");

      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Report> reports = jsonResponse.map((report) => Report.fromJson(report)).toList();

      print("📊 Pobrano ${reports.length} raportów");
      return reports;
    } else {
      print("❌ Błąd: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas pobierania raportów');
    }
  }

  Future<Report> addReport(Report report) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/reports'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(report.toJson()),
    );

    print("📤 Wysłano zapytanie POST do: $baseUrl/api/reports");
    print("AAA Wysyłany rapoortu jako JSON:");
    print(json.encode(report.toJson()));


    if (response.statusCode == 200) {
      print("✅ Raport dodany pomyślnie: ${response.body}");
      return Report.fromJson(json.decode(response.body));
    } else {
      print("❌ Błąd dodawania raportu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania raportu');
    }
  }

  Future<Event> addEvent(Event event) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/api/events');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'},
      body: json.encode(event.toJson()),
    );

    print("📤 Wysłano zapytanie POST do: $uri");
    print("AAA Wysyłany event jako JSON:");
    print(json.encode(event.toJson()));

    // 🔍 Sprawdzamy status 201 zamiast 200
    if (response.statusCode == 200) {
      print("✅ Event dodany pomyślnie: ${response.body}");

      final backendEvent = Event.fromJson(json.decode(response.body));

      event.id = backendEvent.id;

      print("🎯 Nowe ID eventu po stronie frontendu: ${event.id}");
      print("🎯 Nowe ID eventu po stronie frontendu: ${backendEvent.id}");

      return backendEvent;
    } else {
      print("❌ Błąd dodawania eventu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania eventu');
    }
  }

  Future<Event> updateEvent(Event event) async {
    final token = await _getToken();
    print("✅ ID eventu do edycji: ${event.id}");
    final response = await http.put(
      Uri.parse('$baseUrl/api/events/${event.id}'),
      headers: {'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',},
      body: json.encode(event.toJson()),
    );
    print("AAA Wysyłany event jako JSON:");
    print(json.encode(event.toJson()));
    print("✅✅✅✅✅✅✅eventid: ${event.id}");

    print("📤 Wysłano zapytanie PUT do: $baseUrl/api/events/${event.id}");

    if (response.statusCode == 200) {
      print("✅ Event edutowany pomyślnie: ${response.body}");
      return Event.fromJson(json.decode(response.body));
    } else {
      print("❌ Błąd update eventu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania eventu');
    }
  }

  Future<void> deleteEvent(Event event) async{
    final token = await _getToken();
    print("✅ ID eventu do usunięcia: ${event.id}");
    final response = await http.delete(
      Uri.parse('$baseUrl/api/events/${event.id}'),
      headers: {'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'},
      //body: json.encode(event.toJson()),
    );

    print("📤 Wysłano zapytanie DELETE do: $baseUrl/api/events/${event.id}");
    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Wydarzenie zostało usunięte.");
    } else {
      print("❌ Błąd usuwania eventu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Nie udało się usunąć wydarzenia.');
    }
  }

  Future<void> deleteReport(Report report) async{
    final token = _getToken();
    print("✅ ID raportu do usunięcia: ${report.id}");
    final response = await http.delete(
      Uri.parse('$baseUrl/api/reports/${report.id}'),
      headers: {'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'},
      //body: json.encode(event.toJson()),
    );

    print("📤 Wysłano zapytanie DELETE do: $baseUrl/api/reports/${report.id}");
    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ raport został usunięty.");
    } else {
      print("❌ Błąd usuwania raportu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Nie udało się usunąć raportu.');
    }
  }

  Future<Report> updateReport(Report report) async {
    final token = await _getToken();
    print("✅ ID referatu do edycji: ${report.id}");
    final response = await http.put(
      Uri.parse('$baseUrl/api/reports/${report.id}'),
      headers: {'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'},
      body: json.encode(report.toJson()),
    );
    print("AAA Wysyłany report jako JSON:");
    print(json.encode(report.toJson()));
    print("✅✅✅✅✅✅✅reportID: ${report.id}");

    print("📤 Wysłano zapytanie PUT do: $baseUrl/api/reports/${report.id}");

    if (response.statusCode == 200) {
      print("✅ report edutowany pomyślnie: ${response.body}");
      return Report.fromJson(json.decode(response.body));
    } else {
      print("❌ Błąd update reportu: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception('Błąd podczas dodawania reportu');
    }
  }

  Future<Map<String, String>?> sendPdfToBackend(Uint8List? pdfBytes, {String fileName = 'uploaded.pdf'}) async {
    if (pdfBytes == null) return null;

    final uri = Uri.parse('$baseUrl/api/pdf/extract');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        pdfBytes as List<int>,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        final jsonData = jsonDecode(result);

        print("✅ Tytuł: ${jsonData['title']}");
        print("🧑‍🔬 Autorzy: ${jsonData['authors']}");
        print("📝 Abstrakt: ${jsonData['abstract']}");
        print("🔑 Słowa kluczowe: ${jsonData['keywords']}");
        print("📄 PDF URL: ${jsonData['pdfUrl']}");

        return {
          'abstract': jsonData['abstract'],
          'keywords': jsonData['keywords'],
          'title': jsonData['title'],
          'authors': jsonData['authors'],
          'pdfUrl': jsonData['pdfUrl'] ?? '',
        };
      } else {
        print("❌ Błąd: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Wyjątek podczas wysyłania PDF: $e");
    }

    return null;
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } else {
      print('Błąd logowania: ${response.statusCode}');
      return false;
    }
  }

}