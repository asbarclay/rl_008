import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rl_001/class/color_globals.dart';

import 'package:rl_001/class/stylepref.dart';

import 'package:flutter/foundation.dart';
import 'package:rl_001/qr_validate.dart';
import 'package:rl_001/select_depot.dart';
import 'package:rl_001/widgets/global_appbar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'class/recmon.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  //
  late String _result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    RecMon().registerAction("QRScan()");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: ColorGlobals().abellioRed(),
        appBar: GlobalAppBar().appBar("Activate Route Learner", context),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderWidth: 8,
                    borderRadius: 15,
                    cutOutSize: 300,
                    borderColor: ColorGlobals().abellioRed()),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.flipCamera();
                    },
                    child: Text(
                      "Flip Camera",
                      style: TextStyle(
                        color: ColorGlobals().abellioGrey(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(100, 70),
                      primary: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      // side: const BorderSide(
                      //   color: Colors.purple,
                      //   width: 2.0,
                      // ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await controller?.toggleFlash();
                      } catch (e) {
                        return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Cannot Enable Flash"),
                            content: const Text(
                                "Flash is not available on this device."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK")),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Turn On Flash",
                      style: TextStyle(
                        color: ColorGlobals().abellioGrey(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(110, 70),
                      primary: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      // side: const BorderSide(
                      //   color: Colors.purple,
                      //   width: 2.0,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        //
        setState(() {
          _result = scanData.code.toString();

          // Correct QR Code, so move to validate QR code that was scanned
          if (_result != null) {
            //
            print(_result);
            //
            controller.dispose();

            // Pass scanned code to function to check if document exists in firestore
            //
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => QRValidate(_result),
                ),
                (Route route) => false);
          }
          // Incorrect QR code, push user back to previous page
          else {
            controller.dispose();
            Navigator.pop(context);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
