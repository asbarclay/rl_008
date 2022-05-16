import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';

import '../class/errors.dart';

class WidgetCustom {
  Widget circularProgress1() {
    //
    return CircularProgressIndicator(
      color: ColorGlobals().abellioRed(),
    );
  }

  Widget tapImageBottomHeadline(String _url, String _title) {
    //
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: GlobalStylePref().containerRadiusShadow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            // )
            //! Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Container(
                width: double.infinity,
                decoration: GlobalStylePref().containerRadiusShadow,
                child: CachedNetworkImage(
                  imageUrl:
                      _url,
                  placeholder: (context, url) => SpinKitThreeBounce(
                    color: ColorGlobals().iconColor1(),
                  ),
                  errorWidget: (context, url, error) =>
                      GlobalErrorMessages().futureBuilderConnectionError(),
                ),
              ),
            ),

            //! Title
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorGlobals().abellioRed(),
                    fontSize: 17,
                    fontFamily: "LeagueSpartan",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
