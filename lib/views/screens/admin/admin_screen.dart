import 'package:flutter/material.dart';
import 'package:krit_app/views/screens/home/home_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: Center(
        child: Text(
          "Witaj w panelu administratora!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

