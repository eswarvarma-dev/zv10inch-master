import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:ventilator/activity/Dashboard.dart';
import 'package:ventilator/database/ADatabaseHelper.dart';
import 'package:ventilator/database/DatabaseHelper.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  DatabaseHelper dbHelper;
  ADatabaseHelper dbHelper1;
  static const shutdownChannel = const MethodChannel("shutdown");
  UsbPort port;
  // int counter=0;

  @override
  void initState() {
    turnOnScreen();
    super.initState();

    dbHelper = DatabaseHelper();
    dbHelper1 = ADatabaseHelper();
    // counter = counter+1;

    getData();
    // saveData();
  }

  Future<void> turnOnScreen() async {
    try {
      Screen.setBrightness(1.0);
      Screen.keepOn(true);
      await shutdownChannel.invokeMethod('turnOnScreen');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  getData() async {
    // preferences = await SharedPreferences.getInstance();
    // counter = (preferences.getInt("noTimes")).toInt();
    // await sleep(Duration(seconds: 7));
    saveData();
  }

  saveData() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("mode", "            ");

    preferences.setString("checkMode", "0");
    preferences.setInt("rr", 20);
    preferences.setInt("ie", 51);
    preferences.setString("i", "0.0");
    preferences.setString("e", "0.0");
    preferences.setInt("peep", 10);
    // preferences.setInt("ps", 40);
    preferences.setInt("fio2", 21);
    preferences.setInt("tih", 50);
    preferences.setInt("paw", 0);
    preferences.setInt("itrig", 3);
    preferences.setInt("atime", 10);
    preferences.setInt("ti", 1);
    preferences.setBool("play", true);
    // preferences.setInt("tidal", 14);
    // preferences.setInt("mv", 500);
    preferences.setInt("rrtotal", 0);
    preferences.setInt("ps", 25);
    preferences.setInt("pc", 25);
    preferences.setInt("vt", 400);
    preferences.setInt("te", 20);
    preferences.setInt("vte", 0);
    preferences.setString("pid", "");
    preferences.setString("pname", "");
    preferences.setString("pgender", "");
    preferences.setString("page", "");
    preferences.setString("pweight", "");
    preferences.setString("pheight", "");
    preferences.setInt('minrr', 1);
    preferences.setInt('maxrr', 70);
    preferences.setInt('minvte', 0);
    preferences.setInt('maxvte', 3000);
    preferences.setInt('minppeak', 0);
    preferences.setInt('maxppeak', 100);
    preferences.setInt('minpeep', 0);
    preferences.setInt('maxpeep', 40);
    preferences.setInt('minfio2', 21);
    preferences.setInt('maxfio2', 100);
    preferences.setInt('minmv', 0);
    preferences.setInt('maxmv', 25);
    preferences.setInt('minlv', 0);
    preferences.setInt('maxlv', 100);
    preferences.setBool('calli', false);
    preferences.setBool('_isFlagTest', false);
    preferences.setBool('_setValuesonClick', true);
    preferences.setBool('playpauseButtonEnabled', false);
    preferences.setBool("flag", true);
    preferences.setBool("flag1", true);
    preferences.setBool('pControl', true);
    preferences.setBool('_iere', false);
    preferences.setBool('first', true);
    preferences.setBool('zeros', true);
    preferences.setBool('inhalationFlag', true);

    preferences.setInt('pccmvFio2Value', 21);
            preferences.setInt('vccmvFio2Value', 21);
            preferences.setInt('pacvFio2Value', 21);
            preferences.setInt('vacvFio2Value', 21);
            preferences.setInt('psimvFio2Value', 21);
            preferences.setInt('vsimvFio2Value', 21);
            preferences.setInt('psvFio2Value', 21);
            preferences.setInt('prvcFio2Value', 21);
    //  var now = new DateTime.now();
    // var o2Time = DateFormat("dd/MM/yyyy").format(now);
    //  preferences.setString("o2time", o2Time.toString());

    var dateS = preferences.getString('lastRecordTime');
    var res = dbHelper.delete7Daysdata(dateS);
    var res1 = dbHelper1.delete1Daysdata(dateS);

    // if(counter==null){
    //   counter = counter +1;
    // }else{
    // counter = counter +1;
    // }

    // print(res.toString()+"  "+res1.toString());
    //  preferences.setInt('noTimes', counter);
    // await sleep(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Color(0xFF171e27),
        child: Center(
          child: SplashScreen(
            seconds: 2,
            title: Text(
              "SWASIT",
              style: TextStyle(
                  color: Colors.orange, fontSize: 72, fontFamily: "appleFont"),
            ),
            loadingText: Text(
              "Please wait",
              style: TextStyle(color: Colors.white),
            ),
            navigateAfterSeconds: Dashboard(),
            backgroundColor: Color(0xFF171e27),
            loaderColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
