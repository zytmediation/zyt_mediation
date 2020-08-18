# zyt_mediatyion flutter 插件

## 接入指南

1. 添加依赖

```yaml
dependencies:
  zyt_mediation: "^1.0.0"
```

2. 初始化

3. 激励视频

   - 加载

   ```dart
   String adUnitId="此处填写您的adUnitId";
   Reward.load(
       adUnitId,
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
   String adUnitId="此处填写您的adUnitId";
     Reward.show(
        adUnitId,
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

## 测试 key（仅用于测试使用）

- Android
  - appId: 1000
  - pubKey: ""
  - 激励视频 adUnitId: 20000128
- IOS 暂无

**PS：以上 appId 和 adUnitId 需要自行判断不同平台，例如：（flutter zyt_mediation-1.0.0 只支持 android 平台，ios 平台 adUnitId 可暂时不填）**

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
