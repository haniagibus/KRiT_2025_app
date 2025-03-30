import 'package:flutter/material.dart';
import '../../../main.dart';

class AdminScreen extends StatelessWidget {
  void _goToHomePage(BuildContext context) {
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
            _buildCard(Icons.person, "Użytkownicy", () {}),
            _buildCard(Icons.event, "Wydarzenia", () {}),
            _buildCard(Icons.article, "Raporty", () {}),
            _buildCard(Icons.logout, "Wyloguj", () => _goToHomePage(context)),
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
