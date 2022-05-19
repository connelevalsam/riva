import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'navigation.dart';
import 'provider/provider.dart';
import 'screens/screens.dart';
import 'themes/riva_theme.dart';

void main() {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  // Workmanager().initialize(
  //
  //     // The top level function, aka callbackDispatcher
  //     callbackDispatcher,
  //
  //     // If enabled it will post a notification whenever
  //     // the task is running. Handy for debugging tasks
  //     isInDebugMode: true);
  // Workmanager().registerPeriodicTask(
  //   "2",
  //
  //   //This is the value that will be
  //   // returned in the callbackDispatcher
  //   "simplePeriodicTask",
  //
  //   // When no frequency is provided
  //   // the default 15 minutes is set.
  //   // Minimum frequency is 15 min.
  //   // Android will automatically change
  //   // your frequency to 15 min
  //   // if you have configured a lower frequency.
  //   frequency: const Duration(minutes: 3),
  // );
  callbackDispatcher();
  runApp(const MyApp());
}

var notis;

void callbackDispatcher() {
  // Workmanager().executeTask((task, inputData) {
  // initialise the plugin of flutterlocalnotifications.
  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var IOS = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  // initialise settings for both Android and iOS device.
  var settings = InitializationSettings(android: android, iOS: IOS);
  flip.initialize(settings);
  // _showNotificationWithDefaultSound(flip);
  notis = settings;
  // return Future.value(true);
  // });
}

// Future _showNotificationWithDefaultSound(flip) async {
//   // Show a notification after every 15 minute with the first
//   // appearance happening a minute after invoking the method
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//     'your channel id',
//     'your channel name',
//     channelDescription: 'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//
//   // initialise channel platform for both Android and iOS device.
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   await flip.show(
//       0,
//       'GeeksforGeeks',
//       'Your are one step away to connect with GeeksforGeeks',
//       platformChannelSpecifics,
//       payload: 'Default_Sound');
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = RivaTheme.light();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppData(),
        )
      ],
      child: MaterialApp(
        title: 'Riva',
        theme: theme,
        debugShowCheckedModeBanner: false,
        // home: Container(),
        initialRoute: intro,
        routes: {
          intro: (_) => const IntroScreen(),
          login: (_) => LoginScreen(),
          registerPhone: (_) => RegisterPhone(),
          registerOTP: (_) => RegisterOTP(),
          registerDetails: (_) => RegisterDetails(),
          registerPassword: (_) => RegisterPassword(),
          home: (context) {
            Provider.of<AppData>(context, listen: false)
                .initNotification(notis);
            return const HomeScreen();
          },
          confirmRequest: (_) => const ConfirmPickup(),
          requestPickup: (_) => const RequestPickup(),
          starTrip: (_) => const StarTrip(),
          endTrip: (_) => const EndTrip(),
          logistics: (_) => const Logistics(),
        },
      ),
    );
  }
}
