import 'package:flutter/material.dart';
import 'package:rl_001/class/stylepref.dart';

class SelectActivationRoutes extends StatefulWidget {
  const SelectActivationRoutes({Key? key}) : super(key: key);

  @override
  _SelectActivationRoutesState createState() => _SelectActivationRoutesState();
}

class _SelectActivationRoutesState extends State<SelectActivationRoutes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Activate Driver"),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(65, 26, 117, 1),
          elevation: 0,
          // leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        ),
        body: Container(
          padding: const EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(),
        ),
      ),
    );
  }
}
