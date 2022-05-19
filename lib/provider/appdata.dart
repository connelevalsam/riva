import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppData extends ChangeNotifier {
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  double _destinationLatitude = 0.0;
  double _destinationLongitude = 0.0;
  String _currentAddress = "";
  String _currentAddressID = "";
  String _destinationAddress = "";
  String _destinationAddressID = "";
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get currentLatitude => _currentLatitude;
  get currentLongitude => _currentLongitude;

  get destinationLatitude => _destinationLatitude;
  get destinationLongitude => _destinationLongitude;

  get currentAddress => _currentAddress;
  get destinationAddress => _destinationAddress;

  get flutterLocalNotificationsPlugin => _flutterLocalNotificationsPlugin;

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

  void initNotification(var initializationSettings) {
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    notifyListeners();
  }

  Future showNotifications(
    String channelID,
    String channelName,
    String notificationFor,
    String popUpTitle,
    String popUpMessage,
  ) async {
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelID,
      channelName,
      channelDescription: notificationFor,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      popUpTitle,
      popUpMessage,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void cleanup() {
    _destinationLongitude = 0.0;
    _destinationLatitude = 0.0;
    _destinationAddressID = "";
    _destinationAddress = "";

    notifyListeners();
  }
}
