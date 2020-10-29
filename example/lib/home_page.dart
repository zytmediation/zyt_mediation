import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediation_flutter_example/native_example_page.dart';
import 'package:zyt_mediation/banner.dart';
import 'package:zyt_mediation/call_back.dart';
import 'package:zyt_mediation/interstitial.dart';
import 'package:zyt_mediation/reward.dart';
import 'package:zyt_mediation/splash.dart';
import 'package:zyt_mediation/splash_ad.dart';
import 'package:zyt_mediation/zyt_mediation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController initAppIdController = TextEditingController();
  TextEditingController initAppKeyController = TextEditingController();
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
            RaisedButton(
              child: Text("clear log"),
              onPressed: () {
                setState(() {
                  list.clear();
                });
              },
            ),
            buildLogListWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildInitWidget() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Expanded(flex: 1, child: buildTextField(initAppIdController, "appid")),
      Expanded(flex: 1, child: buildTextField(initAppKeyController, "appkey")),
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
        buildTextField(rewardEditController, "reward"),
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
        buildTextField(interstitialEditController, "interstitial"),
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
          child: buildTextField(bannerEditController, "banner"),
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
          child: buildTextField(splashEditController, "splash"),
        ),
        RaisedButton(
          onPressed: () => loadSplash(),
          child: Text("loadSplash"),
        ),
        RaisedButton(
          onPressed: () => showSplash(),
          child: Text("showSplash"),
        ),
        RaisedButton(
          onPressed: () => loadAndSplash(),
          child: Text("loadShowSplash"),
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

  Widget buildTextField(TextEditingController controller, [String hintText]) {
    return TextField(
      controller: controller,
      maxLines: 1,
      // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0), hintText: hintText),
      onSubmitted: (value) {
        print("文本提交 ：$value");
        setPreference(hintText, value);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    setupCacheData();
  }

  setPreference(String pKey, String pValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(pKey, pValue);
  }

  Future<String> getPreference(String pKey, String pValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(pKey);
  }

  setupCacheData() {
    Future<String> appid = getPreference("appid", "");
    appid.then((String value) {
      setState(() {
        initAppIdController.text = value;
      });
    });

    Future<String> appkey = getPreference("appkey", "");
    appkey.then((String value) {
      setState(() {
        initAppKeyController.text = value;
      });
    });

    Future<String> reward = getPreference("reward", "");
    reward.then((String value) {
      setState(() {
        rewardEditController.text = value;
      });
    });

    Future<String> interad = getPreference("interstitial", "");
    interad.then((String value) {
      setState(() {
        interstitialEditController.text = value;
      });
    });

    Future<String> banner = getPreference("banner", "");
    banner.then((String value) {
      setState(() {
        bannerEditController.text = value;
      });
    });

    Future<String> splash = getPreference("splash", "");
    splash.then((String value) {
      setState(() {
        splashEditController.text = value;
      });
    });
  }

  initSdk() {
    addLog("init ${initAppIdController.text}");
    ZYTMediationSdk.initialize(
        initAppIdController.text, initAppKeyController.text,
        initCallBack: InitCallBack(
            onInitSuccess: () => addLog("init success"),
            onInitFailure: () => addLog("init failure")));
  }

  loadReward() {
    addLog("load reward ${rewardEditController.text}");
    Reward.load(
        rewardEditController.text.toString(),
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
          Container(
              color: Colors.amber,
              child: BannerAd(bannerEditController.text,
                  bannerCallBack: BannerCallBack(
                      onLoaded: (_) => addLog("banner load success"),
                      onClose: (_) => addLog("banner close"),
                      onError: (_, errMsg) => addLog("banner error:$errMsg"),
                      onAdClick: (_) => addLog("banner click")))));
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
    addLog("load interstitial ${interstitialEditController.text}");
    Interstitial.load(
        interstitialEditController.text,
        InterstitialLoadCallBack(onLoaded: (adUnitId) {
          addLog("interstitial load success $adUnitId");
        }, onError: (adUnitId, errMsg) {
          addLog("interstitial error $adUnitId,$errMsg");
        }, onAdClick: (adUnitId) {
          addLog("interstitial click $adUnitId");
        }, onClose: (adUnitId) {
          addLog("interstitial close $adUnitId");
        }));
  }

  SplashAd splashAd;

  loadSplash() {
    addLog("load splash ${splashEditController.text}");
    splashAd = SplashAd.newInstance(splashEditController.text);
    splashAd.splashCallBack =
        SplashCallBack(onSplashLoaded: (String adUnitId, SplashAd splashAd) {
      addLog("splash loaded $adUnitId");
    }, onAdShow: (adUnitId) {
      addLog("splash show $adUnitId");
    }, onError: (adUnitId, errMsg) {
      addLog("splash error $adUnitId,$errMsg");
    }, onAdClick: (adUnitId) {
      addLog("splash click $adUnitId");
    }, onClose: (adUnitId) {
      addLog("splash close $adUnitId");
    });
    splashAd.load();
  }

  showSplash() {
    addLog("show splash");
    splashAd?.show();
  }

  loadAndSplash() {
    addLog("load splash ${splashEditController.text}");
    splashAd = SplashAd.newInstance(splashEditController.text);
    splashAd.splashCallBack =
        SplashCallBack(onSplashLoaded: (String adUnitId, SplashAd splashAd) {
      addLog("splash loaded $adUnitId");
      splashAd.show();
    }, onAdShow: (adUnitId) {
      addLog("splash show $adUnitId");
    }, onError: (adUnitId, errMsg) {
      addLog("splash error $adUnitId,$errMsg");
    }, onAdClick: (adUnitId) {
      addLog("splash click $adUnitId");
    }, onClose: (adUnitId) {
      addLog("splash close $adUnitId");
    });
    splashAd.load();
  }

  isReadyInterstitial() {
    Interstitial.isReady(interstitialEditController.text).then((value) {
      addLog("interstitial is ready:$value");
    });
  }

  showInterstitial() {
    addLog("show interstitial ${interstitialEditController.text}");
    Interstitial.show(interstitialEditController.text);
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
