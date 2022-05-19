import 'package:flutter/material.dart';

import '../themes/riva_theme.dart';

class ProgressTabView extends StatelessWidget {
  final String title;
  final bool active;

  const ProgressTabView({Key? key, required this.title, required this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: (active ? Colors.white : Colors.grey),
      child: Text(
        title,
        style: RivaTheme.blackText.headline4,
      ),
    );
  }
}
