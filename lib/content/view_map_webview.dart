import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class ViewMapWebview extends StatefulWidget {
  ViewMapWebview(this._routeNumber, this._mapTitle, this._mapURL, {Key? key})
      : super(key: key);

  final String _routeNumber;
  final String _mapTitle;
  final String _mapURL;

  @override
  _ViewMapWebviewState createState() => _ViewMapWebviewState();
}

class _ViewMapWebviewState extends State<ViewMapWebview> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //extendBodyBehindAppBar: true,
        appBar: GlobalAppBar()
            .appBar(widget._routeNumber + " " + widget._mapTitle, context),
        body: Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height + 20,
          child: Builder(builder: (BuildContext context) {
            return WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget._mapURL,
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
