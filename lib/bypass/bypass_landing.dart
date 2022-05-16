import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/qr_validate.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/widgets/widget_custom.dart';

class BypassLanding extends StatefulWidget {
  const BypassLanding({Key? key}) : super(key: key);

  @override
  _BypassLandingState createState() => _BypassLandingState();
}

class _BypassLandingState extends State<BypassLanding> {
  //
  final _activationCode = TextEditingController();
  String _msg = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Enter Activation Code", context),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$_msg\n",
                    style: TextStyle(
                      fontSize: 15,
                      color: ColorGlobals().abellioRed(),
                    ),
                  ),
                  TextField(
                    controller: _activationCode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "e.g. PQMX89Y",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //
                  // Activate button
                  //
                  GlobalButtonPref().midButton("Activate", () async {
                    //
                    // Check that user has entered something
                    //
                    if (_activationCode.text.isNotEmpty) {
                      //
                      // Show circular progress indicator to indicate processing by setting flag to true
                      //
                      setState(() {
                        _isLoading = true;
                      });

                      //
                      // Check the code is at least 10 characters long
                      //
                      if (_activationCode.text.length >= 5) {
                        // Delay for 2 seconds
                        Timer(Duration(seconds: 2), () {
                          // Query entered username & password in loginProcess method
                          loginProcess();
                        });
                      }
                      //
                      // Entered code is not long enough. Pause to give impression of processing, display
                      // incorrect code dialog, and disable circular progress indicator by setting flag to false
                      //
                      else {
                        // Code is not long enough, disable circular progress indicator
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            // Display incorrect code dialog
                            _incorrectCodeDialog();
                            // Set flag to false (may not  be required since above dialog pushes away from this screen)
                            _isLoading = false;
                          });
                        });
                      }
                    } else {
                      // Display error message
                      setState(() {
                        _msg = "Please enter an activation code";
                      });
                    }
                  }),
                  Visibility(
                    visible: _isLoading,
                    child: Center(
                      child: WidgetCustom().circularProgress1(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future loginProcess() async {
    //
    // Query Firestore with the activation code that was entered by the user
    var _fsi = await FirebaseFirestore.instance
        .collection("/code_bank/")
        .doc(_activationCode.text)
        .get();

    // If the code entered by the user exists as a document in Firestore, pass code to
    // qr_validate.dart to begin the entire process of activating this device
    if (_fsi.exists) {
      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRValidate(_activationCode.text),
        ),
      );
    }
    // Code entered by the user is not valid
    else {
      setState(() {
        _isLoading = false;
        _msg = "Code is not valid";
      });

      _incorrectCodeDialog();
    }
  }

  Future _incorrectCodeDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("The code you entered is not valid"),
        actions: [
          //! Ok button
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false),
              child: Text(
                "Ok",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
