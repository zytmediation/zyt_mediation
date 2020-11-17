import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zyt_mediation/call_back.dart';
import 'package:zyt_mediation/native.dart';
import 'package:zyt_mediation/screen_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NativeExamplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NativeExampleState();
}

class _NativeExampleState extends State<NativeExamplePage> {
  TextEditingController _nativeEditController = TextEditingController();
  TextEditingController _widthEditController = TextEditingController();
  TextEditingController _heightEditController = TextEditingController();
  List<Widget> list = List<Widget>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
//    jumpBottom();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: buildTextField(_widthEditController, hintText: "width")),
              Expanded(
                  child:
                  buildTextField(_heightEditController, hintText: "height")),
            ]),
            Row(children: [
              Expanded(child: buildTextField(_nativeEditController,hintText:"slotKey")),
              RaisedButton(
                onPressed: () => clearNative(),
                child: Text("clear native"),
              ),
              RaisedButton(
                onPressed: () => loadNative(),
                child: Text("load native"),
              ),
              RaisedButton(
                onPressed: () => performanceTest(),
                child: Text("性能测试"),
              )
            ]),
            Expanded(
              child:
              list == null ? Container(color: Colors.white,) :
              ListView.builder(
                  controller: _controller,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return list[index];
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setupCacheData();
  }

  Widget buildTextField(TextEditingController controller, {String hintText}) {
    return TextField(
      controller: controller,
      maxLength: 10,
      maxLines: 1,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          counterText: '',
          hintText: hintText),
      onSubmitted: (value) {
        print("文本提交 ：$value");
        setPreference(hintText, value);
      },
    );
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
    Future<String> slotKey = getPreference("slotKey", "");
    slotKey.then((String value) {
      setState(() {
        _nativeEditController.text = value;
      });
    });

    Future<String> width = getPreference("width", "");
    width.then((String value) {
      setState(() {
        _widthEditController.text = value;
      });
    });

    Future<String> height = getPreference("height", "");
    height.then((String value) {
      setState(() {
        _heightEditController.text = value;
      });
    });

  }


    loadNative() {
    addLog("load native");
    double width, height;
    var wText = _widthEditController.text;
    var hText = _heightEditController.text;
    if (wText.isNotEmpty) {
      width = double.parse(wText);
    }
    if (hText.isNotEmpty) {
      height = double.parse(hText);
    }
    setState(() {
      list.insert(
          0,
          UnconstrainedBox(
              child: Container(
                  color: Colors.amber,
                  width: width,
                  height: height,
                  child: Center(child: buildNativeAd()))));
    });
  }

  static const Color color = Colors.blueAccent;

  performanceTest() {
    for (int i = 0; i < 6; i++) {
      list.add(buildItem(i));
    }
    setState(() {});
  }

  buildItem(int index) {
    return index % 3 == 0
        ? Container(color: Colors.amber, child: Center(child: buildNativeAd()))
        : Container(
            margin: EdgeInsets.all(20),
            width: ScreenUtil.SCREEN_WIDTH,
            height: 200,
            color: color);
  }

  buildNativeAd() {
    return NativeAd(
      _nativeEditController.text,
      width: double.parse(_widthEditController.text),
      height: double.parse(_heightEditController.text),
      nativeCallBack: NativeCallBack(
          onLoaded: (_) => addLog("load success"),
          onAdClick: (_) => addLog("native click"),
          onClose: (_) => addLog("native close"),
          onError: (_, errMsg) => addLog("native error:$errMsg")),
    );
  }

  clearNative() {
    setState(() {
      list = null;
    });
  }

  addLog(String log) {
    setState(() {
      list.add(Text(log));
    });
  }

  jumpBottom() {
    Timer(Duration(microseconds: 500),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }
}
