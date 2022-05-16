import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalStylePref {
  //
  // Main background gradient as BoxDecoration
  BoxDecoration mainBackgroundStyle = const BoxDecoration(
    color: Color.fromRGBO(225, 235, 237, 1),
    // image: const DecorationImage(
    //   image: AssetImage("images/bg2.png"),
    //   fit: BoxFit.cover,
    // ),
    // gradient: LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: [
    //     // Berry
    //     // Color.fromRGBO(117, 22, 131, 1),
    //     // Color.fromRGBO(36, 41, 111, 1),
    //     Colors.grey.shade200,
    //     Colors.grey.shade200,
    //   ],
    // ),
  );

  //
  // Modal background gradient as BoxDecoration
  BoxDecoration modalBackgroundStyle = const BoxDecoration(
    // color: Color.fromRGBO(225, 235, 237, 1),
    // image: const DecorationImage(
    //   image: AssetImage("images/bg2.png"),
    //   fit: BoxFit.cover,
    // ),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // Berry
        // Color.fromRGBO(117, 22, 131, 1),
        // Color.fromRGBO(36, 41, 111, 1),
        Colors.white,
        Color.fromRGBO(225, 235, 237, 1),
      ],
    ),
  );

  //
  // Main background gradient as BoxDecoration
  BoxDecoration mainBackgroundStyleNoBG = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // Berry
        // Color.fromRGBO(117, 22, 131, 1),
        // Color.fromRGBO(36, 41, 111, 1),
        Colors.grey.shade300,
        Colors.grey.shade300,
      ],
    ),
  );

  BoxDecoration containerRadiusShadow = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Color.fromARGB(255, 255, 255, 255),
    boxShadow: const [
      // Add shadow to the main background container
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        offset: Offset(0, 3),
        blurRadius: 10,
        spreadRadius: 0.1,
        blurStyle: BlurStyle.normal,
      ),
    ],
  );

  BoxDecoration containerRadiusShadowRounder = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Color.fromARGB(255, 255, 255, 255),
    boxShadow: const [
      // Add shadow to the main background container
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        offset: Offset(0, 3),
        blurRadius: 10,
        spreadRadius: 0.1,
        blurStyle: BlurStyle.normal,
      ),
    ],
  );

  //
  // AppBar global background color
  // BERRY >> Color appBarBackgroundStyle = const Color.fromRGBO(2, 29, 101, 0.4);
  Color appBarBackgroundStyle = const Color.fromRGBO(211, 1, 50, 1);
  //
  // AppBar elevation
  final double appBarElevation = 0;

  Color buttonTextColor1() {
    return const Color.fromRGBO(211, 1, 50, 1);
  }

  Gradient buttonGradient() {
    return const LinearGradient(
      colors: [
        // Color.fromRGBO(150, 21, 153, 1),
        // Color.fromRGBO(131, 19, 134, 1),
        // Color.fromRGBO(111, 15, 113, 1)
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
