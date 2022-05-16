import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/datanotice.dart';
import 'package:rl_001/login_page.dart';
import 'package:rl_001/main.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/menupages/showqrcode.dart';
import 'package:rl_001/select_depot.dart';
import 'package:rl_001/webview_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rl_001/globals.dart' as globals;

import '../class/recmon.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  void initState() {
    //
    super.initState();

    RecMon().registerAction("Settings()");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          backgroundColor: GlobalStylePref().appBarBackgroundStyle,
          elevation: GlobalStylePref().appBarElevation,
          // leading:
          //     (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        ),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
          child: Container(
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                //! VISIBLE ONLY IF ADMIN
                Visibility(
                  visible: (globals.adminPermission &&
                      globals.mgmtAct), // visible if adminPermissions is true
                  child: Column(
                    children: [
                      TextStylePref().settingsHeadline("Elevated Activation"),
                      _customSizedBox(),
                      GlobalButtonPref().settingsItem(
                        "Mentor Activation",
                        "Activate a route learning mentor with base activation / application priviliges.",
                        Icons.person,
                        () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ShowQRCode("Mentor"),
                            ),
                          );
                        },
                      ),
                      _customSizedBox(),
                      GlobalButtonPref().settingsItem(
                        "Manager Activation",
                        "Activate a manager with an instance of Route Learner with elevated activation / application priviliges.",
                        Icons.person_add,
                        () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ShowQRCode("Manager"),
                            ),
                          );
                        },
                      ),
                      _customSizedBox(),
                    ],
                  ),
                ),

                TextStylePref().settingsHeadline("Legal"),

                _customSizedBox(),

                //! Terms of use
                GlobalButtonPref().settingsItem(
                  "Terms of Use",
                  "Opens this application's Terms of Use.",
                  Icons.account_balance,
                  () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => WebViewGlobal(
                            "http://xesa.io/tos.html", "Terms and Conditions"),
                      ),
                    );
                  },
                ),

                _customSizedBox(),

                //! Privacy policy
                GlobalButtonPref().settingsItem(
                  "Privacy Policy",
                  "Opens this application's Privacy Policy.",
                  Icons.account_balance,
                  () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => WebViewGlobal(
                            "http://xesa.io/privacy.html", "Privacy Policy"),
                      ),
                    );
                  },
                ),

                _customSizedBox(),

                //! Mobile data usage notice
                GlobalButtonPref().settingsItem(
                  "Mobile Data Usage Notice",
                  "Notice regarding mobile data.",
                  Icons.mobiledata_off,
                  () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => DataNotice()));
                  },
                ),

                _customSizedBox(),

                TextStylePref().settingsHeadline("Application"),

                _customSizedBox(),

                //! VISIBLE IF ADMIN OR BUDDY
                //! Change depot
                Visibility(
                  visible: (globals.adminPermission || globals.buddyPermission),
                  child: GlobalButtonPref().settingsItem(
                    "Select Another Garage",
                    "Change your selected garage. This allows you to see a different list of routes for another garage.",
                    Icons.location_city,
                    () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SelectDepot(),
                        ),
                      );
                    },
                  ),
                ),

                _customSizedBox(),

                //! About application
                GlobalButtonPref().settingsItem(
                  "About Application",
                  globals.appVersionString,
                  Icons.info_rounded,
                  () {
                    _aboutApplication();
                  },
                ),

                _customSizedBox(),

                //! Your data
                GlobalButtonPref().settingsItem(
                  "Your Data",
                  "View the information we hold about this activation of Route Learner. ",
                  Icons.account_circle,
                  () {
                    _showUserInfoModal();
                  },
                ),

                _customSizedBox(),
                //! Deactivate
                GlobalButtonPref().settingsItem(
                  "Deactivate Application",
                  "Remove local activation key and delete anonymous account.",
                  Icons.delete_forever,
                  () => _deactivateDialog(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _aboutApplication() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 340,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Image.asset(
                    //   "images/rlrl1.png",
                    //   scale: 4,
                    // ),

                    // _customSizedBox(),
                    //
                    _customSizedBox(),
                    Image.asset(
                      "images/rlrl1.png",
                      scale: 3,
                    ),

                    _customSizedBox(),
                    _customSizedBox(),

                    TextStylePref()
                        .aboutBoxHeadlineText(globals.appVersionString),

                    _customSizedBox(),

                    TextStylePref().aboutBoxBodyText(globals.appDetailsString),

                    // _customSizedBox(),

                    // Center(
                    //   child: TextButton(
                    //     child: const Text(
                    //       "Close",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _customSizedBox() {
    return const SizedBox(
      height: 15,
    );
  }

  // Clears encrypted shared prefs and deletes user from firestore
  Future _clearSaved() async {
    //
    EncryptedSharedPreferences _esp = EncryptedSharedPreferences();

    print("key ${globals.key}__level ${globals.level}");

    await FirebaseFirestore.instance
        .collection("/users_${globals.level}/")
        .doc(globals.key)
        .delete();

    // await is a must, otherwise code will keep running before clearing has
    // completed.
    await _esp.clear();

    // reset all globals
    globals.key = "nokey";
    globals.adminPermission = false;
    globals.buddyPermission = false;
    globals.level = "nolevel";
    globals.depotName = "nodepot";
  }

  Future _deactivateDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm"),
        content: Text.rich(TextSpan(children: [
          TextSpan(
              text: "Remove activation key & delete anonymous account?\n\n"),
          TextSpan(
              text:
                  "Route Learner will need to be re-activated before it can be used again.",
              style: TextStyle(color: Colors.red.shade800)),
        ])),
        actions: [
          //! Stay
          TextButton.icon(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(Icons.home),
            label: Text(
              "Stay",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          //! Deactivate
          TextButton.icon(
            onPressed: () async {
              // await to make sure everything is cleared before pushing
              await _clearSaved();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => MainArea()),
                  (route) => false);
            },
            icon: Icon(Icons.delete_forever),
            label: Text(
              "Remove",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showUserInfoModal() async {
    //
    Map<String, dynamic>? _userData = {};
    //
    await FirebaseFirestore.instance
        .collection("/users_${globals.level}")
        .doc(globals.key)
        .get()
        .then((document) {
      _userData = document.data();
    });
    //
    // Get the raw activation date as it appears in the users firestore entry
    String _rawDate = _userData?["time"];
    // Split the String in the middle using "space", because there's a space in the middle
    List<String> _date = _rawDate.split(" ");
    // From the resulting list with two items, date and time, we aim for the first element
    // inside of the list (which has just the date) using _date[0], and call .split on it,
    // which works because it's a list of Strings.
    // Then we split the date up into its parts using "-", because "-"" divides the date elements
    // in firestore. Then we can access the individual date elements (month, day, year) using
    // their position in the list/array.
    List<String> _dateElements = _date[0].split("-");
    //
    // Get number of activations this user has so far from their data in firestore
    int _numberOfActivations = _userData?["actnum"];
    String _garage = _userData?["depot"];
    String _finalUID = _userData?["uid"];

    setState(() {});

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: GlobalStylePref().mainBackgroundStyle,
            width: MediaQuery.of(context).size.width,
            padding: MediaQuery.of(context).viewInsets,
            //height: 450,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                      ),
                      const Text(
                        "Your Data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("images/closemodal.png"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    height: 2,
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("Activation ID:"),
                  TextStylePref().textRouteInfoItem(_finalUID.toUpperCase()),
                  const SizedBox(
                    height: 15,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("Garage"),
                  TextStylePref().textRouteInfoItem(_garage),
                  const SizedBox(
                    height: 15,
                  ),
                  TextStylePref()
                      .textRouteInfoItemHeadline("Date of Activation:"),
                  TextStylePref().textRouteInfoItem(
                      "${_dateElements[2]}/${_dateElements[1]}/${_dateElements[0]}"),
                  const SizedBox(
                    height: 15,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("Activated As:"),
                  TextStylePref().textRouteInfoItem(globals.level),
                  const SizedBox(
                    height: 15,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("Users Activated:"),
                  (globals.adminPermission || globals.buddyPermission)
                      ? TextStylePref()
                          .textRouteInfoItem(_numberOfActivations.toString())
                      : TextStylePref().textRouteInfoItem("N/A"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
