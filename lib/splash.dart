import 'package:flutter/services.dart';

import 'call_back.dart';
import 'constants.dart';

class Splash {
  static const MethodChannel _splashChannel =
      const MethodChannel(Constants.P_SPLASH);

  static load(String adUnitId, SplashCallBack callBack) async {
    int channelId = callBack == null ? null : callBack.hashCode;
    if (channelId != null) {
      MethodChannel _adChannel =
          MethodChannel(Constants.P_SPLASH + channelId.toString());
      _adChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case Constants.C_SPLASH_ON_AD_SHOW:
            if (callBack.onAdShow != null) {
              callBack.onAdShow(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_SPLASH_ON_AD_CLICK:
            if (callBack.onAdClick != null) {
              callBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_SPLASH_ON_AD_CLOSE:
            if (callBack.onClose != null) {
              callBack.onClose(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
          case Constants.C_SPLASH_ON_ERROR:
            if (callBack.onError != null) {
              callBack.onError(call.arguments[Constants.A_AD_UNIT_ID],
                  call.arguments[Constants.A_ERR_MSG]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
        }
        return null;
      });
    }
    await _splashChannel
        .invokeMethod(Constants.M_SPLASH_LOAD_AD, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
      Constants.A_CHANNEL_ID: channelId,
    });
  }
}
