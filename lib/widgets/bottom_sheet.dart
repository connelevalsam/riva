import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Widget child;

  const BottomNav({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(onClosing: () {}, builder: (context) => child);
  }
}
