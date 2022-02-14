import 'package:flutter/material.dart';

Widget iconTile(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback callback,
) {
  return ListTile(
    title: Text(
      title,
      style: Theme.of(context).textTheme.headline5,
    ),
    leading: Icon(icon),
    onTap: callback,
  );
}
