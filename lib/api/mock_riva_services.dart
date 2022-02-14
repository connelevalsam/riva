import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/model.dart';

class MockRivaServices {
  Future<List<User>> getUserData() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 1000));
    // Load json from file system
    final dataString = await _loadAsset('assets/sample_data/users_data.json');
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each recipe and convert json to User object.
    if (json['users'] != null) {
      final user = <User>[];
      json['users'].forEach((v) {
        user.add(User.fromJson(v));
      });
      return user;
    } else {
      return [];
    }
  }

  Future<List<Driver>> getDriverData() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 1000));
    // Load json from file system
    final dataString = await _loadAsset('assets/sample_data/drivers_data.json');
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each recipe and convert json to Driver object.
    if (json['users'] != null) {
      final driver = <Driver>[];
      json['users'].forEach((v) {
        driver.add(Driver.fromJson(v));
      });
      return driver;
    } else {
      return [];
    }
  }

  // Loads sample json data from file system
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}
