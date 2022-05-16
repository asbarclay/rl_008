import 'package:flutter/material.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';

class GlobalAppBar {
  //
  AppBar appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: ColorGlobals().appBarBackgroundColor(),
      elevation: 0,
      // leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
    );
  }
}
