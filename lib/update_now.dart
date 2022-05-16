import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class UpdateNow extends StatefulWidget {
  const UpdateNow({Key? key}) : super(key: key);

  @override
  _UpdateNowState createState() => _UpdateNowState();
}

class _UpdateNowState extends State<UpdateNow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //appBar: GlobalAppBar().appBar("Activation Expired", context),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Update Required",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "OpenSans-Regular",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "We’re sorry, but your copy of Route Learner must be updated to the latest version.\n\n" +
                        "This is to ensure that you receive the latest security and feature upgrades.",
                    style:
                        TextStyle(fontSize: 18, fontFamily: "OpenSans-Regular"),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GlobalButtonPref().midButton("Update Now", () {
                    launchURL(globals.playStoreURL);
                  })
                ]),
          ),
        ),
      ),
    );
  }

  void launchURL(String _url) async {
    await launch(globals.playStoreURL);
  }
}
