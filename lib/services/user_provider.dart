import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String name, email;
  updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }
}
