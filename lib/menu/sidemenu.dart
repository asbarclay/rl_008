import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/color_globals.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/class/textstylepref.dart';
import 'package:rl_001/home.dart';
import 'package:rl_001/index.dart';
import 'package:rl_001/menupages/announce.dart';
import 'package:rl_001/menupages/settings.dart';
import 'package:rl_001/menupages/showqrcode.dart';
import 'package:rl_001/menupages/type_training.dart';
import 'package:rl_001/rrcodes.dart';
import 'package:rl_001/select_depot.dart';
import 'package:rl_001/videos/videos_landing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rl_001/globals.dart' as globals;

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  //

  String _userLevel = "";

  @override
  void initState() {
    // TODO: implement initState
    // _setUserLevelString();
    super.initState();
  }

  // void _setUserLevelString() {
  //   setState(() {
  //     //
  //     // Activated as admin and not buddy
  //     if (globals.adminPermission && !globals.buddyPermission) {
  //       _userLevel = "Activated as Manager";
  //     }
  //     // Activated as buddy and not admin
  //     else if (globals.buddyPermission && !globals.adminPermission) {
  //       _userLevel = "Activated as Mentor";
  //     } else {
  //       _userLevel = "";
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        type: MaterialType.canvas,
        color: Colors.white,
        child: ListView(
          children: [
            //! Close button
            // GlobalButtonPref().sideMenuItem(
            //     Icons.close,
            //     globals.adminPermission ? "Activated as Manager" : "",
            //     Color.fromRGBO(2, 26, 51, 0), () {
            //   Navigator.pop(context);
            // }),

            // ListTile(
            //   leading: Icon(
            //     Icons.close,
            //     color: ColorGlobals().iconColor1(),
            //   ),
            //   title: Text(
            //     "", // Activation level to the right of the X
            //     style: TextStyle(
            //       fontSize: 15,
            //       color: Colors.grey.shade500,
            //       fontWeight: FontWeight.normal,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            //   tileColor: Color.fromRGBO(2, 26, 51, 0),
            // ),

            // //! Divider

            // Visibility(
            //   visible: (globals.adminPermission || globals.buddyPermission),
            //   child: Divider(
            //     thickness: 1,
            //     color: Color.fromRGBO(0, 0, 0, 0.2),
            //   ),
            // ),

            SizedBox(
              height: 20,
            ),

            //! Home
            GlobalButtonPref().sideMenuItem(
              "./images/msi_home.png",
              "Home",
              Colors.transparent,
              () {
                //
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),

            //! Route learning
            GlobalButtonPref().sideMenuItem(
              "./images/msi_rl.png",
              "Route Learning",
              Colors.transparent,
              () {
                // Close drawer after item clicked
                // .pop() must come before .push(), otherwise button won't do anything
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Index(),
                  ),
                );
              },
            ),

            //! Type training
            GlobalButtonPref().sideMenuItem(
              "./images/msi_tt.png",
              "Type Training",
              Colors.transparent,
              () {
                // Close drawer after item clicked
                // .pop() must come before .push(), otherwise button won't do anything
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TypeTraining(),
                  ),
                );
              },
            ),

            // //! Type training
            // GlobalButtonPref().sideMenuItem(
            //     Icons.rotate_right_rounded, "Type Training", Colors.transparent,
            //     () {
            //   // Close drawer after item clicked
            //   // .pop() must come before .push(), otherwise button won't do anything
            //   Navigator.pop(context);

            //   Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //       builder: (context) => Index(),
            //     ),
            //   );
            // }),

            // //! Procedures
            // GlobalButtonPref().sideMenuItem(
            //     Icons.list_alt, "Procedures", Colors.transparent, () {
            //   // Close drawer after item clicked
            //   // .pop() must come before .push(), otherwise button won't do anything
            //   Navigator.pop(context);

            //   Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //       builder: (context) => Index(),
            //     ),
            //   );
            // }),

            //! Videos
            GlobalButtonPref().sideMenuItem(
              "./images/msi_vid.png",
              "Videos",
              Colors.transparent,
              () {
                // Close drawer after item clicked
                // .pop() must come before .push(), otherwise button won't do anything
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VideosLanding(),
                  ),
                );
              },
            ),

            //! Access codes
            GlobalButtonPref().sideMenuItem(
              "./images/msi_pad.png",
              "Access Codes",
              Colors.transparent,
              () {
                // Close drawer after item clicked
                // .pop() must come before .push(), otherwise button won't do anything
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => RRCodes(),
                  ),
                );
              },
            ),

            //! Announcements
            GlobalButtonPref().sideMenuItem(
              "./images/msi_anno.png",
              "Announcements",
              Colors.transparent,
              () {
                //
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Announcements(),
                  ),
                );
              },
            ),

            //! Divider
            Divider(
              thickness: 1,
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),

            // //! Change garage
            // GlobalButtonPref().sideMenuItem(
            //     Icons.list, "Change Garage", Colors.transparent, () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => SelectDepot(),
            //     ),
            //   );
            // }),

            // //! QR code VISIBLE ONLY IF ADMIN OR BUDDY
            Visibility(
              visible: (globals.adminPermission || globals.buddyPermission),
              child: GlobalButtonPref().sideMenuItem(
                "./images/msi_qr.png",
                "Activate Driver",
                Colors.transparent,
                () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ShowQRCode("Driver"),
                    ),
                  );
                },
              ),
            ),

            // ! Divider VISIBLE ONLY IF ADMIN OR BUDDY
            Visibility(
              visible: (globals.adminPermission || globals.buddyPermission),
              child: Divider(
                thickness: 1,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              ),
            ),

            // //! Privacy & terms
            // GlobalButtonPref().sideMenuItem(
            //   Icons.account_balance,
            //   "Privacy & Terms",
            //   Colors.transparent,
            //   () {
            //     Navigator.pop(context); // Close drawer
            //     Navigator.push(
            //       (context),
            //       CupertinoPageRoute(
            //         builder: (builder) => Settings(),
            //       ),
            //     );
            //   },
            // ),

            //! Settings
            GlobalButtonPref().sideMenuItem(
              "./images/msi_set.png",
              "Settings",
              Colors.transparent,
              () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  (context),
                  CupertinoPageRoute(
                    builder: (builder) => SettingsMenu(),
                  ),
                );
              },
            ),

            // Visibility(
            //   visible: globals.adminPermission,
            //   child: TextStylePref()
            //       .midWhite16NormalCenter("\nActivated as Manager"),
            // ),

            // Visibility(
            //   visible: globals.buddyPermission,
            //   child: TextStylePref()
            //       .midWhite16NormalCenter("\nActivated as Buddy"),
            // ),
          ],
        ),
      ),
    );
  }
}
