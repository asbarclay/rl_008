// Globals

library my_prj.globals;

// Current version
double appVersion = 1.04;
// String to display in about application in settings
String appVersionString = "Version 1.04. Build 2/5/2022";
String appDetailsString =
    "Route Learner is copyright © 2022 Abellio London. All rights reserved.\n\nFor technical issues, please email " +
        "admin@routelearner.com\n\n" +
        "Application developed by Alex Barclay.";

String targetOS = "Android";

String key = "nokey";
String level = "nolevel";
bool adminPermission = false;
bool buddyPermission = false;
//bool fullPermission = true; // Master admin permission for developers only
Map depotRoutesMap = {};
Map rrCodesData = {};
String depotName = "nodepot";
int rrCodesTriggered = 0;
int maxRRCodeTriggers = 5;

// Activation pathway
int maxActivAttempts = 2;
int drivExpDays = 365;
int mentExpDays = 365;
int manaExpDays = 365;

// Show "elevated activation" options on settings page
bool mgmtAct = false;

// Show "log in" link on Login Page for bypassing QR pathway
bool showLoginWithUserPassLink = false;

// Stores the number of allowed days that THIS activation has
// just to avoid writing more ifs to check if THIS activation is
// driver, manager, etc.
//
// Used in main.dart inside _isDeviceExpired()
int thisActivationAllowedDays = 0;

// Show "no codes for ladies only toilets" banner in Rest Room Codes page?
bool showNoLadiesOnlyCodesBanner = true;

// Show update app banner?
bool showUpdateAppBanner = false;

// Play Store URL to update app
String playStoreURL = "";

// Show "advisory warning" message screens before "index"? String "yes" or "no"
String loadMsg = "yes";

// Home screen "news headline" metadata to show image and obtain URL
String msiBannerImgURL = "";
String msiBannerTargetURL = "";
String msiActivationGuideURL = "";
