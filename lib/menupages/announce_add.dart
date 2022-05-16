import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

import 'announce.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  //
  final _titleController = TextEditingController();
  final _annController = TextEditingController();
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("New Announcement", context),
        drawer: const SideMenu(),
        // Show floatActButton ONLY if adminPermission is true, else show empty Container

        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // TextStylePref().midWhite16NormalCenter(
                //     "Create a new announcement below.\n" +
                //         "All posts must be professional, and respect the terms of use."),
                // SizedBox(
                //   height: 10,
                // ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Title...",
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
                // TextStylePref().midWhite16NormalCenter("Announcement:"),
                // SizedBox(
                //   height: 10,
                // ),
                TextField(
                  controller: _annController,
                  maxLines: 10,
                  decoration: const InputDecoration(
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
                SizedBox(
                  height: 20,
                ),
                TextStylePref().midWhite16NormalCenter(_errorMsg),
                SizedBox(
                  height: 20,
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
                      // Then, move back to Announcements home page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Announcements(),
                        ),
                      );
                    } else {
                      setState(() {
                        _errorMsg = "You must enter a Title and Announcement";
                      });
                      return;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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
        "uid": "null",
      },
    };
    FirebaseFirestore.instance
        .collection("announce")
        .doc("announcement")
        .update(_dataToSend);

    //
  }
}
