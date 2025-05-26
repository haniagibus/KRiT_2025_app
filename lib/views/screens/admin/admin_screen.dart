import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/admin/events/event_form.dart';
import 'package:krit_app/views/screens/admin/events/event_manager_screen.dart';
import 'package:krit_app/views/screens/admin/reports/report_form.dart';
import 'package:krit_app/views/screens/admin/reports/report_manager_screen.dart';
import 'package:krit_app/views/screens/admin/reports/reports_picker.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../services/auth_service.dart';
import 'editions/new_edition_form.dart';

class AdminScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setUserRole();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Administracyjny"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildCard(Icons.add_circle, "Stwórz Nową Edycję", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => NewEditionForm()),
            //   );
            // }),
            // SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(Icons.event, "Dodaj Wydarzenie", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventForm()),
                    );
                  }),
                  _buildCard(Icons.event, "Edytuj Wydarzenia", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventManagerScreen()),
                    );
                  }),
                  _buildCard(Icons.article, "Dodaj Referaty", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportsPicker()),
                    );
                  }),
                  _buildCard(Icons.article, "Edytuj Referaty", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportManagerScreen()),
                    );
                  }),
                  _buildCard(Icons.logout, "Wyloguj", () => _logout(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blueAccent),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
