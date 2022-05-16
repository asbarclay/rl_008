import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/datanotice.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'globals.dart' as globals;
import 'widgets/widget_custom.dart';

class SelectDepot extends StatefulWidget {
  const SelectDepot({Key? key}) : super(key: key);

  @override
  State<SelectDepot> createState() => _SelectDepotState();
}

class _SelectDepotState extends State<SelectDepot> {
  //
  final _fsi = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Select Your Garage", context),
        body: Center(
          child: FutureBuilder(
            future: _fsi.doc("locations/garages").get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                List keyList = [];
                List valList = [];

                try {
                  data.forEach((key, value) {
                    keyList.add(key);
                  });

                  data.forEach((key, value) {
                    valList.add((value));
                  });

                  // Call method to create list of buttons using key:value from firestore
                  return _depotButtonList(keyList, valList, context);
                  //
                } catch (e) {
                  return GlobalErrorMessages().futureBuilderConnectionError();
                }
              }
              if (snapshot.hasError) {
                return GlobalErrorMessages().futureBuilderConnectionError();
              }
              return Center(
                child: WidgetCustom().circularProgress1(),
              );
            },
          ),
        ),
      ),
    );
  }

  // Returns a listview, which spawns the list of buttons with the name of each
  // garage, allowing the user to select a garage. Also calls _writePreferences
  // to save the name of the garage to SharedPrefs, and use it in future pages.
  ListView _depotButtonList(List key, List value, BuildContext context) {
    //
    return ListView.builder(
      shrinkWrap: true,
      itemCount: key.length,
      itemBuilder: (context, int index) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child: GlobalButtonPref().midButton(key[index].toString(), () async {
            try {
              // Write selected garage to storage via _writePreferances method below
              // The depot name inside of 'key' at the index position will be written.
              await _setNewDepot(key[index]);

              // Go to the page name inside the value passed to this method from firestore
              // Use pushReplacementNamed because it accepts a string (from firestore, which
              // we access via value[index].
              Navigator.pushReplacementNamed(context, value[index].toString());
            } catch (e) {
              print(e.toString());
            }
          }),
        );
      },
    );
  }

  // Write depot name to storage
  Future _setNewDepot(String _depot) async {
    //
    // Change saved depot in user data
    try {
      await FirebaseFirestore.instance
          .collection("/users_${globals.level}/")
          .doc(globals.key)
          .update({"depot": _depot});
    } catch (e) {
      print(e.toString());
      return;
    }

    // Save depot name as global variable for use in other pages
    globals.depotName = _depot;
  }
}
