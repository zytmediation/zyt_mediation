import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediation_flutter/call_back.dart';
import 'package:mediation_flutter/reward.dart';
import 'package:mediation_flutter/zyt_mediation_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  TextEditingController initEditController = TextEditingController();
  TextEditingController rewardEditController = TextEditingController();
  TextEditingController interstitialEditController = TextEditingController();
  TextEditingController nativeEditController = TextEditingController();
  TextEditingController bannerEditController = TextEditingController();
  TextEditingController splashEditController = TextEditingController();
  List<Widget> list = List();
  ScrollController _controller = ScrollController();

  @override
  void dispose() {
    print("life cycle:dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("life cycle:didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MyApp oldWidget) {
    print("life cycle:didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("life cycle:deactivate");
    super.deactivate();
  }

  @override
  void initState() {
    print("life cycle:initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("life cycle:build");
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var mainContainer = Container(
        child: Column(
      children: [
        buildInitWidget(),
        buildRewardWidget(),
        buildInterstitialWidget(),
        buildNativeWidget(),
        buildBannerWidget(),
        buildSplashWidget(),
        buildClearLogBtn(),
//        buildBannerView(),
        buildLogListWidget(),
      ],
    ));
    jumpBottom();
    return MaterialApp(
      home: Scaffold(
        body: mainContainer,
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  Widget buildInitWidget() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Expanded(flex: 1, child: buildTextField(initEditController)),
      Expanded(
        flex: 1,
        child: RaisedButton(
          onPressed: initSdk,
          child: Text("init sdk"),
        ),
      ),
    ]);
  }

  Widget buildRewardWidget() {
    return Column(
      children: [
        buildTextField(rewardEditController),
        Row(
          children: [
            RaisedButton(
              onPressed: loadReward,
              child: Text("load reward"),
            ),
            RaisedButton(
              onPressed: isReadyReward,
              child: Text("isReady"),
            ),
            RaisedButton(
              onPressed: showReward,
              child: Text("show reward"),
            ),
          ],
        )
      ],
    );
  }

  Widget buildInterstitialWidget() {
    return Column(
      children: [
        buildTextField(interstitialEditController),
        Row(
          children: [
            RaisedButton(
              onPressed: () => loadInterstitial(),
              child: Text("load interstitial"),
            ),
            RaisedButton(
              onPressed: () => isReadyInterstitial(),
              child: Text("isReady"),
            ),
            RaisedButton(
              onPressed: () => showInterstitial(),
              child: Text("show interstitial"),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildNativeWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildTextField(nativeEditController),
        ),
        Expanded(
          flex: 1,
          child: RaisedButton(
            onPressed: () => loadInterstitial(),
            child: Text("load native"),
          ),
        ),
      ],
    );
  }

  Widget buildBannerWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildTextField(bannerEditController),
        ),
        Expanded(
          flex: 1,
          child: RaisedButton(
            onPressed: () => loadBanner(),
            child: Text("load banner"),
          ),
        ),
      ],
    );
  }

  Widget buildSplashWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildTextField(splashEditController),
        ),
        Expanded(
          flex: 1,
          child: RaisedButton(
            onPressed: () => loadInterstitial(),
            child: Text("load splash"),
          ),
        ),
      ],
    );
  }

  Widget buildLogListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, position) => list[position],
        controller: _controller,
      ),
    );
  }

  Widget buildClearLogBtn() {
    return RaisedButton(
      child: Text("clear log"),
      onPressed: () {
        setState(() {
          list.clear();
        });
      },
    );
  }

  Widget buildMsgWidget(String msg) {
    return Text(msg);
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLength: 10,
      maxLines: 1,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration:
          InputDecoration(contentPadding: EdgeInsets.all(0), counterText: ''),
    );
  }

//  BannerAd bannerAd;

//  Widget buildBannerView() {
//    bannerAd = BannerAd("8888");
//    return bannerAd;
//  }

  void initSdk() {
    addLog("init ${initEditController.text}");
    ZYTMediationSdk.initialize(initEditController.text, "",
        initCallBack: InitCallBack(
            onInitSuccess: () => addLog("init success"),
            onInitFailure: () => addLog("init failure")));
  }

  void loadReward() {
    addLog("load reward ${rewardEditController.text}");
    Reward.load(
        rewardEditController.text,
        RewardLoadCallBack(onLoaded: (adUnitId) {
          addLog("load reward success $adUnitId");
        }, onError: (adUnitId, errMsg) {
          addLog("load reward error $adUnitId,$errMsg");
        }));
  }

  void isReadyReward() {
    Reward.isReady(rewardEditController.text).then((value) {
      addLog("reward is ready:$value");
    });
  }

  void showReward() {
    Reward.show(
        rewardEditController.text,
        RewardShowCallBack(
          onAdClick: (adUnitId) {
            addLog("reward click $adUnitId");
          },
          onAdFinish: (adUnitId, reward) {
            addLog("reward finish $adUnitId,reward:$reward");
          },
          onAdShow: (adUnitId) {
            addLog("reward show $adUnitId");
          },
        ));
  }

  void loadInterstitial() {
//    addLog("load interstitial ${interstitialEditController.text}");
//    Interstitial.load(
//        interstitialEditController.text,
//        InterstitialLoadCallBack(onLoaded: (adUnitId) {
//          addLog("interstitial load success $adUnitId");
//        }, onError: (adUnitId, errMsg) {
//          addLog("interstitial error $adUnitId,$errMsg");
//        }, onAdClick: (adUnitId) {
////          addLog("interstitial click $adUnitId");
//        }, onClose: (adUnitId) {
////          addLog("interstitial close $adUnitId");
//        }));
  }

  void isReadyInterstitial() {
//    Interstitial.isReady(interstitialEditController.text).then((value) {
//      addLog("interstitial is ready:$value");
//    });
  }

  void showInterstitial() {
//    addLog("show interstitial ${interstitialEditController.text}");
//    Interstitial.show(interstitialEditController.text);
  }

  void jumpBottom() {
    Timer(Duration(microseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }

  addLog(String log) {
    setState(() {
      list.add(buildMsgWidget(log));
    });
  }

  void loadBanner() {
//    bannerAd.load(BannerLoadCallBack(onClose: (adUnitId) {
//      addLog("banner close");
//    }, onAdClick: (adUnitId) {
//      addLog("banner click");
//    }, onLoaded: (adUnitId) {
//      addLog("banner loaded");
//      bannerAd.show();
//    }, onError: (adUnitId, errMsg) {
//      addLog("banner error");
//    }));
  }

  @override
  bool get wantKeepAlive => true;
}
