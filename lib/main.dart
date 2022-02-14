import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation.dart';
import 'provider/provider.dart';
import 'screens/screens.dart';
import 'themes/riva_theme.dart';

void main() {
  runApp(const MyApp());
}

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
        // home: Container(),
        initialRoute: intro,
        routes: {
          intro: (_) => const IntroScreen(),
          login: (_) => LoginScreen(),
          registerPhone: (_) => RegisterPhone(),
          registerOTP: (_) => RegisterOTP(),
          registerDetails: (_) => RegisterDetails(),
          registerPassword: (_) => RegisterPassword(),
          home: (_) => const HomeScreen(),
          confirmRequest: (_) => const ConfirmPickup(),
          requestPickup: (_) => const RequestPickup(),
          starTrip: (_) => const StarTrip(),
          endTrip: (_) => const EndTrip(),
        },
      ),
    );
  }
}
