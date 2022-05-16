import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;

class Expired extends StatefulWidget {
  const Expired({Key? key}) : super(key: key);

  @override
  _ExpiredState createState() => _ExpiredState();
}

class _ExpiredState extends State<Expired> {
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
                  Text(
                    "Activation Expired",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "OpenSans-Regular",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We're sorry, but since you activated more than ${globals.thisActivationAllowedDays} days ago, your activation key has now expired.\n\n" +
                        "To keep using this application, you'll need to scan a new activation QR code.\n\n" +
                        "Please reach out to your line manager, or a route learning supervisor, to get a new code.\n\n" +
                        "Thank you for using Route Learner.",
                    style:
                        TextStyle(fontSize: 15, fontFamily: "OpenSans-Regular"),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GlobalButtonPref().midButton("Continue", () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  })
                ]),
          ),
        ),
      ),
    );
  }
}
