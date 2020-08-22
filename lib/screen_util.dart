import 'package:flutter/cupertino.dart';
import 'dart:ui';

class ScreenUtil {
  static final double SCREEN_WIDTH =
      MediaQueryData.fromWindow(window).size.width;
  static final double SCREEN_HEIGHT =
      MediaQueryData.fromWindow(window).size.height;

  static px2dp(var pxValue) {
    return pxValue / window.devicePixelRatio;
  }
}
