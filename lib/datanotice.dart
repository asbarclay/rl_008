import 'package:flutter/material.dart';
import 'package:rl_001/class/buttonpref.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/dont_use_phone_in_cab.dart';
import 'package:rl_001/index.dart';
import 'package:rl_001/widgets/global_appbar.dart';

class DataNotice extends StatefulWidget {
  DataNotice({Key? key}) : super(key: key);

  @override
  _DataNoticeState createState() => _DataNoticeState();
}

class _DataNoticeState extends State<DataNotice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlobalAppBar().appBar("Data Usage Notice", context),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Text(
            //   "Mobile Data Usage Notice",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 24,
            //     fontFamily: "OpenSans-Regular",
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // ClipRRect(
            //   child: Image.asset(
            //     "./images/qrex.png",
            //   ),
            //   borderRadius: BorderRadius.circular(15),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            const Expanded(
              flex: 8,
              child: Text(
                "When connected to the Internet via your mobile network provider, " +
                    "Route Learner will use mobile data to download route learning materials, such as " +
                    "maps and videos.\n\n" +
                    // "Depending on your mobile plan, this may incur a fee, or use your data allowance.\n\n" +
                    "To avoid this, please access this application via an unmetered connection, such as a free Wi-Fi hotspot.\n\n" +
                    "Any use of Route Learner via mobile data, or any other metered connection, as well as any associated cost, is solely your responsibility.",
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 60,
                child: GlobalButtonPref().midButton("Agree & Continue", () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => DontUsePhoneInCab()),
                      (route) => false);
                }),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
