import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  final VoidCallback callback;
  const PhoneNumber({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/icon_call.png"),
        radius: 20,
      ),
    );
  }
}
