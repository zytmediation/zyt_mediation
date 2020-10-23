import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zyt_mediation/call_back.dart';
import 'package:zyt_mediation/screen_util.dart';

import 'constants.dart';

class BannerAd extends StatefulWidget {
  final String _adUnitId;
  final BannerCallBack bannerCallBack;

  BannerAd(this._adUnitId, {this.bannerCallBack});

  @override
  State<StatefulWidget> createState() {
    return _BannerAdState(_adUnitId);
  }
}

class _BannerAdState extends State<BannerAd> {
  MethodChannel _adChannel;
  String _adUnitId;
  BannerCallBack bannerCallBack;

  _BannerAdState(this._adUnitId, {this.bannerCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: ScreenUtil.SCREEN_WIDTH,
        height: 50,
        child: Center(child: buildPlatformWidget()));
  }

  Widget buildPlatformWidget() {
    return defaultTargetPlatform == TargetPlatform.android
        ? buildAndroidView(_adUnitId)
        : buildUIKitView(_adUnitId);
  }

  buildAndroidView(String adUnitId) {
    return AndroidView(
      viewType: Constants.V_BANNER,
      creationParams: {
        Constants.A_AD_UNIT_ID: _adUnitId,
      },
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  buildUIKitView(_adUnitId) {
    return UiKitView(
      viewType: Constants.V_BANNER,
      creationParams: {
        Constants.A_AD_UNIT_ID:_adUnitId,
      },
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  _onPlatformViewCreated(int id) {
    _adChannel = MethodChannel(Constants.P_BANNER + "/$id");
    _adChannel.setMethodCallHandler((call) {
      switch (call.method) {
        case Constants.C_BANNER_ON_AD_LOADED:
          if (bannerCallBack != null && bannerCallBack.onLoaded != null) {
            bannerCallBack.onLoaded(call.arguments[Constants.A_AD_UNIT_ID]);
          }
          break;
        case Constants.C_BANNER_ON_AD_CLICK:
          if (bannerCallBack != null && bannerCallBack.onAdClick != null) {
            bannerCallBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
          }
          break;
        case Constants.C_BANNER_ON_AD_CLOSE:
          if (bannerCallBack != null && bannerCallBack.onClose != null) {
            bannerCallBack.onClose(call.arguments[Constants.A_AD_UNIT_ID]);
          }
          break;
        case Constants.C_BANNER_ON_ERROR:
          if (bannerCallBack != null && bannerCallBack.onError != null) {
            bannerCallBack.onError(call.arguments[Constants.A_AD_UNIT_ID],
                call.arguments[Constants.A_ERR_MSG]);
          }
          break;
      }
      return null;
    });
  }

  @override
  void dispose() {
    if (_adChannel != null) {
      _adChannel.setMethodCallHandler(null);
      _adChannel = null;
    }
    super.dispose();
  }
}
