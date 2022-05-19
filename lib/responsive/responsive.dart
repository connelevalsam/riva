import 'package:flutter/cupertino.dart';

var smallScreen = true;
var vh = 0.0;

getSize(BuildContext context) {
  var size = MediaQuery.of(context).size;
  if (size.height < 900) {
    smallScreen = true;
    vh = .35;
  } else {
    smallScreen = false;
    vh = .25;
  }
}
