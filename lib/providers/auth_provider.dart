
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  void login(String email, String password) {
    // Simulación de login
    _isLoggedIn = true;
    _userId = 'user_123';
    _userName = 'Cliente Su Óptica';
    notifyListeners();
  }

  void register(String email, String password, String name) {
    // Simulación de registro
    _isLoggedIn = true;
    _userId = 'user_new_123';
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}
