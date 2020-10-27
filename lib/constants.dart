class Constants {
  // P_代表plugin；M_代表method；A_代表argument；C_代表call back方法;V_代表view
  // mediation_flutter插件
  static const String P_MEDIATION_FLUTTER = "mediation_flutter";
  static const String M_MEDIATION_FLUTTER_INITIALIZE = "initialize";
  static const String A_INITIALIZE_APP_ID = "appId";
  static const String A_INITIALIZE_PUB_KEY = "pubKey";
  static const String A_INITIALIZE_APP_FLY_ID = "appFlyId";
  static const String A_INITIALIZE_BUGLY_ID = "buglyId";
  static const String C_INITIALIZE_SUCCESS = "initSuccess";
  static const String C_INITIALIZE_FAILURE = "initFailure";

  // 激励视频插件名和方法名
  static const String P_REWARD = P_MEDIATION_FLUTTER + "/reward";
  static const String M_REWARD_LOAD_AD = "loadAd";
  static const String M_REWARD_IS_READY = "isReady";
  static const String M_REWARD_SHOW = "show";

  // 激励视频加载回调
  static const String C_REWARD_ON_LOADED = "onLoaded";
  static const String C_REWARD_ON_ERROR = "onError";

  // 激励视频展示回调
  static const String C_REWARD_ON_AD_SHOW = "onAdShow";
  static const String C_REWARD_ON_AD_CLICK = "onAdClick";
  static const String C_REWARD_ON_AD_FINISH = "onAdFinish";

  // 插屏插件名和方法名
  static const String P_INTERSTITIAL = P_MEDIATION_FLUTTER + "/interstitial";
  static const String M_INTERSTITIAL_LOAD_AD = "loadAd";
  static const String M_INTERSTITIAL_SHOW = "show";
  static const String M_INTERSTITIAL_IS_READY = "isReady";

  // 插屏加载回调
  static const String C_INTERSTITIAL_ON_AD_LOADED = "onAdLoaded";
  static const String C_INTERSTITIAL_ON_AD_CLICK = "onAdClick";
  static const String C_INTERSTITIAL_ON_AD_CLOSE = "onAdClose";
  static const String C_INTERSTITIAL_ON_ERROR = "onError";

  // banner插件名和方法名
  static const String P_BANNER = P_MEDIATION_FLUTTER + "/banner";
  static const String M_BANNER_LOAD_AD = "loadAd";

  // banner加载回调
  static const String C_BANNER_ON_AD_LOADED = "onAdLoaded";
  static const String C_BANNER_ON_AD_CLICK = "onAdClick";
  static const String C_BANNER_ON_AD_CLOSE = "onAdClose";
  static const String C_BANNER_ON_ERROR = "onError";

  // native插件名和方法名
  static const String P_NATIVE = P_MEDIATION_FLUTTER + "/native";
  static const String M_NATIVE_LOAD_AD = "loadAd";

  // NATIVE加载回调
  static const String C_NATIVE_ON_AD_LOADED = "onAdLoaded";
  static const String C_NATIVE_ON_AD_CLICK = "onAdClick";
  static const String C_NATIVE_ON_AD_CLOSE = "onAdClose";
  static const String C_NATIVE_ON_ERROR = "onError";

  static const String V_BANNER = "bannerView";
  static const String V_NATIVE = "nativeView";
  static const String V_SPLASH = "splashView";

  static const String P_SPLASH = P_MEDIATION_FLUTTER + "/splash";
  static const String M_SPLASH_LOAD_AD = "loadAd";

  // 开屏回调
  static const String C_SPLASH_ON_ERROR = "onError";
  static const String C_SPLASH_ON_AD_SHOW = "onAdShow";
  static const String C_SPLASH_ON_AD_CLICK = "onAdClick";
  static const String C_SPLASH_ON_AD_CLOSE = "onAdClose";

  // 共用
  static const String A_AD_UNIT_ID = "adUnitId";
  static const String A_CHANNEL_ID = "channelId";
  static const String A_ERR_MSG = "errMsg";
  static const String A_REWARD = "reward";
  static const String WIDTH = "width";
  static const String HEIGHT = "height";
  static const String C_ON_LAYOUT_CHANGE = "onLayoutChange";
}
