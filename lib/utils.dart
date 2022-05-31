import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

mixin Utils {
  static Color primaryColor1 = Vx.white;
  static Color primaryColor2 = Vx.lightBlue700;
  static double circularProgressStrokeWidth = 15.0;
  static Color circularProgressInternalColor = Vx.white;
  static double circularProgressSizeOfScreen = 0.4;
  static Color circularProgressBackgroundColor = Vx.gray300;
  static double circularProgressLabelSizeOfSizedBox = 0.3;
  static double totalBarBorderWidth = 1.0;
  static Color totalBarBorderColor = Vx.black;
  static Color totalBarCircleColor = Vx.white;

  static String SecToTime(double timeInSec) {
    double sec = 0.0;
    double min = 0.0;
    double h = 0.0;
    String result = '';

    if (timeInSec <= 59) {
      sec = timeInSec;
    } else {
      sec = timeInSec % 60;
      min = (timeInSec / 60).truncate().toDouble();
      if (min >= 60) h = (min / 60).truncate().toDouble();
    }

    result =
        '${h == 0 ? "" : "${h.toInt()}h"}${min == 0 ? "" : "${min.toInt()}m"}${sec.toInt()}s';

    return result;
  }
}
