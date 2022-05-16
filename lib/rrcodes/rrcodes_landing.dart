import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/globals.dart' as globals;
import 'package:rl_001/widgets/widget_custom.dart';

class RRCodesLanding extends StatefulWidget {
  RRCodesLanding(this._routeNumber, {Key? key}) : super(key: key);

  String _routeNumber;

  @override
  _RRCodesLandingState createState() => _RRCodesLandingState();
}

class _RRCodesLandingState extends State<RRCodesLanding> {
  //
  String _codeMsg = "Tap To Reveal Code";

  @override
  Widget build(BuildContext context) {
    //
    //! Get instance of firestore
    final _fsi = FirebaseFirestore.instance;

    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar()
            .appBar("${widget._routeNumber} Rest Room Codes", context),
        drawer: SideMenu(),
        body:
            //! FutureBuilder for getting the list of codes

            FutureBuilder(
          // Get list of rrcodes for this depot
          future: _fsi.doc("rrcodes/" + globals.depotName).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> _dbData =
                  snapshot.data!.data() as Map<String, dynamic>;

              List _codesListNodes = [];

              try {
                //
                // Extract the nodes, which act as titles for each rest room
                // These nodes have sub fields
                // We will use these nodes as indexes, to access the values under them
                // inside of listview builder in _buildCodesList()
                _dbData[widget._routeNumber].forEach((key, value) {
                  _codesListNodes.add(key);
                });

                //! Call method with GridView.builder
                return _buildCodesList(
                    _codesListNodes, _dbData[widget._routeNumber]);
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

      //
    );
  }

  Widget _buildCodesList(List _node, Map _data) {
    //
    int _selectedIndex = 0;

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 15),
      itemCount: _node.length,
      itemBuilder: (BuildContext context, int index) {
        _selectedIndex = index;

        return Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 5, left: 20, right: 20),
          child: Container(
            decoration: GlobalStylePref().containerRadiusShadow,
            // Padding for actual contents inside container
            child: Padding(
              padding: const EdgeInsets.all(20),
              // Main row that holds play image on the left and
              // column with details on the right
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // Make title and description align left
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextStylePref().contentItemHeadline(_node[index].toString()),
                  // Divider(
                  //   height: 10,
                  //   color: GlobalStylePref().purpleStandard(),
                  // ),
                  // Code
                  // Text.rich allows us to have two different styles in the same
                  // text widget

                  SizedBox(
                    height: 10,
                  ),

                  InkWell(
                    onTap: () {
                      _rrCodeDialog(_data[_node[index]]["code"]);
                    },
                    child: Container(
                      width: double.infinity,
                      //color: Colors.purple.shade300,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade600,
                            Colors.grey.shade500,
                          ],
                        ),
                      ),
                      child: TextStylePref()
                          .midWhite16NormalCenter("Tap Here To Reveal Code"),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Center(
                  //   child: Text.rich(
                  //     TextSpan(
                  //       children: [
                  //         TextSpan(
                  //           text: "Code: ",
                  //           style: TextStyle(
                  //             color: Colors.grey.shade700,
                  //             fontFamily: "OpenSans",
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: _data[_node[index]]["code"].toString(),
                  // style: const TextStyle(
                  //   color: Colors.black,
                  //   fontFamily: "Consolas",
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 16,
                  // ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   height: 10,
                  //   color: GlobalStylePref().purpleStandard(),
                  // ),

                  (_data[_node[index]]["type"] != null)
                      ? Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Facilities: ",
                                style: TextStyle(
                                  //
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _data[_node[index]]["type"].toString(),
                                style: const TextStyle(
                                  fontFamily: "OpenSans",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  // If field is not null, display it, otherwise display empty container
                  (_data[_node[index]]["loc"] != null)
                      ? Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Location: ",
                                style: TextStyle(
                                  //
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _data[_node[index]]["loc"].toString(),
                                style: const TextStyle(
                                  fontFamily: "OpenSans",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  // Description
                  (_data[_node[index]]["desc"] != null)
                      ? Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Instructions: ",
                                style: TextStyle(
                                  //
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _data[_node[index]]["desc"].toString(),
                                style: const TextStyle(
                                  fontFamily: "OpenSans",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _rrCodeDialog(String _code) {
    //
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "For ladies only facility codes, please call iBus.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorGlobals().abellioRed()),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Consolas",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              )
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        //contentPadding: EdgeInsets.all(20.0),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
