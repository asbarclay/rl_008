import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import 'class/recmon.dart';

class WebViewGlobal extends StatefulWidget {
  WebViewGlobal(this._url, this._title, {Key? key}) : super(key: key);

  final String _url;
  final String _title;

  @override
  _WebViewGlobalState createState() => _WebViewGlobalState();
}

class _WebViewGlobalState extends State<WebViewGlobal> {
  @override
  void initState() {
    super.initState();

    RecMon().registerAction("WebViewGlobal(): ${widget._title}");

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    //
    //final _randNum = Random().nextInt(1000);

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //extendBodyBehindAppBar: true,
        appBar: GlobalAppBar().appBar(widget._title, context),
        body: Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Builder(builder: (BuildContext context) {
            return WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "${widget._url}",
              // backgroundColor: ColorGlobals().abellioGrey(),
              onProgress: (int progress) {
                setState(() {
                  Text(progress.toString());
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
