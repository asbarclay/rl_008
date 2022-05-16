import 'package:flutter/material.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../class/recmon.dart';

class ViewPDF extends StatefulWidget {
  ViewPDF(this._url, this._titleString, {Key? key}) : super(key: key);

  final String _url;
  final String _titleString;

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  void initState() {
    super.initState();

    RecMon().registerAction("ViewPDF(): ${widget._titleString}");

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //extendBodyBehindAppBar: true,
        appBar: GlobalAppBar().appBar(widget._titleString + " Guide", context),
        body: Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Builder(
            builder: (BuildContext context) {
              return const PDF().cachedFromUrl(
                widget._url,
                placeholder: (progress) {
                  return Center(
                    child: TextStylePref().textRouteInfoItemHeadline(
                        "Downloading\n${progress.toInt().toString()}%"),
                  );
                },
                maxNrOfCacheObjects: 0,
              );
            },
          ),
        ),
      ),
    );
  }
}
