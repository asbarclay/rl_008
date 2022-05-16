import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/widgets/widget_custom.dart';

import '../class/recmon.dart';

class ContentLanding extends StatefulWidget {
  ContentLanding(this._routeNumber, {Key? key}) : super(key: key);

  // For use in constructing the database query
  final String _routeNumber;

  @override
  _ContentLandingState createState() => _ContentLandingState();
}

class _ContentLandingState extends State<ContentLanding> {
  @override
  void initState() {
    super.initState();

    RecMon().registerAction("ContentLanding: ${widget._routeNumber}");
  }

  @override
  Widget build(BuildContext context) {
    //
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar()
            .appBar("${widget._routeNumber} Route Learning", context),
        drawer: const SideMenu(),
        floatingActionButton: Construct()
            .floatingActionButtonRouteInfo(widget._routeNumber, context),
        body: Center(
          child: FutureBuilder(
            future: _fsi.doc("routes/" + globals.depotName).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                print(
                    "depot name=${globals.depotName} & route number = ${widget._routeNumber}");

                List contentList = [];

                try {
                  // Access the map inside of a map to get the list of available content for the route
                  data[widget._routeNumber]["content"].forEach((key, value) {
                    contentList.add(key);
                  });

                  //print("TRY: ${data["Ferry"]["Videos"].toString()}"); //! Access map inside of map

                  return Construct().buildButtonContentList(
                      contentList,
                      globals.depotName,
                      widget._routeNumber,
                      globals.depotRoutesMap,
                      context);
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
}
