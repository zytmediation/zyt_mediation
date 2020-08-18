import 'package:flutter/services.dart';

import 'call_back.dart';
import 'constants.dart';

class ZYTMediationSdk {
  static const MethodChannel _channel =
      const MethodChannel(Constants.P_MEDIATION_FLUTTER);

  ZYTMediationSdk.initialize(String appId, String pubKey,
      {InitCallBack initCallBack}) {
    _channel.setMethodCallHandler((call) => event(call, initCallBack));
    _channel.invokeMethod(Constants.M_MEDIATION_FLUTTER_INITIALIZE,
        <String, dynamic>{"appId": appId, "pubKey": pubKey});
  }

  Future<dynamic> event(MethodCall call, InitCallBack initCallBack) {
    if (initCallBack != null) {
      switch (call.method) {
        case Constants.C_INITIALIZE_SUCCESS:
          if (initCallBack.onInitSuccess != null) {
            print("flutter log:init success");
            initCallBack.onInitSuccess();
          }
          break;
        case Constants.C_INITIALIZE_FAILURE:
          if (initCallBack.onInitFailure != null) {
            print("flutter log:init failure");
            initCallBack.onInitFailure();
          }
          break;
      }
    }
  }
}
