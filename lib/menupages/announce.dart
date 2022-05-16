import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';

import '../class/recmon.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  void initState() {
    //
    super.initState();

    RecMon().registerAction("Announcements()");
  }

  @override
  Widget build(BuildContext context) {
    //
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Announcements", context),
        drawer: const SideMenu(),
        // Show floatActButton ONLY if adminPermission is true, else show empty Container
        floatingActionButton:
            (globals.adminPermission || globals.buddyPermission)
                ? Construct().floatingActionButtonAddAnnouncement(context)
                : Container(),
        //
        // Using StreamBuilder in this case, .snapshots() instead of .get()
        body: StreamBuilder(
          stream: _fsi.doc("/announce/announcement").snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> _dataMap =
                  snapshot.data!.data() as Map<String, dynamic>;

              // List valList = [];
              List _dateList = [];

              // Extract date from the node (key) of each entry
              // --> 11-01-2029-12-34-33 : {}
              // Extract that, and use that in _buildAnnou as the key to access the subnodes
              _dataMap.forEach((key, value) {
                _dateList.add(key);
              });

              print(_dateList.toString());

              // Sorts entries according to date (string). Reverses the order (b compare to a)
              // Uses basic "sort" method on the _dateList.
              // Compares "b" to "a" to reverse order. Otherwise comparing
              // "a" to "b" would order it as "newest entry last", so to speak.
              // For us, that means entry with the oldest date would be on top,
              // latest date (posted date) would be last.
              _dateList.sort((a, b) {
                //
                return b.toString().compareTo(a.toString());
              });

              // Then use sorted _dateList
              return _buildAnnou(_dateList, _dataMap);
            }
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error,
                        color: Colors.black,
                        size: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Error fetching data\nCheck your connection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "OpenSans",
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
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

  // List _dateList contains the main nodes in a list, which can be accessed using [index].
  // _dataMap contains the entire map of announcements + nodes, returned from Firestore.
  //
  // First, use _dateList to pick a node in the _dataMap, as _dataMap[dateList[index]], where
  // we can directly access the map's data for that particular node.
  //
  Widget _buildAnnou(List _dateList, Map _dataMap) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _dateList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: GlobalStylePref().containerRadiusShadow,
            child: Card(
              color: const Color.fromRGBO(255, 255, 255, 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              elevation: 0,
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  _dataMap[_dateList[index]]["title"].toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorGlobals().textCardTitle(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Body of announcement
                // Splits into two lines. First line is the actual announcement
                // Next line is the date (from _dateList at [index]), to String
                // We use substring to only show the date
                // Because Firestore date has dashes "-", we replace those with "/"
                // using replaceAll.
                subtitle: Text(
                  "${_dataMap[_dateList[index]]["body"].toString()}\n\n${_dateList[index].toString().substring(0, 10).replaceAll("-", "/")}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                trailing: (_dataMap[_dateList[index]]["uid"] ==
                        FirebaseAuth.instance.currentUser!.uid.toString())
                    ? IconButton(
                        onPressed: () {
                          _deleteAnnouncement(_dateList[index]);
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      )
                    : Container(
                        width: 1,
                        height: 1,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future _deleteAnnouncement(String _date) async {
    //
    await FirebaseFirestore.instance
        .collection("announce")
        .doc("announcement")
        .update({_date: FieldValue.delete()});
  }
}
