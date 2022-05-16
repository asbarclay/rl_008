import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/content/content_landing.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/rrcodes/rrcodes_landing.dart';

class GlobalButtonPref {
  //
  // Defines a borderless button with min width of 300 and height of 100
  Widget loginPageHelpButton(String buttonText, VoidCallback funcCallback) {
    return ElevatedButton(
      onPressed: funcCallback,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorGlobals().abellioGrey(),
          fontSize: 20,
          fontFamily: "LeagueSpartan",
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(300, 70),
        primary: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget borderlessButtonWhiteText(
      String buttonText, VoidCallback funcCallback) {
    return ElevatedButton(
      onPressed: funcCallback,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 20,
          fontFamily: "LeagueSpartan",
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(300, 70),
        primary: const Color.fromRGBO(0, 0, 0, 0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget borderlessButtonYellowText(
      String buttonText, VoidCallback funcCallback) {
    return ElevatedButton(
      onPressed: funcCallback,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromRGBO(255, 253, 129, 1),
          fontSize: 20,
          fontFamily: "LeagueSpartan",
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(300, 70),
        primary: const Color.fromRGBO(0, 0, 0, 0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget midButton(String buttonText, VoidCallback funcCallback) {
    return Container(
      decoration: GlobalStylePref().containerRadiusShadow,
      child: ElevatedButton(
        onPressed: funcCallback,
        child: Ink(
          decoration: BoxDecoration(
              gradient: GlobalStylePref().buttonGradient(),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorGlobals().buttonTextColor1(),
                    fontSize: 16,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
          padding: EdgeInsets.all(0),
          maximumSize: const Size(300, 60),
          primary: const Color.fromRGBO(255, 255, 255, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          side: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget smallButton(String buttonText, VoidCallback funcCallback) {
    return ElevatedButton(
      onPressed: funcCallback,
      child: Ink(
        decoration: BoxDecoration(
            gradient: GlobalStylePref().buttonGradient(),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorGlobals().buttonTextColor1(),
                  fontSize: 16,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
        padding: EdgeInsets.all(0),
        maximumSize: const Size(120, 40),
        primary: const Color.fromRGBO(255, 255, 255, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        side: BorderSide(
          color: Colors.transparent,
          width: 2.0,
        ),
      ),
    );
  }

  ListTile sideMenuItem(
      String _icon, String _title, Color _tileColor, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        _icon,
        scale: 13,
      ),
      title: Text(
        _title,
        style: TextStyle(
          fontSize: 15,
          color: ColorGlobals().text1(),
          fontWeight: FontWeight.normal,
        ),
      ),
      onTap: onTap,
      tileColor: _tileColor,
      selectedTileColor: Colors.grey.shade300,
    );
  }

  Widget settingsItem(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    //
    return Container(
      decoration: GlobalStylePref().containerRadiusShadow,
      child: Card(
        color: const Color.fromRGBO(255, 255, 255, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        elevation: 0,
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(
            icon,
            color: ColorGlobals().iconColor1(),
            size: 40,
          ),
          title: Text(
            title,
            style: TextStyle(
                color: ColorGlobals().textCardTitle(),
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.black),
          ),
          tileColor: Colors.transparent,
          onTap: onTap,
        ),
      ),
    );
  }

  // Large button that offer a list of routes on main pages
  // ElevatedButton
  //
  Widget mainScreenButton(
      List _routes, int _index, String _switch, BuildContext context) {
    //
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        decoration: GlobalStylePref().containerRadiusShadowRounder,
        child: ElevatedButton(
          onPressed: () {
            // Check who the caller is, thereby allowing us to decide which path the
            // button should take the user
            if (_switch == "content") {
              // If content, move to content landing and pass route number
              // to spawn contenton that page
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (builder) => ContentLanding(
                    _routes[_index].toString(),
                  ),
                ),
              );
            } else if (_switch == "rrcodes") {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RRCodesLanding(
                    _routes[_index].toString(),
                  ),
                ),
              );
            }
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: GlobalStylePref().buttonGradient(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  _routes[_index].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GlobalStylePref().buttonTextColor1(),
                    fontSize: 35,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    /*shadows: [
                      Shadow(
                        color: GlobalStylePref().blueStandard(),
                        offset: Offset(1, 1),
                        blurRadius: 10,
                      ),
                    ],*/
                  ),
                ),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            elevation: 0,

            //minimumSize: const Size(300, 70),
            primary: const Color.fromRGBO(255, 255, 255, 0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            side: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tapToRevealCode(BuildContext context) {
    //
    return InkWell(
      onTap: () {},
    );
  }
}
