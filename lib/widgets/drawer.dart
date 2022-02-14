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
                  currentUser.profile[0]["name"] ?? 'John Doe',
                  style: RivaTheme.whiteText.headline3,
                ),
              ],
            ),
          ),
        ),
        iconTile(
          context,
          "Home",
          Icons.home,
          () => Navigator.pushNamed(context, home),
        ),
      ],
    ),
  );
}
