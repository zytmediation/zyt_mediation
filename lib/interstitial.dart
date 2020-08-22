import 'package:flutter/services.dart';

import 'call_back.dart';
import 'constants.dart';

class Interstitial {
  static const MethodChannel _interstitialChannel =
      const MethodChannel(Constants.P_INTERSTITIAL);

  static load(String adUnitId, InterstitialLoadCallBack callBack) async {
    int channelId = callBack == null ? null : callBack.hashCode;
    if (channelId != null) {
      MethodChannel _adChannel =
          MethodChannel(Constants.P_INTERSTITIAL + channelId.toString());
      _adChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case Constants.C_INTERSTITIAL_ON_AD_LOADED:
            if (callBack.onLoaded != null) {
              callBack.onLoaded(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_INTERSTITIAL_ON_ERROR:
            if (callBack.onError != null) {
              callBack.onError(call.arguments[Constants.A_AD_UNIT_ID],
                  call.arguments[Constants.A_ERR_MSG]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
          case Constants.C_INTERSTITIAL_ON_AD_CLICK:
            if (callBack.onAdClick != null) {
              callBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_INTERSTITIAL_ON_AD_CLOSE:
            if (callBack.onClose != null) {
              callBack.onClose(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
        }
        return null;
      });
    }
    await _interstitialChannel
        .invokeMethod(Constants.M_INTERSTITIAL_LOAD_AD, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
      Constants.A_CHANNEL_ID: channelId,
    });
  }

  static show(String adUnitId) async {
    await _interstitialChannel
        .invokeMethod(Constants.M_INTERSTITIAL_SHOW, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
    });
  }

  static Future<bool> isReady(String adUnitId) {
    final Future<bool> result = _interstitialChannel
        .invokeMethod(Constants.M_INTERSTITIAL_IS_READY, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
    });
    return result;
  }
}
