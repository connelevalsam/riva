import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation.dart';
import '../provider/user_provider.dart';
import '../themes/riva_theme.dart';
import '../widgets/widgets.dart';

Widget drawer(BuildContext context) {
  var currentUser = Provider.of<UserProvider>(context, listen: false);
  return Drawer(
    child: ListView(
      children: [
        SizedBox(
          height: 200.0,
          child: DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage(currentUser.profile[0]["image_url"]),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Hello",
                  style: RivaTheme.whiteText.headline3,
                ),
                Text(
                  currentUser.profile[0]["name"] ?? 'John Doe',
                  style: RivaTheme.whiteText.headline5,
                ),
              ],
            ),
          ),
        ),
        // iconTile(
        //   context,
        //   "Home",
        //   Icons.home,
        //   () => Navigator.pushNamed(context, home),
        // ),
        iconTile(
          context,
          "Ride History",
          Icons.location_history,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "Payments",
          Icons.payments,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "Refer & Earn",
          Icons.money,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "Notifications",
          Icons.notification_important,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "About Us",
          Icons.person_pin_sharp,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "Privacy Policy",
          Icons.privacy_tip,
          () => Navigator.pushNamed(context, home),
        ),
        iconTile(
          context,
          "Support",
          Icons.support,
          () => Navigator.pushNamed(context, home),
        ),
        SizedBox(
          height: 20,
        ),
        iconTile(
          context,
          "Logout",
          Icons.exit_to_app,
          () => Navigator.pushReplacementNamed(context, login),
        ),
      ],
    ),
  );
}
