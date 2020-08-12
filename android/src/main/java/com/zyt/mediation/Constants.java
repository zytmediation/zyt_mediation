package com.zyt.mediation;

/**
 * @author ling.zhang
 * date 2020/8/6 3:00 PM
 * description:
 */
public interface Constants {
    // P_代表plugin；M_代表method；A_代表argument；C_代表call back方法
    // mediation_flutter插件
    String P_MEDIATION_FLUTTER = "mediation_flutter";
    String M_MEDIATION_FLUTTER_INITIALIZE = "initialize";
    String A_INITIALIZE_APP_ID = "appId";
    String A_INITIALIZE_PUB_KEY = "pubKey";
    String A_INITIALIZE_APP_FLY_ID = "appFlyId";
    String A_INITIALIZE_BUGLY_ID = "buglyId";
    String C_INITIALIZE_SUCCESS = "initSuccess";
    String C_INITIALIZE_FAILURE = "initFailure";

    // 激励视频插件名和方法名
    String P_REWARD = P_MEDIATION_FLUTTER + "/reward";
    String M_REWARD_LOAD_AD = "loadAd";
    String M_REWARD_IS_READY = "isReady";
    String M_REWARD_SHOW = "show";

    // 激励视频加载回调
    String C_REWARD_ON_LOADED = "onLoaded";
    String C_REWARD_ON_ERROR = "onError";

    // 激励视频展示回调
    String C_REWARD_ON_AD_SHOW = "onAdShow";
    String C_REWARD_ON_AD_CLICK = "onAdClick";
    String C_REWARD_ON_AD_FINISH = "onAdFinish";


    // 插屏插件名和方法名
    String P_INTERSTITIAL = P_MEDIATION_FLUTTER + "/interstitial";
    String M_INTERSTITIAL_LOAD_AD = "loadAd";
    String M_INTERSTITIAL_SHOW = "show";
    String M_INTERSTITIAL_IS_READY = "isReady";

    // 插屏加载回调
    String C_INTERSTITIAL_ON_AD_LOADED = "onAdLoaded";
    String C_INTERSTITIAL_ON_AD_CLICK = "onAdClick";
    String C_INTERSTITIAL_ON_AD_CLOSE = "onAdClose";
    String C_INTERSTITIAL_ON_ERROR = "onError";

    // banner插件名和方法名
    String P_BANNER = P_MEDIATION_FLUTTER + "/banner";
    String M_BANNER_LOAD_AD = "loadAd";

    // banner加载回调
    String C_BANNER_ON_AD_LOADED = "onAdLoaded";
    String C_BANNER_ON_AD_CLICK = "onAdClick";
    String C_BANNER_ON_AD_CLOSE = "onAdClose";
    String C_BANNER_ON_ERROR = "onError";

    String C_ON_LAYOUT_CHANGE = "onLayoutChange";

    String V_BANNER = "bannerView";
    String V_NATIVE = "nativeView";
    String V_SPLASH = "splashView";
    // 共用
    String A_AD_UNIT_ID = "adUnitId";
    String A_CHANNEL_ID = "channelId";
    String A_ERR_MSG = "errMsg";
    String A_REWARD = "reward";
    String WIDTH = "width";
    String HEIGHT = "height";
}
