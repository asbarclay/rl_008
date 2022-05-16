import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'class/color_globals.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/main.dart';
import 'package:random_string/random_string.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'class/recmon.dart';
import 'class/stylepref.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'globals.dart' as globals;

class QRValidate extends StatefulWidget {
  QRValidate(this._qrScannedCode, {Key? key}) : super(key: key);

  String _qrScannedCode;

  @override
  _QRValidateState createState() => _QRValidateState();
}

class _QRValidateState extends State<QRValidate> {
  //

  String _stateMsg = "Validating";
  double _percentProgress = 0.0;

  @override
  void initState() {
    //
    super.initState();
    _confirmQRValid();
    RecMon().registerAction("QRValidate()");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: GlobalAppBar().appBar("Validating", context),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 70,
                // ),
                Text(
                  _stateMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "LeagueSpartan",
                      fontSize: 17.0,
                      color: ColorGlobals().textLoadingScreen()),
                ),
                // Opacity(
                //   opacity: 1,
                //   child: Image.asset(
                //     "./images/key.png",
                //     scale: 3,
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  child: LinearPercentIndicator(
                    percent: _percentProgress,
                    width: 200,
                    lineHeight: 5,
                    backgroundColor: Colors.transparent,
                    progressColor: ColorGlobals().progressBar1(),
                    animation: true,
                    animateFromLastPercent: true,
                    //
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _confirmQRValid() async {
    //
    Map<String, dynamic>? _data = {};

    try {
      setState(() {
        _stateMsg = "Verifying";
        _percentProgress = 0.1;
      });

      var _fsi = await FirebaseFirestore.instance
          .collection("/code_bank/")
          .doc(widget._qrScannedCode)
          .get()
          .timeout(const Duration(
              seconds: 20)); // Set timeout, catch below "on timeoutexception"

      // QR code is valid
      if (_fsi.exists) {
        //
        // Display message
        setState(() {
          _stateMsg = "Success";
          _percentProgress = 0.2;
        });

        print("QR code valid");

        // Save all metadata inside of code document to local Map
        _data = _fsi.data();

        // Delete code from firestore cloud
        await FirebaseFirestore.instance
            .collection("/code_bank/")
            .doc(widget._qrScannedCode)
            .delete();

        // Write activation key to device and push to next page
        _writeActivationKey(_data);
      }
      // QR is not valid
      else {
        setState(() {
          _stateMsg = "Invalid Code";
          _percentProgress = 1.0;
        });

        _invalidActivationCheckExists();

        // Timer(Duration(seconds: 2), () {
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LoginPage(),
        //       ),
        //       (Route route) => false);
        // });
      }
    } on TimeoutException {
      _errorAndReturnToLogin("Request timed out");
    } catch (e) {
      //
      _errorAndReturnToLogin("Unable to validate QR code");
    }
  }

  Future _invalidActivationCheckExists() async {
    //

    try {
      //
      // Check if this UID has a previous invalid activation attempt

      await FirebaseFirestore.instance
          .collection("failed_activations")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get()
          .then((document) {
        //
        // Document exists, user has failed in the past, so act on it
        if (document.exists) {
          //
          _invalidActivationsBlockOrNot();
        }
        // Does not exist, create and set first failure
        else {
          //
          // Write UID to failed_activations collection for inspection later
          FirebaseFirestore.instance
              .collection("failed_activations")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set({
            "failures": 1,
            "date": DateTime.now().toString(),
          });
          //
          // Push back to login screen
          // Subtract one from max attempt globals because user already had one go
          // to get to this stage in the code
          _errorAndReturnToLogin(
              "Invalid Code\n${globals.maxActivAttempts - 1} Attempts Left");
        }
      });
    } catch (e) {
      //
    }
  }

  Future _invalidActivationsBlockOrNot() async {
    //
    // If user has previous invalid activations, check number to see if
    // the user needs to be barred from access
    try {
      //
      // Get data about this UID's previous failures
      var _uidFailedActivation = await FirebaseFirestore.instance
          .collection("failed_activations")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Assign data inside this document to variable
      Map<String, dynamic>? _uidFailureData = _uidFailedActivation.data();
      int _failValue = _uidFailureData!["failures"];

      // There's still headroom, so increment current number of failures
      // by one, and update "failures" on this UID's failed activations document
      _failValue++;

      // Write new incremented failure value to firestore

      await FirebaseFirestore.instance
          .collection("failed_activations")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"failures": _failValue});

      // Is new post incremented fail value is equal to max number of attempts?
      if (_failValue == globals.maxActivAttempts) {
        //
        // User has used max. number of allowed failures,
        // and UID will be added to barred list, pushed to main
        //
        // Add uid to barred list
        await FirebaseFirestore.instance
            .collection("barred_uid")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "reason": "Exceeded max. allowed number of invalid code scans."
        });

        // Remove uid from failed_activations
        await FirebaseFirestore.instance
            .collection("failed_activations")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete();

        // Push back to Main() to trigget barred check and lock app

        setState(() {
          _stateMsg = "Invalid Code\nNo Attempts Remaining";
        });

        Timer(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainArea(),
              ),
              (Route route) => false);
        });
      }
      // Otherwise, can try again
      else {
        _errorAndReturnToLogin(
            "Invalid Code\n${(globals.maxActivAttempts - _failValue)} Attempts Remain");
      }

      //
    } catch (e) {
      //
    }
  }

  //
  // Vars for below methods
  String _depot = "";
  String _level = "";
  String _donor = "";
  String _donorLevel = "";
  String _activationQRCode = "";
  //
  // Writes activation key to device via encrypted shared prefs
  //
  void _writeActivationKey(Map<String, dynamic>? _data) {
    // Write activation key to device
    try {
      _depot = _data?["depot"];
      _level = _data?["level"];
      _donor = _data?["donor"];
      _donorLevel = _data?["donlev"];
      _activationQRCode = widget
          ._qrScannedCode; // Write the QR code that was used to activate this device
      String _key = randomAlphaNumeric(25);

      // Set up instance of EncryptedSharedPrefs
      EncryptedSharedPreferences _esp = EncryptedSharedPreferences();

      // Write key to device
      _esp.setString("rlkey", _key).then((bool _success) {
        if (_success) {
          // Set activation level
          _esp.setString("rllev", _level);

          // Key was written to device, now send to server
          _saveKeyToCloud(_key);
        } else {
          // Throw error as key could not be written
          setState(() {
            _stateMsg = "Could not write key\nto device.\nCheck your storage.";
          });
          throw 1;
        }
      });
    }
    // Something has gone wrong
    catch (e) {
      //
      _errorAndReturnToLogin("_writeActivationKey method exception");
    }
  }

  // Saves key to firestore
  Future _saveKeyToCloud(String _key) async {
    try {
      // Save details to server
      setState(() {
        _stateMsg = "Creating Key";
        _percentProgress = 0.5;
      });

      await FirebaseFirestore.instance
          .collection("/users_$_level/")
          .doc(_key)
          .set({
            "qr": widget._qrScannedCode.toUpperCase(),
            "key": _key,
            "depot": _depot,
            "level": _level,
            "time": DateTime.now().toString(),
            "uid": (FirebaseAuth.instance.currentUser!.uid.toString() !=
                    null) /* Get Firebase UID, check if null */
                ? FirebaseAuth.instance.currentUser!.uid.toString()
                : "No UID",
            "donor": _donor,
            "actnum": 0,
            "loadmsg": "yes"
          })
          .timeout(const Duration(seconds: 20))
          .whenComplete(() {
            print("saved new user to cloud");
            _updateActivationNumberOfDonor(_level, _donor);
          });
      //
    } on TimeoutException {
      _errorAndReturnToLogin("Request timed out");
    } catch (e) {
      _errorAndReturnToLogin("Failed:\nUnable to save key to cloud");
    }
  }

  //
  // Update donor entry in users_ database to tick up number of activations by one
  Future _updateActivationNumberOfDonor(String _level, String _donor) async {
    //
    // Get existing number of activations
    // REMEMBER! Must use _donorLevel to access the donor's collection, otherwise
    // will end up trying to access a document in new activation's level directory
    // which will crash the app.
    //
    try {
      int _actnum = await FirebaseFirestore.instance
          .collection("/users_$_donorLevel/")
          .doc(_donor)
          .get()
          .then((value) {
        return value["actnum"];
      });
      // Incase request takes too long, push to next step.
      // This step is not really that important since all we are doing is adding 1
      // to number of activations.

      setState(() {
        _percentProgress = 0.7;
      });

      print("got actnum value as $_actnum");

      // Increment number of activations
      _actnum++;

      // Write new activations number back to donor entry
      await FirebaseFirestore.instance
          .collection("/users_$_donorLevel/")
          .doc(_donor)
          .update({"actnum": _actnum}).whenComplete(
              () => _setGlobalsAndTakeToMain());
    } catch (e) {
      //
      print("exception in _updateActivationNumberOfDonor");
      setState(() {
        _stateMsg = "exception in _updateActivationNumberOfDonor";
      });
      _setGlobalsAndTakeToMain();
    }
  }

  void _setGlobalsAndTakeToMain() {
    //
    print("pushing to main");

    setState(() {
      //
      _stateMsg = "Activation Complete";
      _percentProgress = 1.0;
    });

    Timer(Duration(seconds: 1), () {
      //
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainArea()));
    });
  }

  void _errorAndReturnToLogin(String _errorMsg) {
    //
    setState(() {
      _stateMsg = _errorMsg;
      _percentProgress = 1.0;
    });

    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
            (Route route) => false);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
