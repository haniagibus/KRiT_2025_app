import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/event_form.dart';
import 'package:krit_app/views/screens/admin/event_manager_screen.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../models/event/events_data_storage.dart';
import '../../../services/auth_service.dart';

class AdminScreen extends StatelessWidget {
  late final EventsDataStorage _eventsDataStorage;



  void _logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setUserRole(); // Resetujemy rolę na "user"

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Układ 2x2
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(Icons.event, "dodaj Wydarzenia", () {Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EventForm()),
            );}),
            _buildCard(Icons.event, "edytuj Wydarzenia", () {Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EventManagerScreen(eventsDataStorage: _eventsDataStorage)),
            );}),
            _buildCard(Icons.article, "dodaj Raporty", () {}),
            _buildCard(Icons.article, "edytuj Raporty", () {}),
            _buildCard(Icons.logout, "Wyloguj", () => _logout(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}