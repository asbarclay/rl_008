import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';
import 'class/recmon.dart';
import 'globals.dart' as globals;

class RRCodes extends StatefulWidget {
  const RRCodes({Key? key}) : super(key: key);

  @override
  _RRCodesState createState() => _RRCodesState();
}

class _RRCodesState extends State<RRCodes> {
  //

  Map dataMap = {"error": "error"};
  //bool _showLadiesOnlyBanner = true;

  @override
  void initState() {
    //
    super.initState();

    RecMon().registerAction("RRCodes()");
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    //! Get instance of firestore
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Access Codes", context),
        drawer: const SideMenu(),
        body: FutureBuilder(
          // Construct path to route list for depot selected in depot selection screen / saved in shared prefs
          // dbPath was null checked in _getDepot setState
          future: _fsi.doc("rrcodes/" + globals.depotName).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> _dbData =
                  snapshot.data!.data() as Map<String, dynamic>;

              // Assign the full data map from Firestore with all fields from routes/"DEPOT"/
              // to global map
              globals.depotRoutesMap = _dbData;

              List _routesList = [];

              try {
                _dbData.forEach((key, value) {
                  _routesList.add(key);
                });

                //! Call method with GridView.builder
                return _buildRoutes(_routesList);
              } catch (e) {
                return GlobalErrorMessages().futureBuilderConnectionError();
              }
            }
            if (snapshot.hasError) {
              return Center(
                // Display message if connection fails
                child: GlobalErrorMessages().futureBuilderConnectionError(),
              );
            }
            return Center(
              child: WidgetCustom().circularProgress1(),
            );
          },
        ),

        //! FutureBuilder for getting the list of routes from the server

        //
      ),
    );
  }

  GridView _buildRoutes(List _routes) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _routes.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GlobalButtonPref()
              .mainScreenButton(_routes, index, "rrcodes", context);
        });
  }

  // Future<bool> leaveDialog(BuildContext context) async {
  //   //
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text(
  //             "Exit Route Learner?",
  //             textAlign: TextAlign.center,
  //           ),
  //           actionsAlignment: MainAxisAlignment.center,
  //           //contentPadding: EdgeInsets.all(20.0),
  //           actions: [
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context, false),
  //               icon: Icon(Icons.home),
  //               label: Text(
  //                 "Stay",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               icon: Icon(Icons.exit_to_app_outlined),
  //               label: Text(
  //                 "Exit",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false);
  // }
}
