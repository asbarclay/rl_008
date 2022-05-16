import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../globals.dart' as globals;

class RecMon {
  //!
  //! DO NOT CALL THIS METHOD PRIOR TO GLOBALS BEING SET UP AND ASSIGNED!!!
  //!
  Future registerAction(String _caller) async {
    //

    try {
      //
      // Record activity as Map, with current time as title
      // Create the map
      //
      //
      Map<String, dynamic> _dataToRegister = {
        DateTime.now().toString(): {
          "method": _caller,
        },
      };

      // Test to see if a document for this UID exists already
      await FirebaseFirestore.instance
          .collection("/activity/")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get()
          .then((document) async {
        if (document.exists) {
          // Set data
          await FirebaseFirestore.instance
              .collection("/activity/")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .update(_dataToRegister);
        } //
        else // Create new document
        {
          await FirebaseFirestore.instance
              .collection("/activity/")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set(_dataToRegister);
        }
      });
      //
    } catch (e) {
      //
      // Error
      print("Error registerAction: ${e.toString()}");
      return;
    }
  }

  Future registerActionFull(String _caller) async {
    //

    try {
      //
      // Discover which platform we are on
      //
      String _platformName = "null";

      if (Platform.isAndroid) {
        _platformName = "Android";
      } else if (Platform.isIOS) {
        _platformName = "iOS";
      }

      //
      // Record activity as Map, with current time as title
      // Create the map
      //
      //
      Map<String, dynamic> _dataToRegister = {
        DateTime.now().toString(): {
          "UID": FirebaseAuth.instance.currentUser!.uid.toString(),
          "key" : globals.key,
          "method": _caller,
          "time": DateTime.now().toString(),
          "depot": globals.depotName,
          "level": globals.level,
          "clientVersion": globals.appVersionString,
          "clientOS": _platformName,
        },
      };

      // Test to see if a document for this UID exists already
      await FirebaseFirestore.instance
          .collection("/activity/")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get()
          .then((document) async {
        if (document.exists) {
          // Set data
          await FirebaseFirestore.instance
              .collection("/activity/")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .update(_dataToRegister);
        } //
        else // Create new document
        {
          await FirebaseFirestore.instance
              .collection("/activity/")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set(_dataToRegister);
        }
      });
      //
    } catch (e) {
      //
      // Error
      print("Error registerActionFull: ${e.toString()}");
      return;
    }
  }
}
