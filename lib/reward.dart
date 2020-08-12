import 'package:flutter/services.dart';

import 'call_back.dart';
import 'constants.dart';

class Reward {
  static const MethodChannel _rewardChannel =
      const MethodChannel(Constants.P_REWARD);

  static load(String adUnitId, RewardLoadCallBack callBack) async {
    int channelId = callBack == null ? null : callBack.hashCode;
    if (channelId != null) {
      MethodChannel _adChannel =
          MethodChannel(Constants.P_REWARD + channelId.toString());
      _adChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case Constants.C_REWARD_ON_LOADED:
            if (callBack.onLoaded != null) {
              callBack.onLoaded(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
          case Constants.C_REWARD_ON_ERROR:
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
    await _rewardChannel
        .invokeMethod(Constants.M_REWARD_LOAD_AD, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
      Constants.A_CHANNEL_ID: channelId,
    });
  }

  static show(String adUnitId, RewardShowCallBack callBack) async {
    int channelId = callBack == null ? null : callBack.hashCode;
    if (channelId != null) {
      MethodChannel _adChannel =
          MethodChannel(Constants.P_REWARD + channelId.toString());
      _adChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case Constants.C_REWARD_ON_AD_SHOW:
            if (callBack.onAdShow != null) {
              callBack.onAdShow(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_REWARD_ON_AD_CLICK:
            if (callBack.onAdClick != null) {
              callBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
            }
            break;
          case Constants.C_REWARD_ON_AD_FINISH:
            if (callBack.onAdFinish != null) {
              callBack.onAdFinish(call.arguments[Constants.A_AD_UNIT_ID],
                  call.arguments[Constants.A_REWARD]);
            }
            _adChannel.setMethodCallHandler(null);
            break;
        }
        return null;
      });
    }
    await _rewardChannel
        .invokeMethod(Constants.M_REWARD_SHOW, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
      Constants.A_CHANNEL_ID: channelId,
    });
  }

  static Future<bool> isReady(String adUnitId) {
    final Future<bool> result = _rewardChannel
        .invokeMethod(Constants.M_REWARD_IS_READY, <String, dynamic>{
      Constants.A_AD_UNIT_ID: adUnitId,
    });
    return result;
  }
}
