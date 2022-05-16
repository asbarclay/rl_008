import 'package:flutter/material.dart';
import 'package:rl_001/class/recmon.dart';
import 'package:rl_001/class/stylepref.dart';
import 'package:rl_001/menu/sidemenu.dart';
import 'package:rl_001/widgets/global_appbar.dart';
import 'package:rl_001/widgets/widget_custom.dart';

class TypeTraining extends StatefulWidget {
  TypeTraining({Key? key}) : super(key: key);

  @override
  State<TypeTraining> createState() => _TypeTrainingState();
}

class _TypeTrainingState extends State<TypeTraining> {
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    RecMon().registerAction("TypeTraining");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalStylePref().mainBackgroundStyle,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: SideMenu(),
        appBar: GlobalAppBar().appBar("Type Training", context),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                WidgetCustom().tapImageBottomHeadline(
                  "https://firebasestorage.googleapis.com/v0/b/rl100-1a10e.appspot.com/o/type_training%2Fguides%2Fnbfl.jpg?alt=media&token=54968d0a-3a0c-4095-a660-47b2a4cdf4e7",
                  "NBFL Routemaster",
                ),
                SizedBox(
                  height: 20,
                ),
                WidgetCustom().tapImageBottomHeadline(
                  "https://firebasestorage.googleapis.com/v0/b/rl100-1a10e.appspot.com/o/type_training%2Fguides%2Fe400mmc_mless.jpg?alt=media&token=a87f4ea4-9098-497a-aca0-e2b9aacf12c7",
                  "Enviro400 MMC",
                ),
              ],
            )),
      ),
    );
  }
}
