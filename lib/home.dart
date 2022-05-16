import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/recmon.dart';
import 'package:rl_001/content/view_pdf.dart';
import 'package:rl_001/index.dart';
import 'package:rl_001/menupages/announce.dart';
import 'package:rl_001/menupages/showqrcode.dart';
import 'package:rl_001/menupages/type_training.dart';
import 'package:rl_001/rrcodes.dart';
import 'package:rl_001/videos/videos_landing.dart';
import 'package:rl_001/webview_global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'class/stylepref.dart';
import 'globals.dart' as globals;
import 'menupages/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //

  @override
  void initState() {
    super.initState();
    RecMon().registerActionFull("Home()");
  }

  double _maxWidth =
      600; // Use to set value for Container constraints BoxConstraints.maxwidth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorGlobals().abellioRed(),
      // appBar: GlobalAppBar().appBar("Home Test", context),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async => await leaveDialog(context),
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            // decoration: GlobalStylePref().mainBackgroundStyle,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo container for padding
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                    child: const Text(
                      "Route Learner",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: "LeagueSpartan",
                      ),
                    ),
                  ),
                  // /Logo container

                  // Main body container
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      // image: const DecorationImage(
                      //   image: AssetImage("images/bg2.png"),
                      //   fit: BoxFit.cover,
                      // ),
                      //color: Color.fromRGBO(225, 235, 237, 1),

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                          Color.fromRGBO(225, 235, 237, 1),
                        ],
                      ),
                    ),

                    //height: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //! Depot name
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            "${globals.depotName}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 41, 41, 41),
                              fontSize: 20,
                              fontFamily: "LeagueSpartan",
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        //! Update banner, visible only when globals.showUpdateAppBanner is true via Main
                        Visibility(
                          visible: globals.showUpdateAppBanner,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: InkWell(
                              onTap: () async {
                                await launch(globals.playStoreURL);
                              },
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: _maxWidth),
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                    10), // Inside menu item
                                decoration:
                                    GlobalStylePref().containerRadiusShadow,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./images/msi_update.png",
                                      scale: 6,
                                    ),

                                    const SizedBox(
                                      width: 15,
                                    ),

                                    // Add expanded to stop overflow to the right
                                    Expanded(
                                      child: Text(
                                        "Update Available!\nTap Here To Download",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorGlobals().abellioRed(),
                                          fontSize: 15,
                                          fontFamily: "LeagueSpartan",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        //! To keep distance from UPDATE BANNER when activate driver is visible AND update banner is visible
                        Visibility(
                          visible: (globals.adminPermission ||
                                  globals.buddyPermission) &&
                              globals.showUpdateAppBanner,
                          child: SizedBox(
                            height: 20,
                          ),
                        ),

                        // //! ACTIVATE DRIVER
                        Visibility(
                          visible: globals.adminPermission ||
                              globals.buddyPermission,
                          child: _tapBubble(
                            "Activate Driver",
                            "./images/msi_qr.png",
                            ShowQRCode("Driver"),
                          ),
                        ),

                        //! To keep distance from NEWS PICTURE box below, when Activate Driver is visible
                        Visibility(
                          visible: (globals.adminPermission ||
                              globals.buddyPermission),
                          child: SizedBox(
                            height: 20,
                          ),
                        ),

                        //! To keep distance from NEWS PICTURE box below, when Activate Driver is visible for a driver
                        //! Visible IF update banner is showing AND activate driver banner is NOT showing
                        Visibility(
                          visible: (globals.showUpdateAppBanner) &&
                              (!globals.adminPermission &&
                                  !globals.buddyPermission),
                          child: SizedBox(
                            height: 20,
                          ),
                        ),

                        // //! NEWS PICTURE
                        // Padding to stop container inside from reaching to edge of screen
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20,
                              0), // 20 on top to avoid having to use sizedbox
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => WebViewGlobal(
                                      globals.msiBannerTargetURL,
                                      "Top Headline"),
                                ),
                              );
                            },
                            child: Container(
                              // width: double.infinity,
                              constraints: BoxConstraints(maxWidth: _maxWidth),
                              decoration:
                                  GlobalStylePref().containerRadiusShadow,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: globals.msiBannerImgURL,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      SpinKitThreeBounce(
                                    color: ColorGlobals().iconColor1(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        "Error Loading Image",
                                        style: TextStyle(
                                            color: ColorGlobals().abellioRed()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(
                        //   height: 20,
                        // ),

                        // // //! Bubble
                        // _tapBubble("Driver Activation Tutorial",
                        //     "./images/msi_bulb.png", Index()),

                        // SizedBox(
                        //   height: 20,
                        // ),

                        //! Main buttons
                        Container(
                          constraints: BoxConstraints(maxWidth: _maxWidth + 40),
                          child: GridView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(
                                20, 20, 0, 0), // Outside menu items
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            physics:
                                const NeverScrollableScrollPhysics(), // Stop scrolling issues with SingleChildScView
                            children: [
                              // Individual buttons
                              // Visibility(
                              //   visible: true,
                              //   child: _homeMenuItem(
                              //       "Activate\nDriver", "./images/msi_qr.png"),
                              // ),

                              _homeMenuItem("Route\nLearning",
                                  "./images/msi_rl.png", Index()),

                              _homeMenuItem("Type\nTraining",
                                  "./images/msi_tt.png", TypeTraining()),

                              _homeMenuItem("Videos", "images/msi_vid.png",
                                  VideosLanding()),

                              _homeMenuItem("Access\nCodes",
                                  "images/msi_pad.png", RRCodes()),

                              _homeMenuItem("Settings", "images/msi_set.png",
                                  SettingsMenu()),

                              _homeMenuItem("Announce", "images/msi_anno.png",
                                  Announcements()),

                              // /Individual buttons
                            ],
                          ),
                        ),

                        // //! Bubble
                        Visibility(
                          visible: (globals.adminPermission ||
                              globals.buddyPermission),
                          child: _tapBubble(
                            "Driver Activation Tutorial",
                            "./images/msi_bulb.png",
                            ViewPDF(globals.msiActivationGuideURL,
                                "Driver Activation"),
                          ),
                        ),

                        // // //! Bubble
                        // _tapBubble(
                        //     "App Tutorial", "./images/msi_bulb.png", Index()),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Center(
                              child: Image.asset(
                            "./images/abelliosmall.png",
                            scale: 4,
                          )),
                        ),
                      ],
                    ),

                    // Main body

                    // /Main boody
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Here, we are using Widget _goToPage to pass the name of the page we are going to be navigating
  // to when we call this method in GidView above.
  //
  Widget _homeMenuItem(String _buttonText, String _iconPath, Widget _goToPage) {
    //
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => _goToPage));
        },
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(10, 10, 10, 10), // Inside menu item
          decoration: GlobalStylePref().containerRadiusShadow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _iconPath,
                scale: 5.5,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorGlobals().abellioRed(),
                  fontSize: 17,
                  fontFamily: "LeagueSpartan",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tapBubble(String _buttonText, String _iconPath, Widget _goToPage) {
    //
    // Padding to stop container inside from reaching to edge of screen
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: ((context) => _goToPage)));
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          //width: double.infinity,
          padding: const EdgeInsets.all(10), // Inside menu item
          decoration: GlobalStylePref().containerRadiusShadow,
          child: Row(
            children: [
              Image.asset(
                _iconPath,
                scale: 6,
              ),

              const SizedBox(
                width: 15,
              ),

              // Add expanded to stop overflow to the right
              Expanded(
                child: Text(
                  _buttonText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorGlobals().abellioRed(),
                    fontSize: 15,
                    fontFamily: "LeagueSpartan",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                icon: Icon(
                  Icons.home,
                  color: ColorGlobals().abellioRed(),
                ),
                label: Text(
                  "Stay",
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorGlobals().abellioRed(),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: ColorGlobals().abellioRed(),
                ),
                label: Text(
                  "Exit",
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorGlobals().abellioRed(),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false);
  }
}
