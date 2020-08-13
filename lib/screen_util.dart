import 'package:flutter/cupertino.dart';
import 'dart:ui';

class ScreenUtil {
  static final double SCREEN_WIDTH =
      MediaQueryData.fromWindow(window).size.width;
  static final double SCREEN_HEIGHT =
      MediaQueryData.fromWindow(window).size.height;

  static double px2dp(double pxValue) {
    return pxValue / window.devicePixelRatio;
  }
}
