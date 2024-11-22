import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _email = '';
  String get email => _email;
  String _name = '';
  String get name => _name;
  String _telephone = '';
  String get telephone => _telephone;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setTelephone(String telephone) {
    _telephone = telephone;
    notifyListeners();
  }
}
