import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';

class ViewMap extends StatefulWidget {
  ViewMap(this._routeNumber, this._mapTitle, {Key? key}) : super(key: key);

  String _routeNumber;
  String _mapTitle;

  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar()
            .appBar(widget._routeNumber + " " + widget._mapTitle, context),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(
                // Keep image from being zoomed out beyond actual size
                minScale: PhotoViewComputedScale.contained,
                // Keeps image from being zoomed in beyond actual size
                maxScale: PhotoViewComputedScale.covered,

                basePosition: Alignment.center,
                enableRotation: true,
                backgroundDecoration: GlobalStylePref().mainBackgroundStyle,
                // While image loading
                loadingBuilder: (context, _progress) {
                  return Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          TextStylePref()
                              .midWhite16BoldCenter("Fetching Map..."),
                          LinearProgressIndicator(
                            color: ColorGlobals().abellioRed(),
                            backgroundColor: Colors.white,
                            value: _progress == null
                                ? null
                                : _progress.cumulativeBytesLoaded /
                                    _progress.expectedTotalBytes!,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                imageProvider: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/rl100-1a10e.appspot.com/o/267.jpg?alt=media&token=0c985e53-4040-438e-885c-ee68946d0c33"),
              )),
        ),
      ),
    );
  }
}
