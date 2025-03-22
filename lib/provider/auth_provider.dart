import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void login(String email, String password) {
    if (email == 'admin@gmail.com' && password == 'admin') {
      _isAuthenticated = true;
      notifyListeners();
    }
  }
}