import 'package:flutter/material.dart';

import '../themes/riva_theme.dart';

Widget errorMsg(String txt) {
  return Text(
    txt,
    style: RivaTheme.redText.headline4,
  );
}
