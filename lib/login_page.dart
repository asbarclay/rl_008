import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/bypass/bypass_landing.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/help.dart';
import 'package:rl_001/qrscan.dart';
import 'package:rl_001/webview_global.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 8,
                child: Center(
                  child: Opacity(
                    opacity: 1,
                    child: Image.asset(
                      "./images/rlrl1.png",
                      scale: 2.7,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    decoration: GlobalStylePref().containerRadiusShadow,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QRScan()));
                      },
                      child: Text(
                        "Activate\nWith QR Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorGlobals().iconColor1(),
                          fontSize: 20,
                          fontFamily: "LeagueSpartan",
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: Size(300, 100),
                        primary: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        // side: BorderSide(
                        //   color: ColorGlobals().iconColor1(),
                        //   width: 0.0,
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: GlobalButtonPref().loginPageHelpButton("Help", () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginHelp()));
                  }),
                ),
              ),
              // Login Link Container
              Visibility(
                visible: globals.showLoginWithUserPassLink,
                child: Expanded(
                  flex: 1,
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: "Or ",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 15,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: "Enter Activation Code",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BypassLanding(),
                                ),
                              );
                            },
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "By using Route Learner, you agree to its ",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        //
                        TextSpan(
                          text: "Terms of Use",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewGlobal(
                                      "http://xesa.io/tos.html",
                                      "Terms and Conditions"),
                                ),
                              );
                            },
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        //
                        const TextSpan(
                          text: " and ",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        //
                        TextSpan(
                          text: "Privacy Policy",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewGlobal(
                                      "http://xesa.io/privacy.html",
                                      "Privacy Policy"),
                                ),
                              );
                            },
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        //
                        const TextSpan(
                          text: ". © 2022 Abellio London.",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        //
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: Image.asset(
              //     "./images/ablogos.png",
              //     scale: 4,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
