import 'splash_ad.dart';

/// 初始化回调
class InitCallBack {
  OnInitSuccess onInitSuccess;
  OnInitFailure onInitFailure;

  InitCallBack({this.onInitSuccess, this.onInitFailure});
}

/// 激励视频加载回调
class RewardLoadCallBack {
  OnLoaded onLoaded;
  OnError onError;

  RewardLoadCallBack({this.onLoaded, this.onError});
}

/// 激励视频展示回调
class RewardShowCallBack {
  OnAdShow onAdShow;
  OnAdClick onAdClick;
  OnAdFinish onAdFinish;

  RewardShowCallBack({this.onAdShow, this.onAdClick, this.onAdFinish});
}

/// 插屏加载回调
class InterstitialLoadCallBack {
  OnLoaded onLoaded;
  OnError onError;
  OnAdClick onAdClick;
  OnClose onClose;

  InterstitialLoadCallBack(
      {this.onLoaded, this.onError, this.onAdClick, this.onClose});
}

/// banner加载回调
class BannerCallBack {
  OnLoaded onLoaded;
  OnError onError;
  OnClose onClose;
  OnAdClick onAdClick;

  BannerCallBack({this.onLoaded, this.onError, this.onClose, this.onAdClick});
}

/// native回调
class NativeCallBack {
  OnLoaded onLoaded;
  OnError onError;
  OnClose onClose;
  OnAdClick onAdClick;

  NativeCallBack({this.onLoaded, this.onError, this.onClose, this.onAdClick});
}

/// 开屏回调
class SplashCallBack {
  OnSplashLoaded onSplashLoaded;
  OnAdShow onAdShow;
  OnError onError;
  OnClose onClose;
  OnAdClick onAdClick;

  SplashCallBack(
      {this.onSplashLoaded,
      this.onAdShow,
      this.onError,
      this.onClose,
      this.onAdClick});
}

typedef OnSplashLoaded = void Function(String adUnitId, SplashAd splashAd);
typedef OnLoaded = void Function(String adUnitId);
typedef OnError = void Function(String adUnitId, String errMsg);

typedef OnAdShow = void Function(String adUnitId);
typedef OnAdClick = void Function(String adUnitId);
typedef OnAdFinish = void Function(String adUnitId, bool reward);
typedef OnClose = void Function(String adUnitId);

typedef OnInitSuccess = void Function();
typedef OnInitFailure = void Function();
