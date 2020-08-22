import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediation_flutter_example/home_page.dart';
import 'package:zyt_mediation/banner.dart';
import 'package:zyt_mediation/native.dart';
import 'package:zyt_mediation/call_back.dart';
import 'package:zyt_mediation/reward.dart';
import 'package:zyt_mediation/zyt_mediation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      home: Scaffold(
        body: HomePage(),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}
