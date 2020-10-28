# zyt_mediatyion flutter 插件

## 接入指南

1. 添加依赖

   ```yaml
   dependencies:
     zyt_mediation:
       git:
         url: https://github.com/zytmediation/zyt_mediation_flutter.git
         ref: v1.1.0
   ```

2. 初始化

   ```dart
   ZYTMediationSdk.initialize(appId, pubKey,
       initCallBack: InitCallBack(onInitSuccess: () {
         print("init success");
       }, onInitFailure: () {
         print("init failure");
       }));
   ```

   ps：尽早调用初始化方法，建议在 MyApp 的 build()方法中初始化。

3. 激励视频

   - 加载

     ```dart
     Reward.load(
         "此处填写您的adUnitId",
         RewardLoadCallBack(
         onLoaded: (adUnitId) {
             print("load reward success $adUnitId");
         },
         onError: (adUnitId, errMsg) {
             print("load reward error $adUnitId,$errMsg");
         }));
     ```

   - 展示

     ```dart
     Reward.show(
       "此处填写您的adUnitId",
       RewardShowCallBack(
         onAdClick: (adUnitId) {
           print("reward click $adUnitId");
         },
         onAdFinish: (adUnitId, reward) {
           // 根据reward判断视频是否观看完成
           print("reward finish $adUnitId,reward:$reward");
         },
         onAdShow: (adUnitId) {
           print("reward show $adUnitId");
         },
       ));
     ```

4. 插屏广告

   - 加载

     ```dart
     Interstitial.load(
             "此处填写您的adUnitId",
             InterstitialLoadCallBack(onLoaded: (adUnitId) {
               print("interstitial load success $adUnitId");
             }, onError: (adUnitId, errMsg) {
               print("interstitial error $adUnitId,$errMsg");
             }, onAdClick: (adUnitId) {
               print("interstitial click $adUnitId");
             }, onClose: (adUnitId) {
               print("interstitial close $adUnitId");
             }));
     ```

   - 展示

     ```dart
     Interstitial.show("此处填写您的adUnitId");
     ```

5. 原生广告

   ```dart
   /// 直接构建NativeAd widget放入布局中即可
   NativeAd(
         "此处填写您的adUnitId",
         width: 此处填写您预留的广告宽度,
         height: 此处填写您预留的广告高度,
         nativeCallBack: NativeCallBack(
             onLoaded: (_) => print("load success"),
             onAdClick: (_) => print("native click"),
             onClose: (_) => print("native close"),
             onError: (_, errMsg) => print("native error:$errMsg")
         )
       )
   ```

6. 横幅广告

   ```dart
   /// 直接构建BannerAd widget放入布局中即可
   BannerAd(
     "此处填写您的adUnitId",
     bannerCallBack: BannerCallBack(
       onLoaded: (_) => print("banner load success"),
       onClose: (_) => print("banner close"),
       onError: (_, errMsg) => print("banner error:$errMsg"),
       onAdClick: (_) => print("banner click")
     )
   )
   ```

7. 开屏广告

   ```dart
    Splash.load(
       "此处填写您的adUnitId",
       SplashCallBack(onAdShow: (adUnitId) {
         addLog("splash show success $adUnitId");
       }, onError: (adUnitId, errMsg) {
         addLog("splash error $adUnitId,$errMsg");
       }, onAdClick: (adUnitId) {
         addLog("splash click $adUnitId");
       }, onClose: (adUnitId) {
         addLog("splash close $adUnitId");
       }));
   ```

## 测试 key（仅用于测试使用）

- Android
  - appId: 1000
  - pubKey: 5f02f0acf05577031536bbda323f7faa
  - 激励视频 adUnitId: 20000128
  - 插屏广告 adUnitId: 20000127
  - 原生广告 adUnitId: 20000130
  - 横幅广告 adUnitId: 20000129
  - 开屏广告 adUnitId: 20000196
- IOS 暂无

**PS：以上 appId 和 adUnitId 需要自行判断不同平台，例如：（flutter zyt_mediation-1.1.0 只支持 android 平台，ios 平台 adUnitId 可暂时不填）**

```dart
String getRewardAdUnitId() {
  if (Platform.isIOS) {
    return '填写您的ios adUnitId';
  } else if (Platform.isAndroid) {
    return '填写您的android adUnitId';
  }
  return null;
}
```
