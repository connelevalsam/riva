import 'package:flutter/material.dart';

class BtnWidget extends StatelessWidget {
  final Color? bgColor;
  final Color txtColor;
  final String title;
  final double btnSize;
  final VoidCallback callback;
  final theme;

  const BtnWidget(
      {Key? key,
      required this.bgColor,
      required this.txtColor,
      required this.title,
      required this.btnSize,
      required this.callback,
      this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: bgColor,
          onPrimary: txtColor,
          padding: const EdgeInsets.all(20),
          fixedSize:
              Size.fromWidth(MediaQuery.of(context).size.width * btnSize)),
      onPressed: callback,
      child: Text(
        title,
        style: theme,
      ),
    );
  }
}
