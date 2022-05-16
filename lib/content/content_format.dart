import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';

import '../class/recmon.dart';

class ContentFormat extends StatefulWidget {
  ContentFormat(
      this._routeNumber, this._depotName, this._contentOption, this._dataMap,
      {Key? key})
      : super(key: key);

  // For use in constructing the database query
  String _routeNumber;
  String _depotName;
  String _contentOption;
  Map _dataMap;

  @override
  _ContentFormatState createState() => _ContentFormatState();
}

class _ContentFormatState extends State<ContentFormat> {
  @override
  void initState() {
    super.initState();

        RecMon().registerAction("ContentLanding: ${widget._routeNumber} ${widget._contentOption}");

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
            .appBar("${widget._routeNumber} ${widget._contentOption}", context),
        floatingActionButton: Construct()
            .floatingActionButtonRouteInfo(widget._routeNumber, context),
        drawer: const SideMenu(),
        body: Center(
          child: FutureBuilder(
            future: _fsi.doc("routes/" + widget._depotName).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                print(
                    "content option=${widget._contentOption} & route number = ${widget._routeNumber}");

                List contentFormat = [];

                try {
                  // Access the map inside of a map to get the content format (video, maps, etc)
                  // and extract the values into contentFormat list
                  data[widget._routeNumber]["content"][widget._contentOption]
                      .forEach((key, value) {
                    contentFormat.add(key);
                  });

                  //print("TRY: ${data["Ferry"]["Videos"].toString()}"); //! Access map inside of map

                  //TODO: NEED TO SPAWN LIST OF FORMATS FROM DATABASE. EXTRACT FORMATS FOR THIS ROUTE OPTION,
                  //TODO: THEN IMPLEMENT A CONSTRUCT METHOD TO CREATE THE LIST OF BUTTONS (VIDEO, MAPS, ETC)
                  //TODO: SO FAR HAVE CREATED A NEW METHOD BUTTONFORMATLIST BELOW, FIX IT AND IMPLEMENT IT CORRECTLY

                  return Construct().buildButtonFormatList(
                      contentFormat,
                      widget._contentOption,
                      widget._depotName,
                      widget._routeNumber,
                      widget._dataMap,
                      context);
                  //
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
}
