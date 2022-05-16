import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/content/content_format.dart';
import 'package:rl_001/content/content_maps.dart';
import 'package:rl_001/content/content_video.dart';
import 'package:rl_001/content/view_pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:rl_001/globals.dart' as globals;

import 'color_globals.dart';

class Construct {
  //
  Widget bottomNavBar() {
    return BottomNavigationBar(
      //
      items: const <BottomNavigationBarItem>[
        //
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],

      selectedItemColor: ColorGlobals().abellioRed(),
      backgroundColor: Colors.white,

      onTap: _onBottomNavBarButtonTap,
    );
  }

  void _onBottomNavBarButtonTap(int index) {
    //
  }

  //
  // Build list of standard Route Learner buttons, for navigating to the next step
  // in selecting content to view.
  //
  // Method returns a ListView, takes two lists with key and value from Firestore,
  // as well as BuildContext from the calling Build method.
  //
  // Returns a custom GlobalButtonPref midButton set to text == key at index number.
  //
  // Navigator pushes to named route obtained from value list.
  //
  ListView buildButtonContentList(List contentOption, String depotName,
      String routeNumber, Map _dataMap, BuildContext context) {
    //
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: contentOption.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child:
              GlobalButtonPref().midButton(contentOption[index].toString(), () {
            try {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (builder) => ContentFormat(
                            routeNumber,
                            depotName,
                            contentOption[index].toString(),
                            _dataMap,
                          )));
              return;
            } catch (e) {
              print(e.toString());
            }
          }),
        );
      },
    );
  }

  ListView buildButtonFormatList(
      List contentFormat,
      String _contentOption,
      String _depotName,
      String _routeNumber,
      Map _dataMap,
      BuildContext context) {
    //
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: contentFormat.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child:
              GlobalButtonPref().midButton(contentFormat[index].toString(), () {
            try {
              if (contentFormat[index] == "Videos") {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) => ContentVideo(
                      _routeNumber,
                      _depotName,
                      contentFormat[index].toString(),
                      _contentOption,
                      _dataMap,
                    ),
                  ),
                );
              } else if (contentFormat[index] == "Maps") {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) => ContentMaps(
                      _routeNumber,
                      _depotName,
                      contentFormat[index].toString(),
                      _contentOption,
                      _dataMap,
                    ),
                  ),
                );
              } else if (contentFormat[index] == "PDF Guide") {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) => ViewPDF(
                      _dataMap[_routeNumber]["content"][_contentOption]
                          ["PDF Guide"]["url"],
                      _routeNumber,
                    ),
                  ),
                );
              }

              return;
            } catch (e) {
              print(e.toString());
            }
          }),
        );
      },
    );
  }

  Widget floatingActionButtonRouteInfo(
      String _routeNumber, BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: GlobalStylePref().mainBackgroundStyle,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Title + close button on top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                      ),
                      const Text(
                        "Route Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                    height: 20,
                  ),
                  const Divider(
                    height: 2,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("Driver Manager"),
                  TextStylePref().textRouteInfoItem(
                    "${globals.depotRoutesMap[_routeNumber]["info"]["dm"].toString()}",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextStylePref().textRouteInfoItemHeadline("E-mail Address"),
                  TextStylePref().textRouteInfoItem(
                    "${globals.depotRoutesMap[_routeNumber]["info"]["email"].toString()}",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextStylePref()
                      .textRouteInfoItemHeadline("iBus Telephone Number"),
                  TextStylePref().textRouteInfoItem(
                    "${globals.depotRoutesMap[_routeNumber]["info"]["ibus"].toString()}",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 2,
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Call iBus number in firestore for this route
                      GlobalButtonPref()
                          .smallButton("Call ${_routeNumber} iBus", () {
                        launch("tel:" +
                            globals.depotRoutesMap[_routeNumber]["info"]["ibus"]
                                .toString());
                        Navigator.pop(context);
                      }),
                      // Email DM from email from firestore for this route
                      GlobalButtonPref().smallButton("E-mail DM", () {
                        launch("mailto:" +
                            globals.depotRoutesMap[_routeNumber]["info"]
                                    ["email"]
                                .toString());
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      splashColor: ColorGlobals().buttonTextColor1(),
      backgroundColor: ColorGlobals().buttonTextColor1(),
      child: const Icon(Icons.info_outlined, size: 55, color: Colors.white),
    );
  }

  // Floating action button that appears for users who have been activated as admin users,
  // and can add a comment.
  Widget floatingActionButtonAddAnnouncement(BuildContext context) {
    final _titleController = TextEditingController();
    final _annController = TextEditingController();
    String _errorMsg = "";

    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: GlobalStylePref().mainBackgroundStyle,
              width: MediaQuery.of(context).size.width,
              padding: MediaQuery.of(context).viewInsets,
              height: 450,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Title + close button on top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                      ),
                      TextStylePref()
                          .textRouteInfoItemHeadline("New Announcement"),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("images/closemodal.png"),
                      )
                    ],
                  ),
                  // Fields
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Title...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // TextStylePref().midWhite16NormalCenter("Announcement:"),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  TextField(
                    controller: _annController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Announcement...",
                      filled: true,
                      fillColor: Colors.white,
                      // All this border crap below is to try and stop the border of the
                      // text box from changing when the user taps in / out of the text field
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //
                  // Submit button
                  GlobalButtonPref().midButton(
                    "Submit",
                    () async {
                      //
                      // Check if anything has been entered into the text fields
                      if (_titleController.text.isNotEmpty &&
                          _annController.text.isNotEmpty) {
                        //
                        // If both have text, call _postAnnounce, and pass text strings
                        // to send to FireStore
                        await _postAnnouncement(
                            _titleController.text, _annController.text);

                        //
                        // Then, close modal sheet
                        Navigator.pop(context);

                        _annController.text = "";
                        _titleController.text = "";
                      } else {
                        _errorMsg = "error msg";
                        return;
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      splashColor: ColorGlobals().abellioRed(),
      backgroundColor: ColorGlobals().iconColor1(),
      child: Icon(
        Icons.edit,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Future _postAnnouncement(String _title, String _body) async {
    //
    // var now = DateTime.now();
    // var date = DateTime(now.day, now.month, now.year);

    // print(date.toString());

    String sDate = formatDate(DateTime.now(), [
      "dd",
      "-",
      "mm",
      "-",
      "yyyy",
      "-",
      "HH",
      "-",
      "nn",
      "-",
      "ss",
    ]);

    Map<String, Object> _dataToSend = {
      sDate.toString(): {
        "title": _title,
        "body": _body,
        "uid": (FirebaseAuth.instance.currentUser!.uid != null)
            ? FirebaseAuth.instance.currentUser!.uid
            : "null",
      },
    };
    FirebaseFirestore.instance
        .collection("announce")
        .doc("announcement")
        .update(_dataToSend);

    //
  }

  // Future<bool> rrCodeDialog(BuildContext context, String? _code) async {
  //   //
  //   return await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Text(
  //           _code!,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //             color: Colors.black,
  //             fontFamily: "Consolas",
  //             fontWeight: FontWeight.bold,
  //             fontSize: 25,
  //           ),
  //         ),
  //       ),
  //       actionsAlignment: MainAxisAlignment.center,
  //       //contentPadding: EdgeInsets.all(20.0),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text(
  //             "Close",
  //             style: TextStyle(
  //               fontSize: 20,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


//   // Floating action button that appears for users who have been activated as admin users,
//   // and can add a comment.
//   Widget floatingActionButtonAddAnnouncement(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => AddAnnouncement()));
//       },
//       splashColor: GlobalStylePref().purpleStandard(),
//       backgroundColor: GlobalStylePref().lightPurpleStandard(),
//       child: Icon(
//         Icons.edit,
//         size: 35,
//         color: GlobalStylePref().purpleDarker(),
//       ),
//     );
//   }
// }

