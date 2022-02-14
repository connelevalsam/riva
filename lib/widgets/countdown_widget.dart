import 'package:flutter/material.dart';

import '../themes/riva_theme.dart';

Widget countDownText(BuildContext context, var counter) {
  return Text(
    "Resend SMS in:" + counter,
    style: RivaTheme.indigoText.headline4,
  );
}
