import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  double _destinationLatitude = 0.0;
  double _destinationLongitude = 0.0;
  String _currentAddress = "";
  String _currentAddressID = "";
  String _destinationAddress = "";
  String _destinationAddressID = "";

  get currentLatitude => _currentLatitude;
  get currentLongitude => _currentLongitude;

  get destinationLatitude => _destinationLatitude;
  get destinationLongitude => _destinationLongitude;

  get currentAddress => _currentAddress;
  get destinationAddress => _destinationAddress;

  void setCurrentLocation(double? lat, double? long) {
    _currentLatitude = lat!;
    _currentLongitude = long!;

    print("current Location - $_currentLatitude - $_currentLongitude");
    notifyListeners();
  }

  void setDestinationLocation(double? lat, double? long) {
    _destinationLatitude = lat!;
    _destinationLongitude = long!;

    print(
        "destination Location - $_destinationLatitude - $_destinationLongitude");
    notifyListeners();
  }

  void setAddress(String name, String id, int type) {
    if (type == 0) {
      _currentAddress = name;
      _currentAddressID = id;
    } else {
      _destinationAddress = name;
      _destinationAddressID = id;
    }

    notifyListeners();
  }

  void cleanup() {
    _destinationLongitude = 0.0;
    _destinationLatitude = 0.0;
    _destinationAddressID = "";
    _destinationAddress = "";

    notifyListeners();
  }
}
