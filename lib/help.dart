import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;

class LoginHelp extends StatefulWidget {
  const LoginHelp({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<LoginHelp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Login Help", context),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            child: Column(children: [
              Text(
                "This app needs to be activated with a QR code",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "OpenSans-Regular",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                child: Image.asset(
                  "./images/qrex.png",
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Please ask your line manager, or route learning supervisor, for the Route Learner QR code.\n\n" +
                    "Then, tap the 'Activate With QR Code' button in the previous screen, scan the QR code you have been shown, and this device will be verified.\n\n" +
                    // "You can also get a QR code from someone else who has already activated this app on their device.\n\n" +
                    // "Ask them to open the Route Learner app, " +
                    // "tap the menu button on the top left, and tap \'Show QR Code\'.\n\n" +
                    "Once verified, you should be able to use Route Learner without having to scan the QR code again.\n\n" +
                    "Please Note:\n" +
                    "If you reset your device, uninstall this application after being verified, deactivate this application from the settings menu, " +
                    "or change devices, you will need to scan an activation code again to use this application.",
                style: TextStyle(fontSize: 18, fontFamily: "OpenSans-Regular"),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
