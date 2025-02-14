import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'VentilatorOMode.dart';

class DatabaseHelper {
  static Database _db;
  static const String ID = 'id';
  static const String PATIENTID = 'patientId';
  static const String PATIENTNAME = 'patientName';
  static const String ALARM = 'alarmCodes';
  static const String ALARM_PRIORITY = 'alarmPriority';
  static const String PIPD = 'pipD';
  static const String VTD = 'vtD';
  static const String PEEPD = 'peepD';
  static const String RRD = 'rrD';
  static const String FIO2D = 'fio2D';
  static const String MAPD = 'mapD';
  static const String MVD = 'mvD';
  static const String COMPLAINCED = 'complainceD';
  static const String IED = 'ieD';
  static const String RRS = 'rrS';
  static const String IES = 'ieS';
  static const String PEEPS = 'peepS';
  static const String PSS = 'psS';
  static const String PCS = 'pcS';
  static const String ITRIGS = 'itrigS';
  static const String FIO2S = 'fio2S';
  static const String VT_VALUE = 'vtValueS';
  static const String TIS = 'tiS';
  static const String TES = 'teS';
  static const String ATIMES = 'atimeS';
  static const String TIPSVS = 'tipsvS';
  static const String PRESSURE_POINTS = 'pressureP';
  static const String FLOW_POINTS = 'flowP';
  static const String VOLUME_POINTS = 'volumeP';
  static const String DATE_TIME = 'datetimeP';
  static const String OPERATING_MODE = 'operatingMode';
  static const String LUNG_IMAGE = 'lungImage';
  static const String PAW = 'paw';
  static const String GLOBAL_COUNTER_NO = 'globalCounterNo';
  static const String ALARM_ACTIVE = 'alarmActive';
  static const String PLATEAU = 'pplateauDisplay';

  static const String AMS_DISPLAY = 'amsDisplayParamter';
  static const String LEAK_VOLUME = 'leakVolumeDisplay';
  static const String PEAK_FLOW = 'peakFlowDisplay';
  static const String SPONTANEOUS = 'spontaneousDisplay';

  static const String COUNTER_NO = 'counterNo';
  // static const String DATE_TIME = 'datetime';
  static const String PATIENT_ID = 'patientId';
  static const String PATIENT_NAME = 'patientName';
  static const String PATIENT_AGE = 'patientAge';
  static const String PATIENT_GENDER = 'patientGender';
  static const String PATIENT_HEIGHT = 'patientHeight';
  static const String TABLE_PATIENT = 'apatientTb';
  static const String TABLE_NAME = 'ccounterV';
  static const String TABLE_ALARM = 'calarms';
  static const String TABLE = 'cgraphPoints';
  static const String DATABASE = 'cdb';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory directoryD = await getApplicationDocumentsDirectory();
    String path = join(directoryD.path, DATABASE);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE($ID INTEGER PRIMARY KEY AUTOINCREMENT, $PATIENTID TEXT, $PATIENTNAME TEXT,$PIPD TEXT, $VTD TEXT,$PEEPD TEXT, $RRD TEXT,$FIO2D TEXT,$VT_VALUE TEXT,$MAPD TEXT,$MVD TEXT,$COMPLAINCED TEXT, $IED TEXT,$RRS TEXT,$IES TEXT,$PEEPS TEXT,$PCS TEXT,$PSS TEXT,$ITRIGS TEXT,$FIO2S TEXT,$TIS TEXT,$ATIMES TEXT,$TIPSVS TEXT,$TES TEXT,$PLATEAU TEXT,$PRESSURE_POINTS REAL, $FLOW_POINTS REAL, $VOLUME_POINTS REAL, $DATE_TIME TEXT,$OPERATING_MODE TEXT,$LUNG_IMAGE TEXT,$PAW TEXT,$GLOBAL_COUNTER_NO TEXT,$ALARM,$ALARM_PRIORITY,$ALARM_ACTIVE,$AMS_DISPLAY,$LEAK_VOLUME,$PEAK_FLOW,$SPONTANEOUS)');
    // await db.execute('CREATE TABLE $TABLE_ALARM($ID INTERGER PRIMARY KEY AUTOINCREMENT,$ALARM TEXT,$DATE_TIME TEXT)');
    await db.execute(
        'CREATE TABLE $TABLE_NAME($ID INTERGER PRIMARY KEY,$COUNTER_NO TEXT,$DATE_TIME TEXT)');
    await db.execute(
        'CREATE TABLE $TABLE_PATIENT($ID INTERGER PRIMARY KEY,$PATIENT_ID TEXT,$PATIENT_NAME TEXT,$PATIENT_AGE TEXT,$PATIENT_GENDER TEXT,$PATIENT_HEIGHT TEXT,$DATE_TIME TEXT)');
    // await db.execute(
    //     'CREATE TABLE $TABLE_ALARM($ID INTERGER PRIMARY KEY,$ALARM TEXT,$DATE_TIME TEXT,$GLOBAL_COUNTER_NO TEXT)');
  }

  Future<int> savePatient(PatientsSaveList psl) async {
    var now = DateTime.now();
    try {
      var dbClient = await db;
      var res = await dbClient.rawInsert(
          "INSERT into $TABLE_PATIENT ($PATIENTID,$PATIENTNAME,$PATIENT_AGE,$PATIENT_GENDER,$PATIENT_HEIGHT,$DATE_TIME) VALUES (?,?,?,?,?,?)",
          [
            psl.patientId,
            psl.patientName,
            psl.patientAge,
            psl.patientGender,
            psl.patientHeight,
            DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
          ]);
      //  Fluttertoast.showToast(msg: " patient saved in db "+res.toString());
      return res;
    } catch (Exception) {
      return null;
    }
  }

  Future<int> save(VentilatorOMode vom) async {
    var now = new DateTime.now();
    try {
      var dbClient = await db;
      var res = await dbClient.rawInsert(
          "INSERT into $TABLE ($PATIENTID,$PATIENTNAME,$PIPD,$VTD, $PEEPD, $RRD, $FIO2D, $MAPD, $MVD, $COMPLAINCED,$IED, $RRS, $IES, $PEEPS,$PCS, $PSS,$ITRIGS, $FIO2S,$VT_VALUE,$TIS, $TES,$ATIMES,$TIPSVS,$PLATEAU,$PRESSURE_POINTS,$FLOW_POINTS, $VOLUME_POINTS,$DATE_TIME,$OPERATING_MODE,$LUNG_IMAGE,$PAW,$GLOBAL_COUNTER_NO,$ALARM,$ALARM_PRIORITY,$ALARM_ACTIVE,$AMS_DISPLAY,$LEAK_VOLUME,$PEAK_FLOW,$SPONTANEOUS) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            vom.patientId,
            vom.patientName,
            vom.pipD,
            vom.vtD,
            vom.peepD,
            vom.rrD,
            vom.fio2D,
            vom.mapD,
            vom.mvD,
            vom.complainceD,
            vom.ieD,
            vom.rrS,
            vom.ieS,
            vom.peepS,
            vom.pcS,
            vom.psS,
            vom.itrigS,
            vom.fio2S,
            vom.vtValue,
            vom.tiS,
            vom.teS,
            vom.atimeS,
            vom.tipsvS,
            vom.pplateauDisplay,
            vom.pressureValues,
            vom.flowValues,
            vom.volumeValues,
            DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
            vom.operatingMode,
            vom.lungImage,
            vom.paw,
            vom.globalCounterNo,
            vom.alarmC,
            vom.alarmP,
            vom.alarmActive,
            vom.amsParamter,
            vom.leakVolume,
            vom.peakFlow,
            vom.spontaneous
          ]);
      // print("result data : " + res.toString());
      // Fluttertoast.showToast(msg: " data saved in db "+res.toString());
      return res;
    } catch (Exception) {
      return null;
    }
  }

  Future<List<PatientsList>> getAllPatients() async {
    var dbClient = await db;
    // List<Map> dataData = await dbClient.rawQuery('SELECT DISTINCT $PATIENTID, $PATIENTNAME, MIN($DATE_TIME) minTime, MAX($DATE_TIME) maxTime FROM $TABLE group by $PATIENTID ORDER BY $ID ASC');
    List<Map> dataData = await dbClient.rawQuery(
        'SELECT DISTINCT $PATIENTID,$PATIENTNAME from $TABLE GROUP BY $GLOBAL_COUNTER_NO ORDER BY $ID DESC');
    List<PatientsList> plist = [];
    if (dataData.length > 0) {
      for (int i = 0; i < dataData.length; i++) {
        plist.add(PatientsList.fromMap(dataData[i]));
      }
    }
    return plist;
  }

  Future<List<PatientsList>> patientDatesById(String patientIdD) async {
    var dbClient = await db;
    List<Map> dataData = await dbClient.rawQuery(
        'SELECT DISTINCT date($DATE_TIME) dates from $TABLE  where $PATIENTID = \'$patientIdD\' order by $ID DESC');
    List<PatientsList> plist = [];
    if (dataData.length > 0) {
      for (int i = 0; i < dataData.length; i++) {
        plist.add(PatientsList.fromMap(dataData[i]));
      }
    }
    return plist;
  }

  Future<List<PatientsList>> patientDataByDateId(
      String patientIdD, String dateTimeW) async {
    var dbClient = await db;
    List<Map> dataData = await dbClient.rawQuery(
        'SELECT $PATIENTID, min($DATE_TIME) minTime, max($DATE_TIME) maxTime FROM $TABLE where $PATIENTID= \'$patientIdD\'  AND DATE($DATE_TIME) = DATE(\'$dateTimeW\') order by $ID DESC');
    List<PatientsList> plist = [];
    if (dataData.length > 0) {
      for (int i = 0; i < dataData.length; i++) {
        plist.add(PatientsList.fromMap(dataData[i]));
      }
    }
    return plist;
  }

  Future<List<PatientsList>> splitData(String minTime, String maxTime) async {
    var dbClient = await db;
    var checkValue = 0;

    int noofBoxes = 0;
    List<Map> dataData = await dbClient.rawQuery(
        'SELECT $DATE_TIME dates from $TABLE where $DATE_TIME BETWEEN \'$minTime\' and \'$maxTime\'');

    List<PatientsList> plist = [];
    List<PatientsList> slist = [];
    List<PatientsList> list = [];

    var data = (dataData.length * (0.00025)).toInt();

    if (int.tryParse(
            (dataData.length * (0.00025)).toDouble().toString().split(".")[1]) >
        0) {
      noofBoxes = data + 1;
    } else {
      noofBoxes = data;
    }
    int recordScanner = 0;
    plist.clear();
    slist.clear();
    list.clear();

    for (int i = 0; i < noofBoxes; i++) {
      for (int j = 0; j < 4000; j++) {
        if (recordScanner == dataData.length) {
          break;
        }
        recordScanner++;
        slist.add(PatientsList.fromMap(dataData[checkValue + j]));
      }
      checkValue = checkValue + slist.length;
      list.add(PatientsList("0", "0", slist[0].datetimeP.toString(),
          slist[slist.length - 1].datetimeP.toString(), "0"));
      plist.addAll(list);
      list.clear();
      slist.clear();
    }
    return plist;
  }

  Future<List<VentilatorOMode>> getPatientsData(
      String fromDate, String toDate) async {
    var dbClient = await db;
    //  SELECT * FROM graphPoints WHERE patientId="p002" and datetimeP BETWEEN "24-01-2010 09:02:23"  AND "24-01-2010 09:02:54"
    List<Map> dataData = await dbClient.rawQuery(
        'SELECT * FROM $TABLE where $DATE_TIME BETWEEN \'$fromDate\' AND \'$toDate\'');
    List<VentilatorOMode> plist = [];
    if (dataData.length > 0) {
      for (int i = 0; i < dataData.length; i++) {
        plist.add(VentilatorOMode.fromMap(dataData[i]));
      }
    }
    return plist;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawDelete('DELETE FROM $TABLE WHERE $ID = id');
    return result;
  }

  Future<int> delete7Daysdata(String dateS) async {
    // var now = new DateTime.now();
    var now = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(dateS));
    var dbClient = await db;

    String sql =
        "DELETE FROM $TABLE WHERE $DATE_TIME <= date(\'$now\', '-29 day')";
    // DELETE FROM graphPoints WHERE datetimeP <= date('2020-06-19 20:20:12.00', '-1 day')
    var res = await dbClient.rawDelete(sql);

    return res;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
