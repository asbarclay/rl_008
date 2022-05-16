import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';
import 'package:url_launcher/url_launcher.dart';
import 'class/recmon.dart';
import 'globals.dart' as globals;

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  //
  Map dataMap = {"error": "error"};

  @override
  void initState() {
    //
    RecMon().registerAction("Index()");

    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    //! Get instance of firestore
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      // Try to intercept the system back gesture to prevent user going back too far
      // WillPopScope holds Scaffold as a child
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("${globals.depotName} Routes", context),
        drawer: const SideMenu(),
        body: FutureBuilder(
          // Construct path to route list for depot selected in depot selection screen / saved in globals
          // dbPath was null checked in _getDepot setState
          future: _fsi.doc("routes/" + globals.depotName).get(),
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

                // Call method with GridView.builder
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
      ),
    );
  }

  GridView _buildRoutes(List _routes) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _routes.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GlobalButtonPref()
              .mainScreenButton(_routes, index, "content", context);
        });
  }

  Future<bool> leaveDialog(BuildContext context) async {
    //
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Exit Route Learner?",
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            //contentPadding: EdgeInsets.all(20.0),
            actions: [
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
              SizedBox(
                width: 20,
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(Icons.exit_to_app_outlined),
                label: Text(
                  "Exit",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false);
  }
}
