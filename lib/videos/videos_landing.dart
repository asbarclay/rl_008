import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/errors.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../class/recmon.dart';
import '../globals.dart' as globals;

class VideosLanding extends StatefulWidget {
  VideosLanding({Key? key}) : super(key: key);

  @override
  _VideosLandingState createState() => _VideosLandingState();
}

class _VideosLandingState extends State<VideosLanding> {
  @override
  void initState() {
    //
    super.initState();

    RecMon().registerAction("VideosLanding");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //extendBodyBehindAppBar: true,
        appBar: GlobalAppBar().appBar("Videos", context),
        drawer: const SideMenu(),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("videos/")
              .doc("vidlist")
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              //
              Map<String, dynamic> _vidMap =
                  snapshot.data!.data() as Map<String, dynamic>;

              return _buildVideoList(_vidMap);
            }
            if (snapshot.hasError) {
              return GlobalErrorMessages().futureBuilderConnectionError();
            }
            // Return while we wait for either error or data
            return Center(
              child: WidgetCustom().circularProgress1(),
            );
          },
        ),
      ),
    );
  }

  // Generates a listview builder which has all the videos available in vidlist firestore doc
  //
  ListView _buildVideoList(Map<String, dynamic> _vidMap) {
    //
    List _vidListItems = [];

    // Extract the *title* as a *key*, which is the root of each item in the Firestore vidlist map
    // Title                        <-- title
    //    "url" : "http://"...      <-- map item
    //    "title" : "Title"         <-- map item
    _vidMap.forEach((key, value) {
      //
      _vidListItems.add(key);
    });

    // Sort list alphabetically
    _vidListItems.sort((a, b) => a.toString().compareTo(b.toString()));

    // Build each video thumbnail, use inkwell to access onTap
    //
    return ListView.builder(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      itemCount: _vidListItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: InkWell(
            onTap: () {
              // Using URL launcher for now until I can set up the video playback page with YouTube API
              launch(_vidMap[_vidListItems[index]]["url"].toString());
              // Go to video player page
              // Pass video title and associated URL from _vidMap
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => VideoPlayer(
              //       _vidMap[_vidListItems[index]]["url"]
              //           .toString(), // Obtain the URL from map using list as index
              //       _vidListItems[index]
              //           .toString(), // Obtain title from list at current index from listview builder
              //     ),
              //   ),
              // );
            },
            child: Container(
              // For shadow
              decoration: GlobalStylePref().containerRadiusShadow,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child:
                    // CachedNetworkImage provides a loading placeholder (we use SpinKit)
                    // as well as an error icon in case of failure
                    CachedNetworkImage(
                  imageUrl: _vidMap[_vidListItems[index]]["img"],
                  placeholder: (context, url) => SpinKitThreeBounce(
                    color: ColorGlobals().iconColor1(),
                  ),
                  errorWidget: (context, url, error) =>
                      GlobalErrorMessages().futureBuilderConnectionError(),
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
