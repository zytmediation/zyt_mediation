import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mediation_flutter/screen_util.dart';

import 'call_back.dart';
import 'constants.dart';

class _BannerAd extends StatefulWidget {
  final String _adUnitId;
  final bool autoLoad;
  _BannerAdState bannerAdState;

  _BannerAd(this._adUnitId, {this.autoLoad = false}) {
    bannerAdState = _BannerAdState(_adUnitId);
  }

  @override
  State<StatefulWidget> createState() {
    return bannerAdState;
  }
//
//  load(BannerLoadCallBack callBack) async {
//    bannerAdState.load(callBack);
//  }
//
//  show() {
//    bannerAdState.show();
//  }
}

class _BannerAdState extends State<_BannerAd> {
//  static const MethodChannel _bannerChannel =
//      const MethodChannel(Constants.P_BANNER);
  bool _loadSuccess = false;
  bool _show = true;
  String _adUnitId;
  final bool autoLoad;
  double _height = 50;

  _BannerAdState(this._adUnitId, {this.autoLoad = false});

  @override
  Widget build(BuildContext context) {
    return _show ? buildPlatformWidget() : Container();
  }

  Widget buildPlatformWidget() {
    return Container(
      height: _height,
      child: Center(
        child: defaultTargetPlatform == TargetPlatform.android
            ? AndroidView(
                viewType: Constants.V_BANNER,
                creationParams: {
                  Constants.A_AD_UNIT_ID: _adUnitId,
                },
                onPlatformViewCreated: _onPlatformViewCreated,
                creationParamsCodec: StandardMessageCodec(),
              )
            : UiKitView(),
      ),
    );
  }

  _onPlatformViewCreated(int id) {
    MethodChannel _adChannel = MethodChannel(Constants.P_BANNER + "/$id");
    _adChannel.setMethodCallHandler((call) {
      print("flutter log:call ${call.method}");
      print("flutter log:call ${call.arguments[Constants.WIDTH]}");
      print("flutter log:call ${call.arguments[Constants.HEIGHT]}");
      switch (call.method) {
        case Constants.C_ON_LAYOUT_CHANGE:
          setState(() {
            _height = ScreenUtil.SCREEN_WIDTH *
                call.arguments[Constants.HEIGHT] /
                call.arguments[Constants.WIDTH];
            if (_height <= 0) {
              _height = 50;
            }
          });
          break;
      }
    });
  }
//
//  load(BannerLoadCallBack callBack) async {
//    int channelId = callBack == null ? null : callBack.hashCode;
//    if (channelId != null) {
//      MethodChannel _adChannel =
//          MethodChannel(Constants.P_BANNER + channelId.toString());
//      _adChannel.setMethodCallHandler((call) {
//        switch (call.method) {
//          case Constants.C_BANNER_ON_AD_LOADED:
//            _loadSuccess = true;
//            if (callBack.onLoaded != null) {
//              callBack.onLoaded(call.arguments[Constants.A_AD_UNIT_ID]);
//            }
//            break;
//          case Constants.C_BANNER_ON_ERROR:
//            _loadSuccess = false;
//            if (callBack.onError != null) {
//              callBack.onError(call.arguments[Constants.A_AD_UNIT_ID],
//                  call.arguments[Constants.A_ERR_MSG]);
//            }
//            _adChannel.setMethodCallHandler(null);
//            break;
//          case Constants.C_BANNER_ON_AD_CLICK:
//            if (callBack.onAdClick != null) {
//              callBack.onAdClick(call.arguments[Constants.A_AD_UNIT_ID]);
//            }
//            break;
//          case Constants.C_BANNER_ON_AD_CLOSE:
//            if (callBack.onClose != null) {
//              callBack.onClose(call.arguments[Constants.A_AD_UNIT_ID]);
//            }
//            _adChannel.setMethodCallHandler(null);
//            break;
//        }
//        return null;
//      });
//    }
//    await _bannerChannel
//        .invokeMethod(Constants.M_BANNER_LOAD_AD, <String, dynamic>{
//      Constants.A_AD_UNIT_ID: _adUnitId,
//      Constants.A_CHANNEL_ID: channelId,
//    });
//  }
//
//  show() {
//    if (_loadSuccess) {
//      _loadSuccess = false;
//      setState(() {
//        _show = true;
//      });
//    }
//  }
}
