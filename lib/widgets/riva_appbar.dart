import 'package:flutter/material.dart';

class RivaAppBar extends StatefulWidget implements PreferredSizeWidget {
  const RivaAppBar({Key? key}) : super(key: key);

  @override
  _RivaAppBarState createState() => _RivaAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.1);
}

class _RivaAppBarState extends State<RivaAppBar> {
  var name = "CB";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Image.asset("assets/images/imgAppBar.png"),
      ),
      title: Container(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Yo! $name',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              "adventure awaits today!",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const NormalAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Image.asset("assets/images/imgAppBar.png"),
      ),
      title: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class NoMemuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const NoMemuAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
