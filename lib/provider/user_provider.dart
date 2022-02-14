import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _phone;
  String? _uid;
  String? _password;
  List _profile = [];

  get phone => _phone;
  get uid => _uid;
  get dp => _password;
  get profile => _profile;

  void setUser(String phone, String uid, String password, List profile) {
    _phone = phone;
    _uid = uid;
    _password = password;
    _profile = profile;

    notifyListeners();
  }

  void clearUser() async {
    _phone = null;
    _uid = null;
    _password = null;
    _profile = [];
  }
}
