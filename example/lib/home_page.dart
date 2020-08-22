import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediation_flutter_example/native_example_page.dart';
import 'package:zyt_mediation/banner.dart';
import 'package:zyt_mediation/call_back.dart';
import 'package:zyt_mediation/reward.dart';
import 'package:zyt_mediation/zyt_mediation.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController initEditController = TextEditingController();
  TextEditingController rewardEditController = TextEditingController();
  TextEditingController interstitialEditController = TextEditingController();
  TextEditingController bannerEditController = TextEditingController();
  TextEditingController splashEditController = TextEditingController();
  List<Widget> list = List();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            buildInitWidget(),
            buildRewardWidget(),
            buildInterstitialWidget(),
            buildNativeWidget(),
            buildBannerWidget(),
            buildSplashWidget(),
            buildLogListWidget(),
          ],
        ),
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
    return RaisedButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => NativeExamplePage())),
        child: Text("go native page"));
  }

  Widget buildBannerWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildTextField(bannerEditController),
        ),
        RaisedButton(
            child: Text("clear banner"), onPressed: () => clearBanner()),
        RaisedButton(child: Text("load banner"), onPressed: () => loadBanner())
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
        RaisedButton(
          onPressed: () => loadInterstitial(),
          child: Text("load splash"),
        ),
        RaisedButton(
          child: Text("clear log"),
          onPressed: () {
            setState(() {
              list.clear();
            });
          },
        )
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

  initSdk() {
    addLog("init ${initEditController.text}");
    ZYTMediationSdk.initialize(initEditController.text, "",
        initCallBack: InitCallBack(
            onInitSuccess: () => addLog("init success"),
            onInitFailure: () => addLog("init failure")));
  }

  loadReward() {
    addLog("load reward ${rewardEditController.text}");
    Reward.load(
        rewardEditController.text,
        RewardLoadCallBack(onLoaded: (adUnitId) {
          addLog("load reward success $adUnitId");
        }, onError: (adUnitId, errMsg) {
          addLog("load reward error $adUnitId,$errMsg");
        }));
  }

  isReadyReward() {
    Reward.isReady(rewardEditController.text).then((value) {
      addLog("reward is ready:$value");
    });
  }

  showReward() {
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

  loadBanner() {
    setState(() {
      list.insert(
          0,
          BannerAd(bannerEditController.text,
              bannerCallBack: BannerCallBack(
                  onLoaded: (_) => addLog("banner load success"),
                  onClose: (_) => addLog("banner close"),
                  onError: (_, errMsg) => addLog("banner error:$errMsg"),
                  onAdClick: (_) => addLog("banner click"))));
    });
  }

  clearBanner() {
    if (list.length > 0 && list[0] is BannerAd) {
      setState(() {
        list.removeAt(0);
      });
    }
  }

  loadInterstitial() {
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

  isReadyInterstitial() {
//    Interstitial.isReady(interstitialEditController.text).then((value) {
//      addLog("interstitial is ready:$value");
//    });
  }

  showInterstitial() {
//    addLog("show interstitial ${interstitialEditController.text}");
//    Interstitial.show(interstitialEditController.text);
  }

  addLog(String log) {
    setState(() {
      list.add(buildMsgWidget(log));
    });
  }

  jumpBottom() {
    Timer(Duration(microseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }
}
