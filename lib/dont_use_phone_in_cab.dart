import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/index.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'globals.dart' as globals;
import 'home.dart';

class DontUsePhoneInCab extends StatefulWidget {
  DontUsePhoneInCab({Key? key}) : super(key: key);

  @override
  _DontUsePhoneInCabState createState() => _DontUsePhoneInCabState();
}

class _DontUsePhoneInCabState extends State<DontUsePhoneInCab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Warning", context),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text(
                "It is against company policy to use your phone inside the cab",
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                child: Image.asset(
                  "./images/nophone.jpg",
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Before using this app, always:\n\n"
                "- Stop the vehicle safely -\n"
                "- Apply the handbrake -\n"
                "- Switch off the vehicle -\n"
                "- Leave the cab -\n\n"
                "If you're in service, don't forget to make "
                "an announcement.",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "OpenSans-Regular",
                  //fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                child:
                    GlobalButtonPref().midButton("Agree & Continue", () async {
                  //
                  // Set to "no" so advisory / warning screens do not show again
                  // We update the "loadmsg" field in the user's Firestore entry, which is read
                  // in Main() when the app starts up. If "no", then no advisory screens.
                  //
                  await FirebaseFirestore.instance
                      .collection("users_${globals.level}")
                      .doc(globals.key)
                      .update({"loadmsg": "no"});

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => const Home()),
                      (route) => false);
                }),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
