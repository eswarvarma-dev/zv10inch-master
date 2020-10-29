import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventilator/activity/Dashboard.dart';
import 'package:ventilator/database/CounterDatabaseHelper.dart';
import 'package:ventilator/database/DatabaseHelper.dart';
// import 'package:ventilator/database/TotalCounterHelper.dart';
// import 'package:ventilator/database/TotalTimeHelper.dart';
import 'package:ventilator/database/VentilatorOMode.dart';

class NewTreatmentScreen extends StatefulWidget {
  int res;
  String patientIdS, globalCounterS;
  NewTreatmentScreen(this.res, this.patientIdS, this.globalCounterS);
  @override
  _NewTreatmentScreenState createState() => _NewTreatmentScreenState();
}

class _NewTreatmentScreenState extends State<NewTreatmentScreen> {
  TextEditingController patientName,
      patientIdno,
      patientAge,
      patientHeight,
      patientWeight;
  bool maleEnabled = true;
  bool femaleEnabled = false;
  // bool ageEnabled = false;
  bool heightEnabled = false;
  bool adultEnabled = true;
  bool _checkedRP = false;
  bool pediatricEnabled = false;
  double commonValue = 0;
  String calculatingIn = "cm";
  SharedPreferences preferences;
  var dbCounter = CounterDatabaseHelper();
  var dbHelper = DatabaseHelper();
  // var totalCounterdbHelper = TotalCounterHelper();
  // var totalTimeHelper = TotalTimeHelper();

  @override
  void initState() {
    super.initState();

    if (widget.patientIdS != "") {
      getPatientData(widget.patientIdS);
    } else {
      setState(() {
        patientName = TextEditingController(text: "");
        patientIdno = TextEditingController(text: widget.globalCounterS);
        patientAge = TextEditingController(text: "");
        patientHeight = TextEditingController(text: "");
        patientWeight = TextEditingController(text: "");
      });
    }
  }

  getPatientData(patientid) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      patientIdno = TextEditingController(text: preferences.getString("pid"));
      patientName = TextEditingController(text: preferences.getString("pname"));
      var mf = preferences.getString("pgender");
      if (mf == "1") {
        maleEnabled = true;
        femaleEnabled = false;
      } else if (mf == "2") {
        femaleEnabled = true;
        maleEnabled = false;
      }
      var pmode = preferences.getString("pmode");
      _checkedRP = preferences.getBool("_iere");
      if (pmode == "1") {
        pediatricEnabled = false;
        adultEnabled = true;
      } else if (pmode == "2") {
        pediatricEnabled = true;
        adultEnabled = false;
      }
      patientAge = TextEditingController(text: preferences.getString("page"));
      patientHeight =
          TextEditingController(text: preferences.getString("pheight"));
      patientWeight =
          TextEditingController(text: preferences.getString("pweight"));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Dashboard()),
                                    ModalRoute.withName('/'));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              "New Patient",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          )
                        ],
                      )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        heightEnabled = false;
                      });
                    },
                    child: Container(
                      width: 210,
                      child: TextFormField(
                        autofocus: true,
                        showCursor: true,
                        onTap: () {
                          setState(() {
                            heightEnabled = false;
                          });
                        },
                        controller: patientName,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        heightEnabled = false;
                      });
                    },
                    child: Container(
                      width: 210,
                      child: TextFormField(
                        showCursor: true,
                        onTap: () {
                          setState(() {
                            heightEnabled = false;
                          });
                        },
                        controller: patientIdno,
                        cursorColor: Color(0xFF171e27),
                        decoration: InputDecoration(
                          labelText: "Patient ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 200,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                maleEnabled = true;
                                femaleEnabled = false;
                                // keyboardEnable = true;
                              });
                            },
                            child: Material(
                              child: Card(
                                  color: maleEnabled
                                      ? Color(0xFF171e27)
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Text(
                                      "Male",
                                      style: TextStyle(
                                          color: maleEnabled
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                maleEnabled = false;
                                femaleEnabled = true;
                                // keyboardEnable = true;
                              });
                            },
                            child: Material(
                              child: Card(
                                  color: femaleEnabled
                                      ? Color(0xFF171e27)
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Text(
                                      "Female",
                                      style: TextStyle(
                                          color: femaleEnabled
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Container(
                        width: 230,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  adultEnabled = true;
                                  pediatricEnabled = false;
                                  // keyboardEnable = true;
                                });
                              },
                              child: Material(
                                child: Card(
                                    color: adultEnabled
                                        ? Color(0xFF171e27)
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Text(
                                        "Adult",
                                        style: TextStyle(
                                            color: adultEnabled
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  adultEnabled = false;
                                  pediatricEnabled = true;
                                  // keyboardEnable = true;
                                });
                              },
                              child: Material(
                                child: Card(
                                    color: pediatricEnabled
                                        ? Color(0xFF171e27)
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Text(
                                        "Pediatric",
                                        style: TextStyle(
                                            color: pediatricEnabled
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 36, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        heightEnabled = false;
                      });
                    },
                    child: Container(
                      width: 250,
                      child: TextFormField(
                        showCursor: true,
                        maxLength: 3,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        controller: patientAge,
                        decoration: InputDecoration(
                          labelText: "Age",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            heightEnabled = true;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Container(
                          width: 120,
                          child: TextFormField(
                            showCursor: true,
                            readOnly: true,
                            enabled: false,
                            maxLines: 1,
                            controller: patientHeight,
                            decoration: InputDecoration(
                              labelText: "Height",
                              suffixText: calculatingIn,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            heightEnabled = true;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Container(
                          width: 120,
                          child: TextFormField(
                            showCursor: true,
                            readOnly: true,
                            enabled: false,
                            maxLines: 1,
                            controller: patientWeight,
                            decoration: InputDecoration(
                              labelText: "IBW",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 230,
                      child: Row(
                        children: <Widget>[
                          Text("Respiratory Pause",style: TextStyle(fontSize: 20),),
                          Checkbox(
                                  value: _checkedRP, 
                                  activeColor: Colors.green,
                                  checkColor: Colors.black,
                                  onChanged: (bool value){
                                    setState(() {
                                      _checkedRP = value;
                                    });
                                  }),
                        ],
                      ),
                       ),
                  InkWell(
                    onTap: () {
                      savePatientData();
                    },
                    child: Container(
                      width: 250,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(5)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: heightEnabled ? 0 : 21,
            ),
            heightEnabled
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 310,
                          child: CupertinoPicker(
                              itemExtent: 30,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  patientHeight = TextEditingController(
                                      text: getDataheight(index).toString());

                                  if (80 < getDataheight(index) &&
                                      getDataheight(index) <= 128) {
                                    setState(() {
                                      patientWeight = TextEditingController(
                                          text:
                                              (((0.0037 * getDataheight(index) -
                                                              0.4018) *
                                                          getDataheight(
                                                              index)) +
                                                      18.62)
                                                  .toInt()
                                                  .toString());
                                    });
                                  } else if (129 <= getDataheight(index) &&
                                      getDataheight(index) < 265) {
                                    setState(() {
                                      maleEnabled == true
                                          ? patientWeight =
                                              TextEditingController(
                                                  text: ((0.9079 *
                                                              getDataheight(
                                                                  index)) -
                                                          88.022)
                                                      .toInt()
                                                      .toString())
                                          : femaleEnabled == true
                                              ? patientWeight =
                                                  TextEditingController(
                                                      text: ((0.9049 *
                                                                  getDataheight(
                                                                      index)) -
                                                              88.022)
                                                          .toInt()
                                                          .toString())
                                              : TextEditingController(
                                                  text: 0.toString());
                                    });
                                  }
                                });
                              },
                              children: List.generate(
                                  186,
                                  (index) => Center(
                                        child: Text(
                                            (getDataheight(index)).toString()),
                                      ))),
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  getDataheight(index) {
    return index == 0
        ? 80
        : index == 1
            ? 81
            : index == 2
                ? 82
                : index == 3
                    ? 83
                    : index == 4
                        ? 84
                        : index == 5
                            ? 85
                            : index == 6
                                ? 86
                                : index == 7
                                    ? 87
                                    : index == 8
                                        ? 88
                                        : index == 9
                                            ? 89
                                            : index == 10
                                                ? 90
                                                : index == 11
                                                    ? 91
                                                    : index == 12
                                                        ? 92
                                                        : index == 13
                                                            ? 93
                                                            : index == 14
                                                                ? 94
                                                                : index == 15
                                                                    ? 95
                                                                    : index ==
                                                                            16
                                                                        ? 96
                                                                        : index ==
                                                                                17
                                                                            ? 97
                                                                            : index == 18
                                                                                ? 98
                                                                                : index == 19 ? 99 : index == 20 ? 100 : index == 21 ? 101 : index == 22 ? 102 : index == 23 ? 103 : index == 24 ? 104 : index == 25 ? 105 : index == 26 ? 106 : index == 27 ? 107 : index == 28 ? 108 : index == 29 ? 109 : index == 30 ? 110 : index == 31 ? 111 : index == 32 ? 112 : index == 33 ? 113 : index == 34 ? 114 : index == 35 ? 115 : index == 36 ? 116 : index == 37 ? 117 : index == 38 ? 118 : index == 39 ? 119 : index == 40 ? 120 : index == 41 ? 121 : index == 42 ? 122 : index == 43 ? 123 : index == 44 ? 124 : index == 45 ? 125 : index == 46 ? 126 : index == 47 ? 127 : index == 48 ? 128 : index == 49 ? 129 : index == 50 ? 130 : index == 51 ? 131 : index == 52 ? 132 : index == 53 ? 133 : index == 54 ? 134 : index == 55 ? 135 : index == 56 ? 136 : index == 57 ? 137 : index == 58 ? 138 : index == 59 ? 139 : index == 60 ? 140 : index == 61 ? 141 : index == 62 ? 142 : index == 63 ? 143 : index == 64 ? 144 : index == 65 ? 145 : index == 66 ? 146 : index == 67 ? 147 : index == 68 ? 148 : index == 69 ? 149 : index == 70 ? 150 : index == 71 ? 151 : index == 72 ? 152 : index == 73 ? 153 : index == 74 ? 154 : index == 75 ? 155 : index == 76 ? 156 : index == 77 ? 157 : index == 78 ? 158 : index == 79 ? 159 : index == 80 ? 160 : index == 81 ? 161 : index == 82 ? 162 : index == 83 ? 163 : index == 84 ? 164 : index == 85 ? 165 : index == 86 ? 166 : index == 87 ? 167 : index == 88 ? 168 : index == 89 ? 169 
                                                                                : index == 90 ? 170 
                                                                                : index == 91 ? 171 
                                                                                : index == 92 ? 172 
                                                                                : index == 93 ? 173 
                                                                                : index == 94 ? 174 
                                                                                : index == 95 ? 175 
                                                                                : index == 96 ? 176 
                                                                                : index == 97 ? 177 
                                                                                : index == 98 ? 178 
                                                                                : index == 99 ? 179 
                                                                                : index == 100 ? 180 
                                                                                : index == 101 ? 181 
                                                                                : index == 102 ? 182 
                                                                                : index == 103 ? 183 
                                                                                : index == 104 ? 184 
                                                                                : index == 105 ? 185 
                                                                                : index == 106 ? 186 
                                                                                : index == 107 ? 187 
                                                                                : index == 108 ? 188 
                                                                                : index == 109 ? 189 
                                                                                : index == 110 ? 190 
                                                                                : index == 111 ? 191 
                                                                                : index == 112 ? 192 
                                                                                : index == 113 ? 193 
                                                                                : index == 114 ? 194 
                                                                                : index == 115 ? 195 
                                                                                : index == 116 ? 196 
                                                                                : index == 117 ? 197 
                                                                                : index == 118 ? 198 
                                                                                : index == 119 ? 199 
                                                                                : index == 120 ? 200 
                                                                                : index == 121 ? 201 
                                                                                : index == 122 ? 202 
                                                                                : index == 123 ? 203 
                                                                                : index == 124 ? 204 
                                                                                : index == 125 ? 205 
                                                                                : index == 126 ? 206 
                                                                                : index == 127 ? 207 
                                                                                : index == 128 ? 208 
                                                                                : index == 129 ? 209 
                                                                                : index == 130 ? 210 
                                                                                : index == 131 ? 211 
                                                                                : index == 132 ? 212 
                                                                                : index == 133 ? 213 
                                                                                : index == 134 ? 214 
                                                                                : index == 135 ? 215 
                                                                                : index == 136 ? 216 
                                                                                : index == 137 ? 217 
                                                                                : index == 138 ? 218 
                                                                                : index == 139 ? 219 
                                                                                : index == 140 ? 220 
                                                                                : index == 141 ? 221 
                                                                                : index == 142 ? 222 
                                                                                : index == 143 ? 223 
                                                                                : index == 144 ? 224 
                                                                                : index == 145 ? 225 
                                                                                : index == 146 ? 226 
                                                                                : index == 147 ? 227
                                                                                : index == 148 ? 228 
                                                                                : index == 149 ? 229 
                                                                                : index == 150 ? 230 
                                                                                : index == 151 ? 231 
                                                                                : index == 152 ? 232 
                                                                                : index == 153 ? 233 
                                                                                : index == 154 ? 234
                                                                                : index == 155 ? 235 
                                                                                : index == 156 ? 236 
                                                                                : index == 157 ? 237 
                                                                                : index == 158 ? 238 
                                                                                : index == 159 ? 239 
                                                                                : index == 160 ? 240 
                                                                                : index == 161 ? 241 
                                                                                : index == 162 ? 242 
                                                                                : index == 163 ? 243 
                                                                                : index == 164 ? 244 
                                                                                : index == 165 ? 245 
                                                                                : index == 166 ? 246 
                                                                                : index == 167 ? 247 
                                                                                : index == 168 ? 248 
                                                                                : index == 169 ? 249 
                                                                                : index == 170 ? 250 
                                                                                : index == 171 ? 251 
                                                                                : index == 172 ? 252 
                                                                                : index == 173 ? 253 
                                                                                : index == 174 ? 254 
                                                                                : index == 175 ? 255 
                                                                                : index == 176 ? 256 
                                                                                : index == 177 ? 257 
                                                                                : index == 178 ? 258 
                                                                                : index == 179 ? 259 
                                                                                : index == 180 ? 260 
                                                                                : index == 181 ? 261 
                                                                                : index == 182 ? 262 
                                                                                : index == 183 ? 263 
                                                                                : index == 184 ? 264 
                                                                                : index == 185 ? 265 
                                                                                : "";
  }

  savePatientData() async {
    if (patientIdno.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Patient ID");
    } else if (patientName.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Patient Name");
    } else {
      var result = dbHelper.savePatient(PatientsSaveList(
          patientIdno.text,
          patientName.text,
          patientAge.text.toString(),
          maleEnabled ? "1" : "2",
          patientHeight.text));
      print(result);
      preferences = await SharedPreferences.getInstance();
     
      if (patientIdno.text != preferences.getString("pid")) {
        

        // if(preferences.getString("_firstRecordTime")!=""){
        //   var now = new DateTime.now();
        // var _lastRecordTime =
        //     DateFormat("yyyy-MM-dd HH:mm:ss").format(now).toString();
        // DateTime date1 =
        //     DateFormat("yyyy-MM-dd HH:mm:ss").parse(_lastRecordTime);
        // DateTime date2 = DateFormat("yyyy-MM-dd HH:mm:ss")
        //     .parse(preferences.getString("_firstRecordTime"));
        // var differnceD = date1.difference(date2);
        // var counterNo = await dbCounter.getCounterNo();
        // preferences.setString("_firstRecordTime", _lastRecordTime);
        // totalCounterdbHelper.saveTotalHourseRecords(TotalCounter(
        //     preferences.getString("_firstRecordTime"),
        //     _lastRecordTime,
        //     preferences.getString("pid"),
        //     counterNo.toString(),
        //     differnceD.inHours.toString()));
        // totalCounterdbHelper.saveTotalHourseRecords(TotalCounter(_lastRecordTime, "",patientIdno.text.toString(), counterNo.toString(), ""));
        // }
      }
       preferences.setString("pid", patientIdno.text.toString());
      preferences.setString("pname", patientName.text.toString());
      preferences.setString(
          "pgender", maleEnabled ? "1" : femaleEnabled ? "2" : "0");
      preferences.setString(
          "pmode", adultEnabled ? "1" : pediatricEnabled ? "2" : "0");
      preferences.setString("page", patientAge.text.toString());
      preferences.setString("pheight", patientHeight.text.toString());
      preferences.setString("pweight", patientWeight.text.toString());
      preferences.setBool('_iere', _checkedRP);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
          ModalRoute.withName('/'));
    }
  }
}