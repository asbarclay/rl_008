import 'package:flutter/material.dart';
import 'package:rl_001/class/color_globals.dart';

class GlobalErrorMessages {
  //
  Widget futureBuilderConnectionError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: ColorGlobals().abellioRed(),
            size: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Nothing Here",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "OpenSans",
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
