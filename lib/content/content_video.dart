import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rl_001/class/construct.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentVideo extends StatefulWidget {
  ContentVideo(this._routeNumber, this._depotName, this._contentFormat,
      this._contentOption, this._dataMap,
      {Key? key})
      : super(key: key);

  // For use in constructing the database query
  final String _routeNumber;
  final String _depotName;
  final String _contentFormat;
  final String _contentOption;
  final Map _dataMap;
  @override
  _ContentVideoState createState() => _ContentVideoState();
}

class _ContentVideoState extends State<ContentVideo> {
  @override
  void initState() {
    print(
        "conFormat=${widget._contentFormat}  conOption=${widget._contentOption}");
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
        appBar: GlobalAppBar().appBar(
            "${widget._routeNumber} ${widget._contentOption} ${widget._contentFormat}",
            context),
        drawer: const SideMenu(),
        floatingActionButton: Construct()
            .floatingActionButtonRouteInfo(widget._routeNumber, context),
        body: Center(
          child: FutureBuilder(
            future: _fsi.doc("routes/" + widget._depotName).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                print(
                    "depot name=${widget._depotName} & route number = ${widget._routeNumber}");

                List contentTitle = [];
                List contentDetails = [];

                try {
                  // Access the map inside of a map to get the list of videos for selected
                  // content option, which is known via String contentOption
                  // Remember: key contains the title of the video / map, value contains the URL
                  data[widget._routeNumber]["content"][widget._contentOption]
                          ["Videos"]
                      .forEach((key, value) {
                    contentTitle.add(key); // Add key, which contains the title
                    print(key);
                  });

                  data[widget._routeNumber]["content"][widget._contentOption]
                          ["Videos"]
                      .forEach((key, value) {
                    contentDetails
                        .add(value); // Add value, which contains the URL
                    print(value);
                  });

                  // implement something to draw content on screen
                  return _buildInterface(contentTitle, contentDetails);
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

  // Each main node (content) title is in title, and detailsMap has all the data for that node
  // such as description, image URL, etc.
  ListView _buildInterface(List node, List detailsMap) {
    //
    return ListView.builder(
      shrinkWrap: true,
      itemCount: node.length,
      padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20, right: 20),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 20, left: 0, right: 0),
          // make container clickable
          child: InkWell(
            hoverColor: Colors.black,
            onTap: () {
              launchVideo(detailsMap[index]["url"].toString());
            },
            borderRadius: BorderRadius.circular(10),
            // Actual white container
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  // Add shadow to the main background container
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 3),
                    blurRadius: 10,
                    spreadRadius: 0.1,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              // Padding for actual contents inside container
              child: Padding(
                padding: const EdgeInsets.all(20),
                // Main row that holds play image on the left and
                // column with details on the right
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Set play image to be in the middle, regardless of how large the
                  // column on the right becomes
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Play button image on the left
                    Image.asset(
                      "images/msi_vid.png",
                      scale: 9,
                    ),
                    // Spacer to the right of the play button image
                    SizedBox(
                      width: 20,
                    ),
                    // We use expanded to keep the text inside the below column from
                    // overflowing
                    Expanded(
                      // Column to the right of the play button image
                      // has content title and description
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // Make title and description align left
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          TextStylePref().contentItemHeadline(
                            "${node[index].toString()}",
                          ),
                          // Description
                          (detailsMap[index]["desc"] != null)
                              ? Text(
                                  "${detailsMap[index]["desc"].toString()}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                )
                              : Text(""),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future launchVideo(String url) async {
    await launch(url);
  }
}
