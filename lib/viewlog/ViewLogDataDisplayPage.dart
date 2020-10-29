import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:ventilator/database/DatabaseHelper.dart';
import 'package:ventilator/database/VentilatorOMode.dart';
import 'package:ventilator/graphs/Oscilloscope.dart';
import 'package:ventilator/graphs/OscilloscopeBig.dart';
import 'package:ventilator/viewlog/ViewLogPatientList.dart';

// ignore: must_be_immutable
class ViewLogDataDisplayPage extends StatefulWidget {
  var patientID, fromDateC, toDateC;
  ViewLogDataDisplayPage(this.fromDateC, this.toDateC);

  @override
  StateViewLogPage createState() => StateViewLogPage();
}

class StateViewLogPage extends State<ViewLogDataDisplayPage> {
  List<double> pressurePoints = [];
  List<double> flowPoints = [];
  List<double> volumePoints = [];
  Oscilloscope scopeOne, scopeOne1, scopeOne2;
  OscilloscopeBig mscopeOne,
      mscopeOne1,
      mscopeOne2,
      sscopeOne,
      sscopeOne1,
      sscopeOne2;
  int currentValue = 0;
  bool dataAvailable = false, isPlaying = false;
  bool _isTab10 = true;
  String psValue1 = "00",
      mvValue = "00",
      vteValue = "00",
      modeName = "PC-CMV",
      fio2Value = "0",
      tiValue = "0",
      patientName = "",
      alarmActive = "0",
      alarmMessage = "0",
      alarmPriority = "5",
      paw = "0",
      dateTime = "0";

  String ioreDisplayParamter = "I/E";
  String amsDisplayParamter = "";
  DatabaseHelper dbHelper;
  List<VentilatorOMode> vomL;
  String operatinModeR,
      ieValue = "0",
      fio2DisplayParameter = "0",
      mapDisplayValue = "0",
      ieDisplayValue = "0",
      cdisplayParameter = "0",
      peepDisplayValue = "0",
      rrDisplayValue = "0",
      lungImage = "0",
      rrValue = "0",
      peepValue = "0",
      psValue = "0",
      pcValue = "0",
      itrigValue = "0",
      pplateauDisplay = "0",
      atime = "0",
      tipsv = "0",
      leakVolumeDisplay = "0",
      peakFlowDisplay = "0",
      spontaneousDisplay = "0",
      vtValue = "0";

  int minRrtotal = 1,
      maxRrtotal = 70,
      minvte = 0,
      maxvte = 2400,
      minmve = 0,
      maxmve = 100,
      minppeak = 0,
      maxppeak = 100,
      minpeep = 0,
      maxpeep = 40,
      minfio2 = 21,
      maxfio2 = 100;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    vomL = [];
    Screen.keepOn(true);
    dbHelper = DatabaseHelper();
    getPatientData(widget.fromDateC, widget.toDateC);
  }

  runData(data) async {
    for (currentValue = data == null || data == "" ? 0 : data;
        currentValue < vomL.length;
        currentValue++) {
      dataPack(currentValue, 1);
      await justWait(numberOfMilliseconds: 100);
    }
  }

  void justWait({@required int numberOfMilliseconds}) async {
    await Future.delayed(Duration(milliseconds: numberOfMilliseconds));
  }

  getPatientData(var fromDate, var toDate) async {
    vomL =
        await dbHelper.getPatientsData(fromDate.toString(), toDate.toString());
    // print(vomL);
    pressurePoints = [];
    volumePoints = [];
    flowPoints = [];

    if (vomL.isNotEmpty) {
      setState(() {
        dataAvailable = true;
      });
    } else {
      setState(() {
        dataAvailable = false;
      });
    }
    // isPlaying ?
    runData(0);
    // : Container();
    // setState(() {
    //   isPlaying = false;
    // });
  }

  dataPack(int currentValue, int status) {
    if (status == 1) {
      pressurePoints.add(vomL[currentValue].pressureValues != null
          ? vomL[currentValue].pressureValues
          : 0);
      flowPoints.add(vomL[currentValue].flowValues != null
          ? vomL[currentValue].flowValues
          : 0);
      volumePoints.add(vomL[currentValue].volumeValues != null
          ? vomL[currentValue].volumeValues
          : 0);
    }
    setState(() {
      psValue1 = vomL[currentValue].pipD;
      vteValue = vomL[currentValue].vtD;
      vtValue = vomL[currentValue].vtValue;
      peepDisplayValue = vomL[currentValue].peepD;
      rrDisplayValue = vomL[currentValue].rrD;
      fio2DisplayParameter = vomL[currentValue].fio2D;
      mapDisplayValue = vomL[currentValue].mapD;
      mvValue = vomL[currentValue].mvD;
      cdisplayParameter = vomL[currentValue].complainceD;
      ieDisplayValue = vomL[currentValue].ieD;
      rrValue = vomL[currentValue].rrS;
      ieValue = vomL[currentValue].ieS;
      peepValue = vomL[currentValue].peepS;
      psValue = vomL[currentValue].psS;
      pcValue = vomL[currentValue].pcS;
      itrigValue = vomL[currentValue].itrigS;
      tipsv = vomL[currentValue].tipsvS;
      atime = vomL[currentValue].atimeS;
      fio2Value = vomL[currentValue].fio2S;
      pplateauDisplay = vomL[currentValue].pplateauDisplay ?? "0";
      operatinModeR = vomL[currentValue]?.operatingMode ?? "0";
      patientName = vomL[currentValue]?.patientName ?? "";
      paw = vomL[currentValue]?.paw ?? "0";
      dateTime = vomL[currentValue].dateTime;
      alarmActive = vomL[currentValue].alarmActive;
      alarmMessage = vomL[currentValue].alarmC;
      alarmPriority = vomL[currentValue].alarmP;

      spontaneousDisplay = vomL[currentValue].spontaneous;
      leakVolumeDisplay = vomL[currentValue].leakVolume;
      peakFlowDisplay = vomL[currentValue].peakFlow;
      var amsData = vomL[currentValue].amsParamter;


        if (amsData == "1") {
        amsDisplayParamter = "A";
      } else if (amsData == "2") {
        amsDisplayParamter = "M";
      } else if (amsData == "3") {
        amsDisplayParamter = "S";
      }

      if (operatinModeR == "1") {
        setState(() {
          modeName = "VACV";
        });
      } else if (operatinModeR == "2") {
        setState(() {
          modeName = "PACV";
        });
      } else if (operatinModeR == "3") {
        setState(() {
          modeName = "PSV";
        });
      } else if (operatinModeR == "4") {
        setState(() {
          modeName = "PSIMV";
        });
      } else if (operatinModeR == "5") {
        setState(() {
          modeName = "VSIMV";
        });
      } else if (operatinModeR == "6") {
        setState(() {
          modeName = "PC-CMV";
        });
      } else if (operatinModeR == "7") {
        setState(() {
          modeName = "VC-CMV";
        });
      } else if (operatinModeR == "14") {
        setState(() {
          modeName = "PRVC";
        });
      } else if (operatinModeR == "20") {
        setState(() {
          modeName = "CPAP";
        });
      } else if (operatinModeR == "21") {
        setState(() {
          modeName = "AUTO";
        });
      }

      if (int.tryParse(paw) <= 10) {
        setState(() {
          lungImage = "1";
        });
      } else if (int.tryParse(paw) <= 20 && int.tryParse(paw) >= 11) {
        setState(() {
          lungImage = "2";
        });
      } else if (int.tryParse(paw) <= 30 && int.tryParse(paw) >= 21) {
        setState(() {
          lungImage = "3";
        });
      } else if (int.tryParse(paw) <= 40 && int.tryParse(paw) >= 31) {
        setState(() {
          lungImage = "4";
        });
      } else if (int.tryParse(paw) <= 100 && int.tryParse(paw) >= 41) {
        setState(() {
          lungImage = "5";
        });
      }

    

      if (alarmActive == '1') {
        setState(() {
          if (alarmPriority == "0") {
            alarmMessage == "17"
                ? alarmMessage = "Patient Discconnected"
                : alarmMessage == "24"
                    ? alarmMessage =
                        "Blender Malfunction. \nOxygen blending not possible."
                    : alarmMessage == "25"
                        ? alarmMessage = "Replace Oxygen Sensor"
                        : "";
          } else if (alarmPriority == '1') {
            alarmMessage == '5'
                ? alarmMessage = "SYSTEM FAULT"
                : alarmMessage == '7'
                    ? alarmMessage = "FiO\u2082 SENSOR MISSING"
                    : alarmMessage == '10'
                        ? alarmMessage = "HIGH LEAKAGE"
                        : alarmMessage == '11'
                            ? alarmMessage = "HIGH PRESSURE"
                            : alarmMessage = "";
          } else if (alarmPriority == '2') {
            // print("alarm code "+((alarmMessage).toString());
            alarmMessage == '1'
                ? alarmMessage = "AC POWER DISCONNECTED"
                : alarmMessage == '2'
                    ? alarmMessage = " LOW BATTERY"
                    : alarmMessage == '3'
                        ? alarmMessage = "CALIBRATE FiO2"
                        : alarmMessage == '4'
                            ? alarmMessage = "CALIBRATION FiO2 FAIL"
                            : alarmMessage == '6'
                                ? alarmMessage = "SELF TEST FAIL"
                                : alarmMessage == '8'
                                    ? alarmMessage = "HIGH FiO2"
                                    : alarmMessage == '9'
                                        ? alarmMessage = "LOW FIO2"
                                        : alarmMessage == '12'
                                            ? alarmMessage = "LOW PRESSURE"
                                            : alarmMessage == '13'
                                                ? alarmMessage = "LOW VTE"
                                                : alarmMessage == '14'
                                                    ? alarmMessage = "HIGH VTE"
                                                    : alarmMessage == '15'
                                                        ? alarmMessage =
                                                            "LOW VTI"
                                                        : alarmMessage == '16'
                                                            ? alarmMessage =
                                                                "HIGH VTI"
                                                            : alarmMessage ==
                                                                    "18"
                                                                ? alarmMessage =
                                                                    "LOW O2  supply"
                                                                : alarmMessage ==
                                                                        '19'
                                                                    ? alarmMessage =
                                                                        "LOW RR"
                                                                    : alarmMessage ==
                                                                            '20'
                                                                        ? alarmMessage =
                                                                            "HIGH RR"
                                                                        : alarmMessage ==
                                                                                '21'
                                                                            ? alarmMessage =
                                                                                "HIGH PEEP"
                                                                            : alarmMessage == '22'
                                                                                ? alarmMessage = "LOW PEEP"
                                                                                : alarmMessage == '25' ? alarmMessage = "Low Minute Volume" : alarmMessage == '26' ? alarmMessage = "High Minute Volume" : alarmMessage == '27' ? alarmMessage = "High Leak Volume" : alarmMessage == '28' ? alarmMessage = "High Leak Volume" : alarmMessage = "Set volume can't be reached. due to low PC Max";
          } else if (alarmPriority == '3') {
            alarmMessage == '23'
                ? alarmMessage = "Apnea backup"
                : alarmMessage = "";
          }
        });
      }

      // ieValue
      // Fluttertoast.showToast(msg: psValue1, toastLength: Toast.LENGTH_SHORT);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    scopeOne = Oscilloscope(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.yellow,
        yAxisMax: 100,
        yAxisMin: 0.0,
        dataSet: pressurePoints);

    scopeOne1 = Oscilloscope(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.green,
        yAxisMax: 200.0,
        yAxisMin: -90.0,
        dataSet: flowPoints);

    scopeOne2 = Oscilloscope(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.blue,
        yAxisMax: 3000.0,
        yAxisMin: 0.0,
        dataSet: volumePoints);

    mscopeOne = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.yellow,
        yAxisMax: 100,
        yAxisMin: 0.0,
        dataSet: pressurePoints);

    mscopeOne1 = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.green,
        yAxisMax: 200.0,
        yAxisMin: -90.0,
        dataSet: flowPoints);

    mscopeOne2 = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Color(0xFF171e27),
        traceColor: Colors.blue,
        yAxisMax: 3000.0,
        yAxisMin: 0.0,
        dataSet: volumePoints);

    sscopeOne = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Colors.transparent,
        traceColor: Colors.yellow,
        yAxisMax: 100,
        yAxisMin: 0.0,
        dataSet: pressurePoints);

    sscopeOne1 = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Colors.transparent,
        traceColor: Colors.green,
        yAxisMax: 200.0,
        yAxisMin: -90.0,
        dataSet: flowPoints);

    sscopeOne2 = OscilloscopeBig(
        showYAxis: true,
        yAxisColor: Colors.grey,
        padding: 10.0,
        backgroundColor: Colors.transparent,
        traceColor: Colors.blue,
        yAxisMax: 3000.0,
        yAxisMin: 0.0,
        dataSet: volumePoints);

    // scopeOne3 = Oscilloscope(
    //     showYAxis: true,
    //     yAxisColor: Colors.grey,
    //     padding: 10.0,
    //     backgroundColor: Colors.black.withOpacity(0.7),
    //     traceColor: Colors.yellow,
    //     yAxisMax: 100.0,
    //     yAxisMin: 0.0,
    //     dataSet: pipPoints);
    // scopeOne4 = Oscilloscope(
    //     showYAxis: true,
    //     yAxisColor: Colors.grey,
    //     padding: 10.0,
    //     backgroundColor: Colors.transparent,
    //     traceColor: Colors.teal,
    //     yAxisMax: 100.0,
    //     yAxisMin: 0.0,
    //     dataSet: fio2Points);
    // scopeOne5 = Oscilloscope(
    //     showYAxis: true,
    //     yAxisColor: Colors.grey,
    //     padding: 10.0,
    //     backgroundColor: Colors.transparent,
    //     traceColor: Colors.pink,
    //     yAxisMax: 100.0,
    //     yAxisMin: 0.0,
    //     dataSet: peepPoints);

    // scopeOne6 = Oscilloscope(
    //     showYAxis: true,
    //     yAxisColor: Colors.grey,
    //     padding: 10.0,
    //     backgroundColor: Colors.black.withOpacity(0.7),
    //     traceColor: Colors.green,
    //     yAxisMax: 700.0,
    //     yAxisMin: 0.0,
    //     dataSet: vtPoints);

    return Scaffold(
        key: _scaffoldKey,
        drawer: Container(
          // width: 190,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: Container(
              color: Colors.transparent,
              child: Drawer(
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Container(
                          color: Color(0xFF171e27),
                          width: 190,
                          height: 85,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 5),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text("",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 10)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      cdisplayParameter.toString(),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 38),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 65),
                                    child: Text(
                                      "Static Compliance",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "ml/cmH\u2082O",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ))
                              ],
                            )),
                          ),
                        ),
                        Container(
                          color: Color(0xFF171e27),
                          width: 190,
                          height: 85,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 10),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text("",
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 10)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      leakVolumeDisplay == null
                                          ? "0"
                                          : (leakVolumeDisplay).toString(),
                                      // "0000",
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 35),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 60),
                                    child: Text(
                                      "Leak Volume",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "ml",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ))
                              ],
                            )),
                          ),
                        ),
                        Container(
                          color: Color(0xFF171e27),
                          width: 190,
                          height: 85,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 5, bottom: 5),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text("",
                                        style: TextStyle(
                                            color: Colors.pink, fontSize: 10)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.pink, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      peakFlowDisplay == null
                                          ? "0"
                                          : ((int.tryParse(peakFlowDisplay) *
                                                      60) /
                                                  1000)
                                              .toStringAsFixed(3),
                                      // "00",
                                      style: TextStyle(
                                          color: Colors.pink, fontSize: 35),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 60),
                                    child: Text(
                                      "Peak Flow",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "lpm",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.pink, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.pink, fontSize: 12),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    )),
                              ],
                            )),
                          ),
                        ),
                        operatinModeR == "4" ||
                                operatinModeR == "5" ||
                                operatinModeR == "3"
                            ? Container(
                                color: Color(0xFF171e27),
                                width: 190,
                                height: 85,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 5, bottom: 5),
                                  child: Center(
                                      child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text("",
                                              style: TextStyle(
                                                  color: Colors.pink,
                                                  fontSize: 10)),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.pink,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            spontaneousDisplay == null
                                                ? "0"
                                                : (int.tryParse(
                                                            spontaneousDisplay) /
                                                        1000)
                                                    .toStringAsFixed(3),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 35),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, bottom: 60),
                                          child: Text(
                                            "Spontaneous Volume",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "ml",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Divider(
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          )),
                                    ],
                                  )),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        // appBar: AppBar(title: Text(widget.patientID),),
        body: dataAvailable
            ? Container(
                color: Color(0xFF171e27),
                child: Stack(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          main(),
                          rightBar(),
                        ],
                      ),
                    ),
                    dataAvailable
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              changeFormatDateTime(dateTime),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ))
                        : Container(),
                    dataAvailable
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 1000,
                              height: 40,
                              child: Container(
                                child: CupertinoSlider(
                                  onChanged: (value) {
                                    pressurePoints = [];
                                    volumePoints = [];
                                    flowPoints = [];
                                    // if (isPlaying == false) {
                                    setState(() {
                                      currentValue = value.toInt();
                                    });
                                    dataPack(currentValue, 0);
                                    // } else {
                                    //   Fluttertoast.showToast(msg: "Press Pause");
                                    // }
                                  },
                                  value: currentValue.toDouble(),
                                  max: vomL.length.toDouble(),
                                  min: 0.0,
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  changeFormatDateTime(datetime) {
    if (datetime != null) {
      return datetime.toString().split(" ")[0].toString().split("-")[2] +
          "-" +
          datetime.toString().split(" ")[0].toString().split("-")[1] +
          "-" +
          datetime.toString().split(" ")[0].toString().split("-")[0] +
          "  " +
          datetime.toString().split(" ")[01].toString();
    } else {
      return "";
    }
  }

  rightBar() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 0, top: 0),
          child: Container(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4,
                ),
                InkWell(
                  onTap: () {},
                  child: _isTab10
                      ? Row(
                          children: <Widget>[
                            Text(
                              "SWASIT",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 34,
                                  fontFamily: "appleFont"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 18.0, left: 4),
                              child: Image.asset(
                                "assets/images/plus.png",
                                width: 18,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "SWASIT",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 22,
                              fontFamily: "appleFont"),
                        ),
                ),
                SizedBox(
                  height: 5,
                ),
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 45,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewLogPatientList()),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.queue_play_next,
                //     size: 45,
                //     color: Colors.green,
                //   ),
                //   onPressed: () {
                //     next10min(
                //         widget.patientID, widget.fromDateC, widget.toDateC);
                //   },
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       top: 8.0, bottom: 8.0, left: 16.0, right: 4.0),
                //   child: Text("Next 10 Min",
                //       style: TextStyle(color: Colors.white, fontSize: 14)),
                // )
                // isPlaying==true ?
                // IconButton(
                //   icon: Icon(
                //     Icons.play_circle_filled,
                //     size: 45,
                //     color: Colors.green,
                //   ),
                //   onPressed: () {
                //    setState(() {
                //      isPlaying = true;
                //      runData();
                //    });
                //   },
                // )
                // : IconButton(
                //   icon: Icon(
                //     Icons.pause_circle_filled,
                //     size: 45,
                //     color: Colors.blue,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       isPlaying = false;
                //      stopData();
                //    });
                //   },
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }

  main() {
    return Stack(
      children: [
        topbar(),
        leftbar(),
        Stack(
          children: [
            Container(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 5),
                          // _isTab10 ? graphs10() : graphs(),
                          graphsScale(),
                          SizedBox(width: 5),
                          Container(
                            margin: EdgeInsets.only(top: 40),
                            width: 1,
                            height: 600,
                            color: Colors.white,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        color: Color(0xFF171e27),
                                        width: 170,
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 4),
                                          child: Center(
                                              child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text("",
                                                      style: TextStyle(
                                                          color: Colors.yellow,
                                                          fontSize: 10)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0,
                                                          left: 4.0),
                                                  child: Text(
                                                    "cmH\u2082O",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    mapDisplayValue.toString(),
                                                    // "000",
                                                    style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 60, left: 4),
                                                  child: Text(
                                                    "P mean",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 18.0),
                                                    child: Divider(
                                                      color: Colors.white,
                                                      height: 1,
                                                    ),
                                                  ))
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        color: Color(0xFF171e27),
                                        width: 170,
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 4),
                                          child: Center(
                                              child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5.0, left: 4),
                                                  child: Text(
                                                    "L/m",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    "",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    (int.tryParse(mvValue) /
                                                            1000)
                                                        .toStringAsFixed(3),
                                                    // "0000",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 60, left: 4),
                                                  child: Text(
                                                    "MVe",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 18.0),
                                                    child: Divider(
                                                      color: Colors.white,
                                                      height: 1,
                                                    ),
                                                  ))
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   height: 162,
                                    // )
                                    Center(
                                      child: Container(
                                        color: Color(0xFF171e27),
                                        width: 170,
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 4),
                                          child: Center(
                                              child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text("",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    "cmH\u2082O",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    pplateauDisplay,
                                                    style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 60, left: 4),
                                                  child: Text(
                                                    "P Plateau",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 18.0),
                                                    child: Divider(
                                                      color: Colors.white,
                                                      height: 1,
                                                    ),
                                                  ))
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Image.asset(
                                                  lungImage == "1"
                                                      ? "assets/lungs/1.png"
                                                      : lungImage == "2"
                                                          ? "assets/lungs/2.png"
                                                          : lungImage == "3"
                                                              ? "assets/lungs/3.png"
                                                              : lungImage == "4"
                                                                  ? "assets/lungs/4.png"
                                                                  : lungImage ==
                                                                          "5"
                                                                      ? "assets/lungs/5.png"
                                                                      : "assets/lungs/1.png",
                                                  width: 120,
                                                  color: amsDisplayParamter ==
                                                          "A"
                                                      ? Colors.pink[200]
                                                      : amsDisplayParamter ==
                                                              "S"
                                                          ? Colors.green[200]
                                                          : Colors.white),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  border: new Border.all(
                                                    width: 2.0,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        ioreDisplayParamter,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18))),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 40),
                                                height: 40,
                                                width: 40,
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  border: new Border.all(
                                                    width: 2.0,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        amsDisplayParamter,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        modeName == "PSV" ||
                                operatinModeR == "3" ||
                                modeName == "CPAP" ||
                                operatinModeR == "20" ||
                                operatinModeR == "21" ||
                                modeName == "AUTO"
                            ? psvBottomBar()
                            : bottombar(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 175),
              width: 1,
              height: _isTab10 ? 600 : 440,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  leftbar() {
    return Stack(
      children: [
        Container(
            child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Center(
                child: Container(
                  color: Color(0xFF171e27),
                  width: 180,
                  height: _isTab10 ? 115 : 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Center(
                        child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 10),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              psValue1.toString(),
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: _isTab10 ? 48 : 38),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 65),
                            child: Text(
                              "PIP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isTab10 ? 20 : 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "cmH\u2082O",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "MAX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  maxppeak.toString(),
                                  style: TextStyle(
                                      color: Colors.yellow, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  minppeak.toString(),
                                  style: TextStyle(
                                      color: Colors.yellow, fontSize: 12),
                                ),
                                Text(
                                  "MIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ))
                      ],
                    )),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Color(0xFF171e27),
                  width: 180,
                  height: _isTab10 ? 115 : 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Center(
                        child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 10),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              vteValue.toString(),
// "0000",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: _isTab10 ? 40 : 35),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 60),
                            child: Text(
                              "VTe",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isTab10 ? 20 : 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "mL",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "MAX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  maxvte.toString(),
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  // modeName == "VC-CMV" ||
                                  //         modeName == "VACV" ||
                                  //         modeName == "VSIMV"
                                  //     ? vteMinValue.toString()
                                  //     :
                                  minvte.toString(),
                                  ////""
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                ),
                                Text(
                                  "MIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ))
                      ],
                    )),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Color(0xFF171e27),
                  width: 180,
                  height: _isTab10 ? 115 : 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Center(
                        child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("",
                                style: TextStyle(
                                    color: Colors.pink, fontSize: 10)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 10),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              peepDisplayValue.toString(),
// "00",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: _isTab10 ? 40 : 35),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 60),
                            child: Text(
                              "PEEP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isTab10 ? 20 : 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "cmH\u2082O",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "MAX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  maxpeep.toString(),
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  minpeep.toString(),
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 12),
                                ),
                                Text(
                                  "MIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            )),
                      ],
                    )),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Color(0xFF171e27),
                  width: 180,
                  height: _isTab10 ? 115 : 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Center(
                        child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 10)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 10),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              rrDisplayValue.toString(),
// "00",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: _isTab10 ? 40 : 35),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 60),
                            child: Text(
                              "RR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isTab10 ? 20 : 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "bpm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "MAX",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  maxRrtotal.toString(),
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  minRrtotal.toString(),
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                                Text(
                                  "MIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ))
                      ],
                    )),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Color(0xFF171e27),
                  width: 180,
                  height: _isTab10 ? 115 : 85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Center(
                        child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 10)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 10),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              fio2DisplayParameter.toString(),
// "000",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: _isTab10 ? 40 : 35),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, bottom: 55, right: 0.0),
                            child: Text(
                              "FiO\u2082",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isTab10 ? 20 : 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "%",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ))
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  psvBottomBar() {
    return Container(
      color: Color(0xFF171e27),
      width: _isTab10 ? 908 : 700,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            modeName == "CPAP" || operatinModeR == "20"
                ? Container()
                : InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "PS",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      psValue.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "peep".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "cmH\u2082O",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                peepValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "FiO\u2082",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "%",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                fio2Value.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Backup RR",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                rrValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            modeName == "CPAP" || operatinModeR == "20"
                ? Container()
                : InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Backup I:E",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      ieValue.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
            modeName == "AUTO" || operatinModeR == "21"
                ? InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "VT",
                                    style: TextStyle(
                                        fontSize: _isTab10 ? 20 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "mL",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      vtValue.toString(),
                                      style: TextStyle(
                                          fontSize: _isTab10 ? 30 : 30,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            operatinModeR == "21" || modeName == "AUTO"
                ? Container()
                : InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "PC",
                                    style: TextStyle(
                                        fontSize: _isTab10 ? 20 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "cmH\u2082O",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      pcValue.toString(),
                                      style: TextStyle(
                                          fontSize: _isTab10 ? 30 : 30,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
            // InkWell(
            //     onTap: () {

            //     },
            //     child: Center(
            //       child: Container(
            //         width: _isTab10 ? 155 : 120,
            //         height: _isTab10 ? 145 : 110,
            //         child: Card(
            //           elevation: 40,
            //           color:
            //               Color(0xFF213855),
            //           child: Padding(
            //             padding: const EdgeInsets.all(12.0),
            //             child: Center(
            //                 child: Stack(
            //               children: [
            //                 Align(
            //                   alignment: Alignment.topLeft,
            //                   child: Text(
            //                     "VT",
            //                     style: TextStyle(
            //                         fontSize: _isTab10 ? 20 : 18,
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.white),
            //                   ),
            //                 ),
            //                 Align(
            //                   alignment: Alignment.topRight,
            //                   child: Text(
            //                     "mL",
            //                     style: TextStyle(
            //                         fontSize: 12, color: Colors.white),
            //                   ),
            //                 ),
            //                 Align(
            //                   alignment: Alignment.center,
            //                   child: Padding(
            //                     padding:
            //                         const EdgeInsets.only(top: 17.0),
            //                     child: Text(
            //                       vtValue.toString(),
            //                       style: TextStyle(
            //                           fontSize: _isTab10 ? 50 : 30,
            //                           color: Colors.white),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             )),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "I Trig",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "%",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                "-" + itrigValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Apnea Time",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "s",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                atime.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            modeName == "CPAP" || operatinModeR == "20"
                ? Container()
                : InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Ti",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "s",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      getTiValue(int.tryParse(tipsv))
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bottombar() {
    return Container(
      color: Color(0xFF171e27),
      width: _isTab10 ? 908 : 700,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "RR",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "bpm",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                rrValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "I:E".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                ieValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "peep".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "cmH\u2082O",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                peepValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            operatinModeR == "14" || modeName == "PRVC"
                ? InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "PC Max".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      pcValue.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            operatinModeR == "4" ||
                    modeName == "PSIMV" ||
                    operatinModeR == "3" ||
                    modeName == "PSV" ||
                    modeName == "VSIMV" ||
                    operatinModeR == "5"
                ? InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "PS",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "cmH\u2082O",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      psValue.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              operatinModeR == "6" || operatinModeR == "2"
                                  ? "PC"
                                  : operatinModeR == "7" ||
                                          operatinModeR == "1" ||
                                          operatinModeR == "5"
                                      ? "Vt"
                                      : modeName == "PC-CMV" ||
                                              modeName == "PACV"
                                          ? "PC"
                                          : modeName == "VC-CMV" ||
                                                  modeName == "VACV" ||
                                                  modeName == "VSIMV"
                                              ? "Vt"
                                              : operatinModeR == "14" ||
                                                      modeName == "PRVC"
                                                  ? "Target Vt"
                                                  : "PC",
                              style: TextStyle(
                                  fontSize: operatinModeR == "14" ||
                                          modeName == "PRVC"
                                      ? 14
                                      : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              operatinModeR == "6" || operatinModeR == "2"
                                  ? "cmH\u2082O"
                                  : operatinModeR == "7" ||
                                          operatinModeR == "1" ||
                                          operatinModeR == "5" ||
                                          operatinModeR == "14"
                                      ? "ml"
                                      : modeName == "PC-CMV" ||
                                              modeName == "PACV"
                                          ? "cmH\u2082O"
                                          : modeName == "VC-CMV" ||
                                                  modeName == "VACV" ||
                                                  modeName == "VSIMV" ||
                                                  modeName == "PRVC"
                                              ? "ml"
                                              : "cmH\u2082O",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                operatinModeR == "6" || operatinModeR == "2"
                                    ? pcValue.toString()
                                    : operatinModeR == "7" ||
                                            operatinModeR == "1" ||
                                            operatinModeR == "5" ||
                                            operatinModeR == "14"
                                        ? vtValue.toString()
                                        : modeName == "PC-CMV" ||
                                                modeName == "PACV"
                                            ? pcValue.toString()
                                            : modeName == "VC-CMV" ||
                                                    modeName == "VACV" ||
                                                    modeName == "VSIMV" ||
                                                    modeName == "PRVC"
                                                ? vtValue.toString()
                                                : pcValue.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: _isTab10 ? 155 : 120,
                  height: _isTab10 ? 145 : 110,
                  child: Card(
                    elevation: 40,
                    color: Color(0xFF213855),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "FiO\u2082",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "%",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 17.0),
                              child: Text(
                                fio2Value.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ),
            operatinModeR == "1" ||
                    operatinModeR == "2" ||
                    operatinModeR == "3" ||
                    operatinModeR == "4" ||
                    operatinModeR == "5" ||
                    operatinModeR == "14"
                ? InkWell(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: _isTab10 ? 155 : 120,
                        height: _isTab10 ? 145 : 110,
                        child: Card(
                          elevation: 40,
                          color: Color(0xFF213855),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "I Trig",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "%",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17.0),
                                    child: Text(
                                      "-" + itrigValue.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              width: operatinModeR == "4" ||
                      modeName == "PSIMV" ||
                      operatinModeR == "3" ||
                      modeName == "PSV" ||
                      modeName == "VSIMV" ||
                      operatinModeR == "5"
                  ? 10
                  : 130,
            ),
          ],
        ),
      ),
    );
  }

  getTiValue(checkTi) {
    var data = checkTi == 1
        ? "0.5"
        : checkTi == 2
            ? "0.6"
            : checkTi == 3
                ? "0.7"
                : checkTi == 4
                    ? "0.8"
                    : checkTi == 5
                        ? "0.9"
                        : checkTi == 6
                            ? "1.0"
                            : checkTi == 7
                                ? "1.1"
                                : checkTi == 8
                                    ? "1.2"
                                    : checkTi == 9
                                        ? "1.3"
                                        : checkTi == 10
                                            ? "1.4"
                                            : checkTi == 11
                                                ? "1.5"
                                                : checkTi == 12
                                                    ? "1.6"
                                                    : checkTi == 13
                                                        ? "1.7"
                                                        : checkTi == 14
                                                            ? "1.8"
                                                            : checkTi == 15
                                                                ? "1.9"
                                                                : checkTi == 16
                                                                    ? "2.0"
                                                                    : checkTi ==
                                                                            17
                                                                        ? "2.1"
                                                                        : checkTi ==
                                                                                18
                                                                            ? "2.2"
                                                                            : checkTi == 19
                                                                                ? "2.3"
                                                                                : checkTi == 20 ? "2.4" : checkTi == 21 ? "2.5" : checkTi == 22 ? "2.6" : checkTi == 23 ? "2.7" : checkTi == 24 ? "2.8" : checkTi == 25 ? "2.9" : checkTi == 26 ? "3.0" : checkTi == 27 ? "3.1" : checkTi == 28 ? "3.2" : checkTi == 29 ? "3.3" : checkTi == 30 ? "3.4" : checkTi == 31 ? "3.5" : checkTi == 32 ? "3.6" : checkTi == 33 ? "3.7" : checkTi == 34 ? "3.8" : checkTi == 35 ? "3.9" : checkTi == 36 ? "4.0" : checkTi == 37 ? "4.1" : checkTi == 38 ? "4.2" : checkTi == 39 ? "4.3" : checkTi == 40 ? "4.4" : checkTi == 41 ? "4.5" : checkTi == 42 ? "4.6" : checkTi == 43 ? "4.7" : checkTi == 44 ? "4.8" : checkTi == 45 ? "4.9" : checkTi == 46 ? "5.0" : "0.5";

    return data;
  }

  topbar() {
    return Container(
      width: 904,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Icon(Icons.keyboard_arrow_right,
                    size: 40, color: Colors.black.withOpacity(0.9))),
          ),
          Row(
            children: [
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 0, top: 4, bottom: 4),
                child: Text(
                  modeName.toString(),
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 0, top: 4, bottom: 10),
                child: Text(
                  patientName.toString(),
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  graphsScale() {
    return Container(
      padding: EdgeInsets.only(left: 170, right: 0, top: 45),
      child: Column(
        children: [
          Container(
            width: 769,
            height: 150,
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 2, top: 10),
                    child: scopeOne),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 8),
                    child: Text(
                      "100" + " cmH\u2082O",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 15, top: 130),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 28, top: 24),
                  width: 1,
                  color: Colors.grey,
                  height: 116,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 28,
                    top: 138,
                  ),
                  color: Colors.grey,
                  height: 1,
                  width: 728,
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, top: 35),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Pressure",
                          style: TextStyle(color: Colors.grey, fontSize: 10))),
                ),
                Container(
                    margin: EdgeInsets.only(left: 758, top: 128),
                    child: Text(
                      "s",
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          Container(
            width: 769,
            height: 210,
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 10,
                      top: 10,
                      right: 2,
                    ),
                    child: scopeOne1),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      "200 Lpm",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 195),
                    child: Text(
                      "-90 Lpm",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 15, top: 128),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 28, top: 20),
                  width: 1,
                  color: Colors.grey,
                  height: 185,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 28,
                    top: 138,
                  ),
                  color: Colors.grey,
                  height: 1,
                  width: 728,
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, top: 35),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Flow",
                          style: TextStyle(color: Colors.grey, fontSize: 10))),
                ),
                Container(
                    margin: EdgeInsets.only(left: 759, top: 124),
                    child: Text(
                      "s",
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
          ),
          Container(
            width: 769,
            height: 150,
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 2, top: 10),
                    child: scopeOne2),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 8),
                    child: Text(
                      "3000" + " mL",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 15, top: 130),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 28, top: 24),
                  width: 1,
                  color: Colors.grey,
                  height: 116,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 28,
                    top: 138,
                  ),
                  color: Colors.grey,
                  height: 1,
                  width: 728,
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, top: 55),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Volume",
                          style: TextStyle(color: Colors.grey, fontSize: 10))),
                ),
                Container(
                    margin: EdgeInsets.only(left: 758, top: 128),
                    child: Text(
                      "s",
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(left: 40),
                  width: 675,
                  height: 80,
                  child: alarmActive == "1"
                      ? Card(
                          color: alarmActive == "1"
                              ? Colors.red
                              : Color(0xFF171e27),
                          child: Center(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                              child: Text(
                                alarmActive == "1"
                                    ? alarmMessage.toUpperCase()
                                    : "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
