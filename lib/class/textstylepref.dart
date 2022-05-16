import 'package:flutter/material.dart';
import 'package:rl_001/class/color_globals.dart';

class TextStylePref {
  Text midWhite16NormalCenter(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    );
  }

  Text midWhite16BoldCenter(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Text settingsHeadline(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text textRouteInfoItemHeadline(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text textRouteInfoItem(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Text contentItemHeadline(String text) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorGlobals().abellioRed()),
    );
  }

  Text aboutBoxHeadlineText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: ColorGlobals().abellioRed()),
    );
  }

  Text aboutBoxBodyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }
}
