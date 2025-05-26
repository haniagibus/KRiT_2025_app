import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiService.dart';

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
  Future<bool> login(String username, String password) async {
    return await ApiService().login(username, password);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setUserRole();
    notifyListeners();
  }

  // Future<bool> isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.containsKey('token');
  // }
}
