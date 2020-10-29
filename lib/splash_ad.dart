import 'package:flutter/services.dart';
import 'package:zyt_mediation/call_back.dart';

import 'constants.dart';

class SplashAd {
  static const MethodChannel _splashChannel =
      const MethodChannel(Constants.P_SPLASH);
  String _adUnitId;
  SplashCallBack splashCallBack;

  SplashAd.newInstance(String adUnitId) {
    ArgumentError.checkNotNull(adUnitId, "adUnitId is must not be null");
    this._adUnitId = adUnitId;
  }

  load() async {
    int channelId = hashCode;
    if (splashCallBack != null) {
      MethodChannel _adChannel =
          MethodChannel(Constants.P_SPLASH + channelId.toString());
      _adChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case Constants.C_SPLASH_ON_AD_LOADED:
            if (splashCallBack.onSplashLoaded != null) {
              splashCallBack.onSplashLoaded(
                  call.arguments[Constants.A_AD_UNIT_ID], this);
            }
            break;
          case Constants.C_SPLASH_ON_AD_SHOW:
            if (splashCallBack.onAdShow != null) {
              splashCallBack.onAdShow(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_SPLASH_ON_AD_CLICK:
            if (splashCallBack.onAdClick != null) {
              splashCallBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_SPLASH_ON_AD_CLOSE:
            if (splashCallBack.onClose != null) {
              splashCallBack.onClose(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
          case Constants.C_SPLASH_ON_ERROR:
            if (splashCallBack.onError != null) {
              splashCallBack.onError(call.arguments[Constants.A_AD_UNIT_ID],
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
      Constants.A_AD_UNIT_ID: _adUnitId,
      Constants.A_CHANNEL_ID: channelId,
    });
  }

  show() async {
    await _splashChannel
        .invokeMethod(Constants.M_SPLASH_SHOW_AD, <String, dynamic>{
      Constants.A_CHANNEL_ID: hashCode,
    });
  }
}
