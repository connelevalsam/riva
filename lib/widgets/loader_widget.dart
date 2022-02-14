import 'package:flutter/material.dart';

import '../themes/riva_theme.dart';

Loader(BuildContext context, String title) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: RivaTheme.blackText.headline3,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
