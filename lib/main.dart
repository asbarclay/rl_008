import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rl_001/class/buttonpref.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/datanotice.dart';
import 'package:rl_001/expired.dart';
import 'package:rl_001/home.dart';
import 'package:rl_001/index.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/select_depot.dart';
import 'package:rl_001/update_now.dart';
import 'dart:async';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "OpenSans-Regular",
        primaryColor: ColorGlobals().text1(),
        accentColor: ColorGlobals().text1(),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorGlobals().abellioRed(),
              width: 6,
            ),
          ),
        ),
        // bottomSheetTheme: BottomSheetThemeData(
        //   backgroundColor: Color.fromRGBO(36, 41, 111, 0.9),
        // ),
      ),
      routes: {
        // "/267": (context) => const landing_267(),
        "/datanotice": (context) => DataNotice(),
      },
      home: const MainArea(),
    );
  }
}

class MainArea extends StatefulWidget {
  const MainArea({Key? key}) : super(key: key);

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  //
  String _stateMsg = "Connecting...";
  String _level = "no_level";
  double _percentProgress = 0.0;
  bool _displayMsg = false;

  @override
  void initState() {
    super.initState();
    _anonSignin();
    // _isDeviceBarred();
    //_isDeviceActivated();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 70,
                // ),
                // Text(
                //   _stateMsg,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontFamily: "LeagueSpartan",
                //     fontSize: 17.0,
                //     color: ColorGlobals().abellioGrey(),
                //   ),
                // ),
                Visibility(
                  visible: _displayMsg,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),

                Container(
                  width: 200,
                  child: CircularPercentIndicator(
                    percent: _percentProgress,
                    lineWidth: 10,
                    //: 90.0,

                    center: Image.asset(
                      "./images/rlicon.png",
                      scale: 4,
                    ),
                    backgroundColor: Color.fromRGBO(225, 235, 237, 1),
                    //arcBackgroundColor: Colors.transparent,
                    progressColor: ColorGlobals().abellioRed(),
                    //arcType: ArcType.FULL,
                    fillColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.square,
                    animation: true,
                    animateFromLastPercent: true,
                    radius: 145,
                    curve: Curves.ease,
                  ),
                  // LinearPercentIndicator(
                  //   percent: _percentProgress,
                  //   width: 200,
                  //   lineHeight: 5,
                  //   backgroundColor: Colors.transparent,
                  //   progressColor: ColorGlobals().progressBar1(),
                  //   animation: true,
                  //   animateFromLastPercent: true,
                  //   //
                  // ),
                ),

                Visibility(
                  visible: _displayMsg,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),

                Visibility(
                  visible: _displayMsg,
                  child: Text(
                    _stateMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "LeagueSpartan",
                      fontSize: 15.0,
                      color: ColorGlobals().abellioGrey(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  // Generate / assign existing Firebase UID
  // Doing this first because we need the UID in _isDeviceBarred,
  // and unless we take care of this first, below method will fail
  // since it will be called while UID is still null
  //
  // This happens with a new user / after user clears storage / cache
  //
  void _anonSignin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        _updateProgressIndicator(0.1);
        _registerConnectionAttempt();
      }).timeout(Duration(seconds: 5));

      //
      // In case no connection, above timeout will trigger TimeoutException
      // Catch and show text on screen
    } on TimeoutException {
      _updateStateMsg("Unable to Connect");
      _updateProgressIndicator(0);
    } catch (e) {
      _updateStateMsg("Unable to Connect");
      _updateProgressIndicator(0);
    }
  }

  //
  // Record connection attempt in Firestore / Activity / Logins
  //
  Future _registerConnectionAttempt() async {
    //
    try {
      //
      Map<String, dynamic> _connectionDataToRegister = {
        "UID": FirebaseAuth.instance.currentUser!.uid.toString(),
        "method": "_registerConnectionAttempt",
        "time": DateTime.now().toString(),
        "clientVersion": globals.appVersionString,
        "clientOS": globals.targetOS,
      };

      await FirebaseFirestore.instance
          .collection("/logins/")
          .doc(DateTime.now().toString())
          .set(_connectionDataToRegister)
          .then((value) => _getGlobalsFromCloud())
          .timeout(const Duration(
              seconds: 5)); // Set 5 second timeout in case user is not online
      //
      // In case no connection, above timeout will trigger TimeoutException
      // Catch and show text on screen
    } on TimeoutException {
      _updateStateMsg("Unable to Connect");
      _updateProgressIndicator(0);

      //
    } catch (e) {
      //
      // Error
      print("Error _registerConnectionAttempt: ${e.toString()}");
      _getGlobalsFromCloud();
    }
  }

  // Set globals for application from Firestore, else default to preset globals
  //
  Future _getGlobalsFromCloud() async {
    //
    // Hide "unable to connect" msg in case user has connected again
    // They probably did if they reach this method
    setState(() {
      _displayMsg = false;
    });
    //
    // Create variables to store data from Firestore
    Map<String, dynamic>? _appGlobals = {};
    Map<String, dynamic>? _userGlobals = {};

    //
    // Get app & user globals, then read, then assign to local app global variables
    try {
      //
      await FirebaseFirestore.instance
          .collection("/config/")
          .doc("globals")
          .get()
          .then((document) {
        //
        _updateProgressIndicator(0.2);

        // Get the data from this document, and pass to function right away
        _setGlobalsFromCloud(document.data());
      });
    } catch (e) {
      print(e.toString());

      // Push forwards regardless
      _isDeviceBarred();
    }
  }

  // Assign local "globals" to the current values that were extracted from the cloud in
  // the above method
  //
  void _setGlobalsFromCloud(Map<String, dynamic>? _appGlobals) {
    //
    // Get application globals according to their cloud counterparts
    globals.maxActivAttempts = _appGlobals!["actattempts"];
    globals.drivExpDays = int.parse(_appGlobals["drivexp"].toString());
    globals.mentExpDays = int.parse(_appGlobals["mentexp"].toString());
    globals.manaExpDays = int.parse(_appGlobals["manaexp"].toString());

    // Set if managers should be able to see "Elevated Activation" option in settings
    String _temp =
        _appGlobals["mgmtact"]; // Get value of "mgmtact" field in Firestore

    // Now check that value and set local Globals "mgmtAct" accordingly (string)
    if (_temp == "true") {
      globals.mgmtAct = true;
      // Default mgmtAct is false, so if it's not "true" we don't need to do anything else
    }

    // Get remote current version to compare to hard-wired current version in Globals.dart
    double _remoteCurrentVersion = double.parse(_appGlobals["currentVersion"]);

    double _remoteBlockVersionBelow =
        double.parse(_appGlobals["blockVersionBelow"]);

    // Get Play Store URL to take user to update this app
    globals.playStoreURL = _appGlobals["playStoreURL"];

    // Is showLoginWithUserPassLink true?
    // If so, set to true. Otherwise do nothing, because showLoginWithUserPassLink is false by default
    if (_appGlobals["showLoginWithUserPassLink"].toString() == "true") {
      globals.showLoginWithUserPassLink = true;
    }

    // Check if the current version of this application, as defined in local Globals, is
    // less than the minimum version of Route Learner that we allow to connect, as defined
    // in Firestore config globals
    if (globals.appVersion < _remoteBlockVersionBelow) {
      //

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UpdateNow()),
          (route) => false);
    }

    // Show "Update Available" banner in Index.dart to compell the user to update?
    // Check remote current version versus local hard wired version
    if (globals.appVersion < _remoteCurrentVersion) {
      globals.showUpdateAppBanner = true;
    }

    print("_data at firestore: $_appGlobals.toString()");

    _updateProgressIndicator(0.3);

    _isDeviceBarred();
  }

  //
  // Check if UID is barred
  //
  Future _isDeviceBarred() async {
    //
    // Get FirebaseAuth UID or apply a null value
    String _uid = (FirebaseAuth.instance.currentUser!.uid != null)
        ? FirebaseAuth.instance.currentUser!.uid.toString()
        : "null_uid";

    print("isDeviceBarred UID = $_uid");

    _updateProgressIndicator(0.4);

    try {
      //
      await FirebaseFirestore.instance
          .collection("barred_uid")
          .doc(_uid)
          .get()
          .timeout(Duration(seconds: 5))
          .then((document) {
        // Check if UID is in barred list
        if (document.exists) {
          // Push to blocked page / display msg
          setState(() {
            _updateStateMsg(
                "Application Locked\n\n${_uid.substring(0, 7).toUpperCase()}");
          });
        } else {
          // Continue activation check sequence

          _isDeviceActivated();
        }
      });
    } on TimeoutException {
      //
      print("isDeviceBarred timeout exception");
      //
      // Move to next step regardless
      _isDeviceActivated();
    } catch (e) {
      //
      // Move to next step regardless
      _isDeviceActivated();
    }
  }

  void _isDeviceActivated() {
    //
    // Create instance to access key that has been saved
    EncryptedSharedPreferences _esp = EncryptedSharedPreferences();

    _updateProgressIndicator(0.5);

    // Try to read key from device
    try {
      _esp.getString("rlkey").then((String _key) {
        //
        // Set key to globals
        globals.key = _key;

        // Call method to read activation level
        _getActivationlevel();
      });
    }
    // Key could not be found?
    catch (e) {
      print("Key could not be found");
      _pushToLoginScreen();
    }
  }

  void _getActivationlevel() {
    //
    // Create instance to access key that has been saved
    EncryptedSharedPreferences _esp = EncryptedSharedPreferences();

    _updateProgressIndicator(0.6);

    // Try to read activation level from device
    try {
      _esp.getString("rllev").then((String _lev) {
        //
        // Set key to globals
        _level = _lev;
        _checkKeyAgainstCloud();
      });
    }
    // Key could not be found?
    catch (e) {
      _updateStateMsg("Something went wrong!\nPlease try again later");
    }
  }

  //
  // Send the key to firestore to see if it exists inside the
  // directory for specified level read from storage
  //
  Future _checkKeyAgainstCloud() async {
    //
    // Query firestore to see if key exists or not
    // Build path using _lev read from storage
    //
    try {
      await FirebaseFirestore.instance
          .collection("users_$_level")
          .doc(globals.key)
          .get()
          .then((document) {
        if (document.exists) {
          // Move to next step, set up globals and move home
          // And pass data inside document to next step
          _updateProgressIndicator(0.7);
          _isDeviceExpired(document.data());
        } else {
          _pushToLoginScreen();
        }
      });
    } catch (e) {
      print("Failed to check key against firestore");
      _pushToLoginScreen();
    }
  }

  //
  // Check if device is expired vs. allowed exp. time from globals (already set)
  Future _isDeviceExpired(Map<String, dynamic>? _data) async {
    //
    //
    try {
      //
      // Get date device was activated on
      String _activDate = _data?["time"];
      // Get activation level
      String _level = _data?["level"];

      // Convert String date to DateTime object
      DateTime _activDateTimeObj = DateTime.parse(_activDate);
      // Get current date
      final _now = DateTime.now();
      // Get how many days its been since activation, set to _difference
      final _daysSinceActivation = _now.difference(_activDateTimeObj).inDays;

      print("DateTime difference = $_daysSinceActivation");

      if (_level == "Driver") {
        //
        // First, set the global int thisActivationAllowedDays to the correct number of days
        // which we allow for them, based on what was assigned to the corresponding global from
        // firestore.
        globals.thisActivationAllowedDays = globals.drivExpDays;

        // Check the difference is less than expiry days
        if (_daysSinceActivation < globals.drivExpDays) {
          // Not expired yet, so proceeed
          _updateProgressIndicator(0.8);
          _setUpGlobalsAndPushToHome(_data);
        } else {
          // Expired, move to reactivation flow
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Expired()),
              (route) => false);
        }
      } else if (_level == "Mentor") {
        //
        // First, set the global int thisActivationAllowedDays to the correct number of days
        // which we allow for them, based on what was assigned to the corresponding global from
        // firestore.
        globals.thisActivationAllowedDays = globals.mentExpDays;

        // Check the difference is less than expiry days
        if (_daysSinceActivation < globals.mentExpDays) {
          // Not expired yet, so proceeed
          _updateProgressIndicator(0.8);
          _setUpGlobalsAndPushToHome(_data);
        } else {
          // Expired, move to reactivation flow
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Expired()),
              (route) => false);
        }
      } else if (_level == "Manager") {
        //
        // First, set the global int thisActivationAllowedDays to the correct number of days
        // which we allow for them, based on what was assigned to the corresponding global from
        // firestore.
        globals.thisActivationAllowedDays = globals.manaExpDays;

        // Check the difference is less than expiry days
        if (_daysSinceActivation < globals.manaExpDays) {
          // Not expired yet, so proceeed
          _updateProgressIndicator(0.8);
          _setUpGlobalsAndPushToHome(_data);
        } else {
          // Expired, move to reactivation flow
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Expired()),
              (route) => false);
        }
      } else {
        _updateProgressIndicator(1.0);
        _setUpGlobalsAndPushToHome(_data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _setUpGlobalsAndPushToHome(Map<String, dynamic>? _data) {
    //
    try {
      // Set globals based on depot from QR donor
      globals.depotName = _data?["depot"];
      globals.level = _data?["level"];

      // Get if we need to show advisory / warning screens on load (first time only)
      // REMEMBER: _data passed to *this* method contains data from the USER Firestore entry
      // We need that, not the "global" "config", which relates to the entire app ecosystem
      globals.loadMsg = _data?["loadmsg"];

      // Manager
      if (_level == "Manager") {
        globals.adminPermission = true;
        _updateProgressIndicator(0.9);
        _pushToHomeScreen();
      }
      // Mentor
      else if (_level == "Mentor") {
        globals.buddyPermission = true;
        _updateProgressIndicator(0.9);
        _pushToHomeScreen();
      }
      // Driver
      else {
        _updateProgressIndicator(0.9);
        _pushToHomeScreen();
      }
    } catch (e) {
      //
      _updateStateMsg("Something went wrong!\nPlease try again later");
    }
  }

  void _pushToLoginScreen() {
    //Timer(Duration(seconds: 1), () {});
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  //
  // Modified method: Before pushing straight to home screen, check if advisory / warning
  // screens should be shown. This is to prevent them from being shown each and every time
  // this app starts.
  //
  void _pushToHomeScreen() async {
    //
    //! Get metadata for home screen banner
    Map<String, dynamic>? _homeScreenMetadata = {};

    _updateProgressIndicator(1.0);

    await FirebaseFirestore.instance
        .collection("homescreen")
        .doc(globals.depotName)
        .get()
        .then((_document) => _homeScreenMetadata = _document.data());

    globals.msiBannerImgURL = _homeScreenMetadata?["headline"]["img"];
    globals.msiBannerTargetURL = _homeScreenMetadata?["headline"]["url"];
    globals.msiActivationGuideURL = _homeScreenMetadata?["actiguide"]["url"];
    //!

    //
    // Show advisory / warning screens? If "yes" (default is yes in globals / Firestore)
    //
    if (globals.loadMsg == "yes") {
      //
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DataNotice()),
          (route) => false);
    }
    // Otherwise, just push to home screen
    else {
      // 100 ms delay to allow "circular loading indicator" to complete loop on fast connections
      // Timer(Duration(milliseconds: 100), () {
      // Home() - make sure!
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
      //  });
    }
  }

  //
  // Method to update progress bar value as authentication runs.
  //
  // NOTE: "if (mounted)" holds setState(). This is because of an exception that happened during
  // the "block version below" check, where we push to a new screen to compell the user to
  // update this app if the local version is less than remote "block if below version".
  //
  // The exception relates to setState being called after we push to a new screen, making the
  // call invalid. So before calling setState (remember this method is called many times in the
  // above code), we check if the state property for the current widget is mounted. If so, then
  // we call setState(). This seems to avoid the exception.
  //
  void _updateProgressIndicator(double _percent) {
    if (mounted) {
      setState(() {
        _percentProgress = _percent;
      });
    }
  }

  void _updateStateMsg(String _msg) {
    //
    if (mounted) {
      _displayMsg = true;
      setState(() {
        _stateMsg = _msg;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
