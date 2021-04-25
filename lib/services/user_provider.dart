import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String name, email, uid;
  updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  updateUid(String newUid) {
    uid = newUid;
    notifyListeners();
  }
}
