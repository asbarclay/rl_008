import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer(this._url, this._title, {Key? key}) : super(key: key);

  final String _url;
  final String _title;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
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
        appBar: AppBar(
          title: Text(widget._title),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(65, 26, 117, 1),
          elevation: 0,
          // leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        ),
        body: Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Builder(builder: (BuildContext context) {
            return WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget._url,
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
