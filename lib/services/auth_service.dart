import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _role = 'user'; // Domyślna rola to "user"

  String get role => _role;

  // Zmieniamy rolę użytkownika na 'admin'
  void setAdminRole() {
    _role = 'admin';
    notifyListeners(); // Powiadamiamy o zmianie stanu
  }

  // Zmieniamy rolę użytkownika na 'user'
  void setUserRole() {
    _role = 'user';
    notifyListeners(); // Powiadamiamy o zmianie stanu
  }
}
