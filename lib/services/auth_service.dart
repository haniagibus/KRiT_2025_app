import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _role = 'user';

  String get role => _role;

  void setAdminRole() {
    _role = 'admin';
    notifyListeners();
  }

  void setUserRole() {
    _role = 'user';
    notifyListeners();
  }
}
