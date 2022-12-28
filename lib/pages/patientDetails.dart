import 'dart:io';

import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utsarjan/charts/charts.dart';
import 'package:utsarjan/model/doctorDataModel.dart';
import 'package:utsarjan/model/medicationModel.dart';
import 'package:utsarjan/model/notifyDataModel.dart';
import 'package:utsarjan/model/patientDataModel.dart';
import 'package:utsarjan/model/patientHistoryDataModel.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/pages/adviceComplaintPage.dart';

// import 'package:utsarjan/pages/home.dart';
import 'package:utsarjan/pages/medicationgetPage.dart';
import 'package:utsarjan/pages/notificationsPage.dart';
import 'package:utsarjan/pages/popupDetailsPage.dart';
import 'package:utsarjan/pages/testNotifications.dart';
import 'package:utsarjan/pages/testsPage.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:utsarjan/services/medicineServices.dart';
import 'package:utsarjan/services/notificationServices.dart';
import 'package:utsarjan/services/patientSevices.dart';
import 'package:age/age.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'addDoctor.dart';

class PatientDetails extends StatefulWidget {
  final Patient patient;
  final bool isRefresh;

  const PatientDetails({this.patient, this.isRefresh});

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  bool loading = false;

  final dateFormat = DateFormat("MMMM d,yyyy");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Patient patient;
  List<PatientData> patientDataList;
  List<PatientHistory> patientHistoryData;
  List<DoctorData> doctorsDataList;
  List<MedicineData> medicationList = [];
  String notifications;
  String username;
  DoctorData doctorData;
  Notifications notify = new Notifications();
  bool status = true;
  String notificationString = '';

  DateTime currentDate = DateTime.now();
  List<PatientHistory> dummyDataList = [
    PatientHistory(
        systolicBP: 120,
        diastolicBP: 70,
        urineProtein: 3,
        bodyHeight: 52,
        bodyWeight: 3.4,
        bmi: 0,
        date: DateTime.parse('2020-01-10 10:29:04Z').toLocal(),
        comments: "dizziness,headache"),
  ];
  var minDate = DateTime.now().subtract(new Duration(days: 50));
  var maxDate = DateTime.now().add(new Duration(days: 10));

  //var date1=new DateTime.now();
  //var date2=date1.toUtc();
//final month=DateFormat.MMMd("en_us");
  Map monthMap = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  Map dateMap = {
    1: "st",
    2: "nd",
    3: "rd",
    4: "th",
    5: "th",
    6: "th",
    7: "th",
    8: "th",
    9: "th",
    10: "th",
    11: "th",
    12: "th",
    13: "th",
    14: "th",
    15: "th",
    16: "th",
    17: "th",
    18: "th",
    19: "th",
    20: "th",
    21: "st",
    22: "nd",
    23: "rd",
    24: "th",
    25: "th",
    26: "th",
    27: "th",
    28: "th",
    29: "th",
    30: "th",
    31: "st",
    32: "st"
  };

  @override
  void initState() {
    // patientHistoryData = dummyDataList;
    patient = widget.patient;
    username = patient.username;

    getDetails();

    super.initState();
  }

  void getDetails() {
    patientDetails(username).then((patientDetail) {
      AgeDuration age = Age.dateDifference(
          fromDate: DateTime.parse(patientDetail.dob),
          toDate: currentDate,
          includeToDate: false);
      AgeDuration monthsOnSet = Age.dateDifference(
          fromDate: DateTime.parse(patientDetail.dateOfOnset),
          toDate: currentDate,
          includeToDate: false);
      if (this.mounted)
        setState(() {
          patient = patientDetail;
          patient.currentCategory = patientDetail.currentCategory != null
              ? patientDetail.currentCategory
              : patientDetail.previousCategory;
          patient.monthsOnSet =
              '${(monthsOnSet.years)} yr, ${(monthsOnSet.months)} mo';
          patient.age = '${(age.years)} yr, ${(age.months)} mo';
        });
    });
    patientHistory(username).then((responseHistoryData) {
      if (this.mounted)
        setState(() {
          if (responseHistoryData != null && responseHistoryData.length > 0)
            patientHistoryData = responseHistoryData;
        });
    });
    patientData(username).then((patientData) {
      if (this.mounted)
        setState(() {
          patientDataList = patientData;
        });
    });
    getPatientDataByDoctor(username).then((patientDataByDoctor) {
      if (this.mounted)
        setState(() {
          //  print(patientDataByDoctor[0]);
          doctorsDataList = patientDataByDoctor;
        });
    });
    getAllMedicines(username).then((medicineData) {
      // print(medicineListToJson(medicineData));
      setState(() {
        if (medicineData != null) medicationList = medicineData;
      });
    });
  }

  void notifyPatient(setState) {
    setState(() {
      loading = true;
    });
    notify.username = username;
    notify.date = DateTime.now();
    notify.patientName = patient.name;
    notify.doctorName = patient.doctorName;
    notify.doctorId = patient.doctorMobile;
    notify.patientId = username;
    print(notificationsToJson(notify));
    addNotifyByDoctor(notify).then((notification) {
      setState(() {
        loading = false;
      });
      showToast(AppLocalizations.of(context).sendNotificationSuccessfully);
      print("**********************************");
      Navigator.pop(context);
    });
  }

  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  void updateMedicine() {
    getAllMedicines(username).then((medicineData) {
      // print(medicineListToJson(medicineData));
      setState(() {
        if (medicineData != null) medicationList = medicineData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isChanged = DateFormat('yyyy-mm-dd').format(maxDate) ==
            DateFormat('yyyy-mm-dd')
                .format(DateTime.now().add(new Duration(days: 10)))
        ? false
        : true;
    List<UrineProtineData> newUrineProtineData = [];
    int patientDataLength =
        (patientDataList != null) ? patientDataList.length : 0;
    if (patientDataLength > 0)
      for (int i = 0; i < patientDataLength; i++) {
        Color color;
        if (patientDataList[i].urineProtein == 0)
          color = Colors.green;
        else if (patientDataList[i].urineProtein == 1)
          color = Colors.yellow;
        else if (patientDataList[i].urineProtein == 2)
          color = Colors.yellow;
        else if (patientDataList[i].urineProtein == 3)
          color = Colors.red;
        else if (patientDataList[i].urineProtein == 4)
          color = Colors.red;
        else
          color = Color(0xffe2e856e);
        newUrineProtineData.add(UrineProtineData(
            DateTime.parse(patientDataList[i].day),
            patientDataList[i].urineProtein,
            color));
      }
    else {
      newUrineProtineData
          .add(UrineProtineData(DateTime(5), 0, Color(0xffe2e856e)));
      newUrineProtineData
          .add(UrineProtineData(DateTime(7), 1, Color(0xffe2e856e)));
      newUrineProtineData
          .add(UrineProtineData(DateTime(9), 2, Color(0xffe2e856e)));

      newUrineProtineData.add(UrineProtineData(DateTime(10), 3, Colors.red));
      newUrineProtineData.add(UrineProtineData(DateTime(15), 3, Colors.red));

      newUrineProtineData.add(UrineProtineData(DateTime(20), 3, Colors.red));
      newUrineProtineData
          .add(UrineProtineData(DateTime(25), 0, Color(0xffe2e856e)));
    }

    Color _getUrineMeasurementColor(urineProtein) {
      Color color;
      if (urineProtein == 3 || urineProtein == 4) {
        color = Colors.red;
      } else {
        color = Colors.black;
      }
      return color;
    }

    List<MedicineDosage> newMedicineDosageData = [];
    if (patientDataLength > 0)
      for (int i = 0; i < patientDataLength; i++) {
        // if(patientDataList[i].medicineDosage!=0) {
        newMedicineDosageData.add(MedicineDosage(
            DateTime.parse(patientDataList[i].day),
            patientDataList[i].medicineDosage,
            Colors.greenAccent));
        // }
      }
    else {
      newMedicineDosageData
          .add(MedicineDosage(DateTime(5), 10, Colors.greenAccent));
      newMedicineDosageData
          .add(MedicineDosage(DateTime(20), 20, Colors.greenAccent));
      newMedicineDosageData
          .add(MedicineDosage(DateTime(25), 30, Colors.greenAccent));
    }

    List<DiastolicBp> newDiastolicBPData = [];
    int doctorDataLength =
        (doctorsDataList != null) ? doctorsDataList.length : 0;
    if (doctorDataLength > 0 && patientDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        Color color;
        if (doctorsDataList[i].diastolicBP != null) {
          color = Color(int.parse(doctorsDataList[i].diastolicBPGraphColor));
          newDiastolicBPData.add(DiastolicBp(
              DateTime.parse(doctorsDataList[i].day),
              doctorsDataList[i].diastolicBP,
              color));
        }
      }
    else {
      // newDiastolicBPData.add(DiastolicBp(
      //     minDate.subtract(new Duration(days: 1)), 70, Colors.lightBlue[200]));
      // newDiastolicBPData.add(DiastolicBp(minDate, 80, Colors.lightBlue[200]));
      // newDiastolicBPData.add(DiastolicBp(
      //     minDate.add(new Duration(days: 1)), 85, Colors.lightBlue[200]));
      // newDiastolicBPData.add(
      //     DiastolicBp(minDate.add(new Duration(days: 2)), 87, Colors.yellow));
      // newDiastolicBPData.add(
      //     DiastolicBp(minDate.add(new Duration(days: 3)), 150, Colors.red));
    }

    List<SystolicBP> newSystolicBPData = [];
    if (doctorDataLength > 0 && patientDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        Color color;
// print(doctorsDataList[i].systolicBP);
        if (doctorsDataList[i].systolicBP != null) {
          color = Color(int.parse(doctorsDataList[i].systolicBPGraphColor));
          newSystolicBPData.add(SystolicBP(
              DateTime.parse(doctorsDataList[i].day),
              doctorsDataList[i].systolicBP,
              color));
        }
      }
    else {
      // newSystolicBPData.add(SystolicBP(
      //     minDate.subtract(new Duration(days: 1)), 100, Colors.blue));
      // newSystolicBPData.add(SystolicBP(minDate, 120, Colors.blue));
      // newSystolicBPData.add(
      //     SystolicBP(minDate.add(new Duration(days: 1)), 130, Colors.blue));
      // newSystolicBPData.add(
      //     SystolicBP(minDate.add(new Duration(days: 2)), 140, Colors.yellow));
      // newSystolicBPData
      //     .add(SystolicBP(minDate.add(new Duration(days: 3)), 180, Colors.red));
    }

    List<Height> newHeightData = [];
    if (doctorDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        if (doctorsDataList[i].bodyHeight != null) {
          Color color = Color(int.parse(doctorsDataList[i].heightGraphColor));
          newHeightData.add(Height(DateTime.parse(doctorsDataList[i].day),
              doctorsDataList[i].bodyHeight, color));
        }
        // newHeightData.add(Height(
        //     calculateBMIOfUser
        //         doctorsDataList[i].bodyHeight, doctorsDataList[i].bodyWeight),
        //     doctorsDataList[i].bodyHeight,
        //     Colors.red));
      }
    else {
      // newHeightData.add(
      //     Height(minDate.subtract(new Duration(days: 1)), 45.4, Colors.yellow));
      // newHeightData.add(Height(minDate, 47.3, Colors.purple));
      // newHeightData
      //     .add(Height(minDate.add(new Duration(days: 1)), 49.1, Colors.purple));
      // newHeightData
      //     .add(Height(minDate.add(new Duration(days: 2)), 51.0, Colors.purple));
      // newHeightData
      //     .add(Height(minDate.add(new Duration(days: 3)), 52.9, Colors.red));
    }

    List<Weight> newWeightData = [];
    if (doctorDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        if (doctorsDataList[i].bodyWeight != null) {
          Color color = Color(int.parse(doctorsDataList[i].weightGraphColor));
          newWeightData.add(Weight(DateTime.parse(doctorsDataList[i].day),
              doctorsDataList[i].bodyWeight, color));
        }
      }
    else {
      // newWeightData.add(
      //     Weight(minDate.subtract(new Duration(days: 1)), 2.4, Colors.yellow));
      // newWeightData.add(Weight(minDate, 2.8, Colors.purpleAccent[100]));
      // newWeightData.add(Weight(
      //     minDate.add(new Duration(days: 1)), 3.2, Colors.purpleAccent[100]));
      // newWeightData.add(Weight(
      //     minDate.add(new Duration(days: 2)), 3.7, Colors.purpleAccent[100]));
      // newWeightData
      //     .add(Weight(minDate.add(new Duration(days: 3)), 4.2, Colors.red));
    }
    List<Bmi> newBmi = [];
    if (doctorDataLength > 0 && patientDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        if (doctorsDataList[i].bmi != null) {
          Color color = Color(int.parse(doctorsDataList[i].bmiGraphColor));
          newBmi.add(Bmi(DateTime.parse(doctorsDataList[i].day),
              doctorsDataList[i].bmi, color));
        }
        ;
      }
    else {
      // newBmi.add(
      //     Bmi(minDate.subtract(new Duration(days: 1)), 11.1, Colors.yellow));
      // newBmi.add(Bmi(minDate, 12.2, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 1)), 13.3, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 2)), 14.6, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 3)), 16.1, Colors.red));
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).patientDetails),
          backgroundColor: Colors.red[200],
          actions: <Widget>[
            PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: InkWell(
                        child: Row(children: <Widget>[
                          new Image.asset('images/refresh.png',
                              width: 35.0, height: 40.0),

                          //Icon(Icons.notifications),
                          Text(" "+ AppLocalizations.of(context).refresh),
                        ]),
                        onTap: () {
                          // Navigator.popUntil(context, ModalRoute.withName('/patientDetails'));
                        },
                      )),
                      // PopupMenuItem(
                      //     child: InkWell(
                      //         child: Row(children: <Widget>[
                      //           new Image.asset('images/complicated_images.png',
                      //               width: 30.0, height: 35.0),
                      //               SizedBox(width: 1,),
                      //           Text("  Complication Images"),
                      //         ]),
                      //         onTap: () {})),
                      PopupMenuItem(
                          child: InkWell(
                              child: Row(children: <Widget>[
                                new Image.asset('images/notification.png',
                                    width: 30.0, height: 35.0),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("  "+AppLocalizations.of(context).notifications),
                              ]),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationsPage(
                                              patientId: username,
                                              isFrom: AppLocalizations.of(context).notifications,
                                            )));
                              })),
                      PopupMenuItem(
                          child: InkWell(
                              child: Row(children: <Widget>[
                                new Image.asset('images/ic_report.jpeg',
                                    width: 30.0, height: 35.0),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("  "+AppLocalizations.of(context).reports),
                              ]),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationsPage(
                                              patientId: username,
                                              isFrom: "Reports",
                                            )));
                              })),
                      PopupMenuItem(
                          child: InkWell(
                              child: Row(children: <Widget>[
                                new Image.asset('images/Advice_Complaint.png',
                                    width: 30.0, height: 35.0),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("  "+AppLocalizations.of(context).adviceComplaint),
                              ]),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AdviceComplaintPage(
                                          currentPatient: patient,
                                        )));
                              })),
                      PopupMenuItem(
                          child: InkWell(
                              child: Row(children: <Widget>[
                                new Image.asset('images/test-tube.png',
                                    width: 30.0, height: 35.0),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("  "+AppLocalizations.of(context).tests),
                              ]),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TestNotifications(
                                          patientId: username,
                                        )));
                              })),

                      PopupMenuItem(
                          child: InkWell(
                        child: Row(
                          children: <Widget>[
                            new Image.asset('images/check-up.png',
                                width: 35.0, height: 40.0),
                            Text(" "+AppLocalizations.of(context).details),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PopupdetailsPage(
                                        username: patient.username,
                                      )));
                        },
                      )),
                      PopupMenuItem(
                          child: InkWell(
                        child: Row(children: <Widget>[
                          new Image.asset('images/logout.png',
                              width: 35.0, height: 40.0),
                          Text(" "+AppLocalizations.of(context).logout),
                        ]),
                        onTap: () {
                          SharedPreferences.getInstance().then((onValue) {
                            onValue.clear();
                          });

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomePage()));
                        },
                      )),
                    ])
          ],
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              elevation: 4,

              // child: Material(
              //     elevation: 5,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              //     child: Container(
              //       // height: 110,
              //       //width: 90,
              //       decoration: new BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           boxShadow: [
              //             BoxShadow(blurRadius: 40.0, color: Colors.transparent)
              //           ]),
              //       child: Padding(
              //         padding: const EdgeInsets.only(
              //             top: 10, left: 20, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                new Image.asset('images/ptprofile.png',
                    width: 80.0, height: 80.0),
                Expanded(
                  child: Table(
                      // columnWidths: ,
                      children: [
                        TableRow(
                          children: [
                            Text(AppLocalizations.of(context).name+':'),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  (patient != null && patient.name != null)
                                      ? patient.name
                                      : "",
                                  softWrap: true,
                                )),
                                if (patient != null && patient.status != null)
                                  new Image.asset('images/correct.png',
                                      width: 17.0, height: 17.0),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(AppLocalizations.of(context).category+':'),
                            Text((patient != null &&
                                    patient.currentCategory != null)
                                ? patient.currentCategory
                                : ''),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(AppLocalizations.of(context).doctorName+':'),
                            Text((patient != null && patient.doctorName != null)
                                ? patient.doctorName
                                : ""),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(AppLocalizations.of(context).patientMobile+':'),
                            Row(
                              children: <Widget>[
                                Text((patient != null &&
                                        patient.doctorMobile != null)
                                    ? patient.username
                                    : ""),
                                Expanded(
                                  child: InkWell(
                                    child: new Image.asset('images/call.png',
                                        width: 17.0, height: 17.0),
                                    onTap: () =>
                                        launch("tel:${patient.username}"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(AppLocalizations.of(context).relapseYr+':'),
                            Text((patient != null && patient.relapse != null)
                                ? patient.relapse.toString()
                                : ""),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              AppLocalizations.of(context).ageAtOnset+':',
                            ),
                            Text(
                                (patient != null && patient.monthsOnSet != null)
                                    ? patient.monthsOnSet.toString()
                                    : "")
                          ],
                        ),
                        TableRow(children: [
                          Text(AppLocalizations.of(context).currentAge+":", textAlign: TextAlign.start),
                          Row(
                            children: <Widget>[
                              Text((patient != null && patient.age != null)
                                  ? patient.age.toString()
                                  // "${patient.age.split('.')[0].toString()} yr, ${patient.age.split('.')[1].toString()} mo"

                                  //  patient.age
                                  : ""),
                            ],
                          ),
                        ])
                      ]),

                  // child: Padding(
                  //     padding: const EdgeInsets.all(5.0),
                  //     child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: <Widget>[
                  //           Row(
                  //               //mainAxisAlignment: MainAxisAlignment.start,
                  //               //crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Expanded(
                  //                   flex: 3,
                  //                   child: Text(
                  //                     "Name :",
                  //                   ),
                  //                 ),
                  //                 Expanded(
                  //                   child: Text((patient != null &&
                  //                           patient.name != null)
                  //                       ? patient.name
                  //                       : ""),
                  //                 ),
                  //                 new Image.asset(
                  //                     (patient != null) &&
                  //                             patient.status != null
                  //                         ? 'images/correct.png'
                  //                         : "",
                  //                     width: 20.0,
                  //                     height: 20.0),
                  //               ]),
                  //           //SizedBox(height: 10),
                  //           Row(children: <Widget>[
                  //             Expanded(
                  //               flex: 2,
                  //               child: Text("Category :"),
                  //             ),
                  //             Expanded(
                  //               child: Text((patient != null &&
                  //                       patient.category != null)
                  //                   ? patient.category
                  //                   : ""),
                  //             )
                  //           ]),
                  //           // SizedBox(height: 10),
                  //           Row(children: <Widget>[
                  //             Expanded(
                  //               flex: 2,
                  //               child: Text("Doctor Name :"),
                  //             ),
                  //             Expanded(
                  //               child: Text((patient != null &&
                  //                       patient.doctorName != null)
                  //                   ? patient.doctorName
                  //                   : ""),
                  //             )
                  //           ]),
                  //           //SizedBox(height: 10),
                  //           Row(
                  //               //mainAxisAlignment: MainAxisAlignment.end,
                  //               //crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: <Widget>[
                  //                 Text("Doctor Mobile :              "),
                  //                 Expanded(
                  //                   flex: 2,
                  //                   child: Text((patient != null &&
                  //                           patient.doctorMobile != null)
                  //                       ? patient.doctorMobile
                  //                       : ""),
                  //                 ),
                  //                 Expanded(
                  //                   child: InkWell(
                  //                     child: new Image.asset('images/call.png',
                  //                         width: 20.0, height: 20.0),
                  //                     onTap: () => launch("tel://9582700727"),
                  //                   ),
                  //                 ),
                  //               ]),
                  //           //SizedBox(height: 10),
                  //           Row(children: <Widget>[
                  //             Text(
                  //                 "Relapses/year :                           "),
                  //             Text((patient != null && patient.relapse != null)
                  //                 ? "${patient.relapse}"
                  //                 : ""),
                  //           ]),
                  //           // SizedBox(height: 10),
                  //           Row(children: <Widget>[
                  //             Text("Age (years) at onset  :                 "),
                  //             Text((patient != null && patient.age != null)
                  //                 ? patient.age.toString()
                  //                 : "")
                  //           ]),

                  //           //SizedBox(height: 10),
                  //           Row(children: <Widget>[
                  //             Text("Current Age (years,months) :     "),
                  //             Text((patient != null && patient.age != null)
                  //                 ? "${patient.age}"
                  //                 : ""),
                  //           ]),
                  //         ])),
                ),
              ]),
            ),
          ),
          Expanded(
              child: CustomScrollView(primary: false, slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                        child: Text(
                          AppLocalizations.of(context).addData,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDoctor(
                                      currentPatient: patient,
                                    )),
                          );
                        },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],)
                    ),
                    ),
                  ),
                  OutlinedButton(
                      child: Text(
                        AppLocalizations.of(context).medications,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Medicationget(
                                patientId: patient.username,
                                isFrom: "Doctor")));

                        /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MedicationPage(
                                  currentPatient: patient,
                                   updateMedicine:updateMedicine
                                )));*/
                      },style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red[200],)
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      child: Text(
                        AppLocalizations.of(context).notify,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        _showDialog(AppLocalizations.of(context).send, context);
                      },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.red[200],)
                        ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                SizedBox(width: 10),
                MaterialButton(
                  minWidth: 0,
                  height: 0,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.red[200],
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  color: Colors.white,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 12.0,
                  ),
                  onPressed: () {
                    setState(() {
                      minDate = minDate.subtract(new Duration(days: 50));
                      maxDate = maxDate.subtract(new Duration(days: 50));
                    });
                  },
                ),
                // SizedBox(width: 100,),
                Expanded(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text('Prednisolone'))),
                ),
                Visibility(
                  visible: false,
                  child: Container(
                    height: 40,
                    width: 230,
                    child: CustomScrollView(slivers: <Widget>[
                      SliverList(
                          delegate:
                              SliverChildListDelegate(medicationList.length > 0
                                  ? medicationList.map((item) {
                                      print(item.medicineName);
                                      if (item.medicineName != '' &&
                                          item.medicineName != null) {
                                        return Center(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: item.fromDate != null
                                                    ? Text(item.medicineName +
                                                        " " +
                                                        '(from ' +
                                                        item.fromDate
                                                            .split(" ")[0] +
                                                        ')')
                                                    : Text(item.medicineName +
                                                        " " +
                                                        '(from )')));
                                      } else {
                                        return SizedBox(
                                          height: 0,
                                        );
                                      }
                                    }).toList()
                                  : []))
                    ]),
                  ),
                ),
                MaterialButton(
                  minWidth: 0,
                  height: 0,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.red[200],
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  color: Colors.white,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12.0,
                  ),
                  onPressed: () {
                    if (isChanged) {
                      setState(() {
                        minDate = minDate.add(new Duration(days: 50));
                        maxDate = maxDate.add(new Duration(days: 50));
                      });
                    }
                  },
                ),
                SizedBox(width: 10),
              ]),
              SizedBox(height: 10),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      width: 350,
                      child: patientDataList == null
                          ? null
                          : SfCartesianChart(
                              zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true, zoomMode: ZoomMode.x),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                canShowMarker: true,
                                header: '',
                              ),
                              legend: Legend(
                                position: LegendPosition.bottom,
                              ),
                              primaryXAxis: DateTimeAxis(
                                  name: 'xAxis',
                                  //   opposedPosition: true,
                                  rangePadding: ChartRangePadding.additional,
                                  intervalType: DateTimeIntervalType.days,
                                  interval: 10,
                                  minimum: DateTime(
                                      minDate.year, minDate.month, minDate.day),
                                  maximum: DateTime(maxDate.year, maxDate.month,
                                      maxDate.day)),
                              primaryYAxis: NumericAxis(
                                  //  majorGridLines:
                                  //       MajorGridLines(color: Colors.transparent),
                                  //  rangePadding: ChartRangePadding.additional,
                                  minimum: 0,
                                  // maximum: 30,
                                  interval: 5,
                                  title: AxisTitle(
                                      text: AppLocalizations.of(context).dsage,
                                      alignment: ChartAlignment.center)),
                              axes: <ChartAxis>[
                                  //  dateTimeAxisOpposed,
                                  NumericAxis(
                                    // rangePadding: ChartRangePadding.auto,
                                    title: AxisTitle(
                                        text: AppLocalizations.of(context).urineProtein,
                                        alignment: ChartAlignment.center),
                                    opposedPosition: true,
                                    name: 'yAxis',
                                    minimum: 0,
                                    maximum: 4,
                                    interval: 1,
                                  ),
                                ],
                              series: <CartesianSeries>[
                                  // Initialize line series
                                  LineSeries<MedicineDosage, DateTime>(
                                      color: Colors.greenAccent,
                                      dataSource: newMedicineDosageData,
                                      enableTooltip: true,
                                      xValueMapper: (MedicineDosage data, _) =>
                                          data.date,
                                      yValueMapper: (MedicineDosage data, _) =>
                                          data.dosage,
                                      markerSettings:
                                          MarkerSettings(isVisible: true),
                                      pointColorMapper:
                                          (MedicineDosage data, _) =>
                                              data.color,
                                      animationDuration: 100,
                                      dataLabelSettings: DataLabelSettings(
                                          //isVisible: true,
                                          // labelPosition: LabelPosition.outside,
                                          labelIntersectAction:
                                              LabelIntersectAction.none)),
                                  LineSeries<UrineProtineData, DateTime>(
                                    color: Color(0xffe2e856e),
                                    dataSource: newUrineProtineData,
                                    enableTooltip: true,
                                    xAxisName: 'xAxis',
                                    yAxisName: 'yAxis',
                                    xValueMapper: (UrineProtineData data, _) =>
                                        data.date,
                                    yValueMapper: (UrineProtineData data, _) =>
                                        data.urineProtein,
                                    pointColorMapper:
                                        (UrineProtineData data, _) =>
                                            data.color,
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
                                  ),
                                ]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(0.0),
                  //   child: Icon(Icons.multiline_chart, color: Colors.red),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.multiline_chart, color: Colors.greenAccent),
                  ),
                  Text(AppLocalizations.of(context).dsage),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.multiline_chart, color: Color(0xffe2e856e)),
                  ),
                  Text(AppLocalizations.of(context).urineProtein),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.grey),
              ),
              Container(
                  child: SizedBox(
                height: 200,
                width: 200,
                child: doctorsDataList == null
                    ? Center(child: CircularProgressIndicator())
                    : SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
                        legend: Legend(
                          position: LegendPosition.bottom,
                        ),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          canShowMarker: true,
                          header: '',
                        ),
                        primaryXAxis: DateTimeAxis(
                            title: AxisTitle(text: AppLocalizations.of(context).date),
                            // dateFormat: DateFormat.MMMd(),
                            intervalType: DateTimeIntervalType.days,
                            interval: 10,
                            minimum: DateTime(
                                minDate.year, minDate.month, minDate.day),
                            maximum: DateTime(
                                maxDate.year, maxDate.month, maxDate.day)),
                        primaryYAxis: NumericAxis(
                            //rangePadding: ChartRangePadding.normal,
                            interval: 25,
                            maximum: 200,
                            title: AxisTitle(
                              text: AppLocalizations.of(context).diastolic,
                            )),
                        axes: <ChartAxis>[
                            // DateTimeAxis(
                            //   name: 'xAxis',
                            //   opposedPosition: true,
                            //   intervalType: DateTimeIntervalType.days,
                            //   interval:1,
                            //   minimum: DateTime(minDate.year,minDate.month,minDate.day),
                            //   maximum: DateTime(maxDate.year,maxDate.month,maxDate.day)
                            //   // dateFormat: DateFormat.MMMd(),
                            // ),
                            NumericAxis(
                                name: 'yAxis',
                                maximum: 200,
                                interval: 25,
                                opposedPosition: true,
                                title: AxisTitle(text: AppLocalizations.of(context).systolic))
                          ],
                        series: <CartesianSeries>[
                            LineSeries<DiastolicBp, DateTime>(
                              color: Colors.lightBlue[200],
                              dataSource: newDiastolicBPData,
                              xValueMapper: (DiastolicBp data, _) => data.date,
                              pointColorMapper: (DiastolicBp data, _) =>
                                  data.color,
                              yValueMapper: (DiastolicBp data, _) =>
                                  data.diastolic,
                              markerSettings: MarkerSettings(isVisible: true),
                            ),
                            LineSeries<SystolicBP, DateTime>(
                                // opacity:1,
                                color: Colors.blue,
                                dataSource: newSystolicBPData,
                                xValueMapper: (SystolicBP data, _) => data.date,
                                yValueMapper: (SystolicBP data, _) =>
                                    data.systolic,
                                xAxisName: 'xAxis',
                                yAxisName: 'yAxis',
                                lineColor: Colors.blue,
                                markerSettings: MarkerSettings(isVisible: true),
                                pointColorMapper: (SystolicBP data, _) =>
                                    data.color,
                                animationDuration: 100,
                                dataLabelSettings: DataLabelSettings(
                                    //isVisible: true,
                                    opacity: 0.5,
                                    // labelPosition: LabelPosition.outside,
                                    labelIntersectAction:
                                        LabelIntersectAction.none)),
                          ]),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.multiline_chart, color: Colors.blue),
                  ),
                  Text(AppLocalizations.of(context).systolic),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.multiline_chart,
                        color: Colors.lightBlue[200]),
                  ),
                  Text(AppLocalizations.of(context).diastolic),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.grey),
              ),
              Container(
                  child: SizedBox(
                height: 200,
                width: 200,
                child: (doctorsDataList == null)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
                        legend: Legend(position: LegendPosition.bottom),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          canShowMarker: true,
                          header: '',
                        ),
                        primaryXAxis: DateTimeAxis(
                            title: AxisTitle(text: AppLocalizations.of(context).date),
                            intervalType: DateTimeIntervalType.days,
                            interval: 10,
                            minimum: DateTime(
                                minDate.year, minDate.month, minDate.day),
                            maximum: DateTime(
                                maxDate.year, maxDate.month, maxDate.day)),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: AppLocalizations.of(context).height+' (cm)'),
                            minimum: 0,
                            //  maximum: 250,
                            interval: 50),
                        axes: <ChartAxis>[
                            // DateTimeAxis(
                            //     name: 'xAxis',
                            //     opposedPosition: true,
                            //     intervalType: DateTimeIntervalType.days,
                            //     interval: 1,
                            //     minimum: DateTime(minDate.year,
                            //         minDate.month, minDate.day),
                            //     maximum: DateTime(maxDate.year,
                            //         maxDate.month, maxDate.day)),
                            NumericAxis(
                                name: 'yAxis',
                                interval: 30,
                                minimum: 0,
                                //   maximum: 150,
                                opposedPosition: true,
                                title: AxisTitle(text: AppLocalizations.of(context).weight+' (kg)'))
                          ],
                        series: <CartesianSeries>[
                            LineSeries<Height, DateTime>(
                              color: Colors.purple,
                              opacity: 1.0,
                              dataSource: newHeightData,
                              xValueMapper: (Height data, _) => data.date,
                              pointColorMapper: (Height data, _) => data.color,
                              yValueMapper: (Height data, _) => data.height,
                              markerSettings: MarkerSettings(isVisible: true),
                            ),
                            LineSeries<Weight, DateTime>(
                                color: Colors.purpleAccent[100],
                                dataSource: newWeightData,
                                xAxisName: 'xAxis',
                                yAxisName: 'yAxis',
                                xValueMapper: (Weight data, _) => data.date,
                                yValueMapper: (Weight data, _) => data.weight,
                                pointColorMapper: (Weight data, _) =>
                                    data.color,
                                markerSettings: MarkerSettings(isVisible: true),
                                animationDuration: 100,
                                dataLabelSettings: DataLabelSettings(
                                    opacity: 0.5,
                                    labelIntersectAction:
                                        LabelIntersectAction.none)),
                          ]),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.multiline_chart, color: Colors.purple),
                  ),
                  Text(AppLocalizations.of(context).height),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.multiline_chart,
                        color: Colors.purpleAccent[100]),
                  ),
                  Text(AppLocalizations.of(context).weight),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: SizedBox(
                    height: 200,
                    width: 100,
                    child: (doctorsDataList == null)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SfCartesianChart(
                            zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true, zoomMode: ZoomMode.x),
                            legend: Legend(
                              position: LegendPosition.bottom,
                            ),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              canShowMarker: true,
                              header: '',
                            ),
                            primaryXAxis: DateTimeAxis(
                                title: AxisTitle(text: AppLocalizations.of(context).date),
                                intervalType: DateTimeIntervalType.days,
                                interval: 10,
                                minimum: DateTime(
                                    minDate.year, minDate.month, minDate.day),
                                maximum: DateTime(
                                    maxDate.year, maxDate.month, maxDate.day)),
                            primaryYAxis: NumericAxis(
                                title: AxisTitle(
                              text: AppLocalizations.of(context).bmi,
                            )),
                            axes: <ChartAxis>[
                                NumericAxis(
                                  opposedPosition: true,
                                  name: 'yAxis',
                                ),
                                // DateTimeAxis(
                                //   name: 'xAxis',
                                //   opposedPosition: true,
                                // ),
                              ],
                            series: <CartesianSeries>[
                                LineSeries<Bmi, DateTime>(
                                    color: Colors.grey,
                                    opacity: 1.0,
                                    dataSource: newBmi,
                                    xValueMapper: (Bmi data, _) => data.date,
                                    yValueMapper: (Bmi data, _) => data.bmi,
                                    pointColorMapper: (Bmi data, _) =>
                                        data.color,
                                    markerSettings:
                                        MarkerSettings(isVisible: true)),
                                LineSeries<Bmi, DateTime>(
                                    color: Colors.grey,
                                    opacity: 1.0,
                                    dataSource: newBmi,
                                    xValueMapper: (Bmi data, _) => data.date,
                                    yValueMapper: (Bmi data, _) => data.bmi,
                                    pointColorMapper: (Bmi data, _) =>
                                        data.color,
                                    markerSettings:
                                        MarkerSettings(isVisible: true)),
                              ])),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.multiline_chart, color: Colors.grey),
                  ),
                  Text(AppLocalizations.of(context).bmi),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              // SizedBox(
              //   height: 10,
              // ),
              // new Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: OutlineButton(
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(30)),
              //           color: Colors.white,
              //           child: const Text(
              //             'Add Data',
              //             style: TextStyle(
              //               fontSize: 15,
              //               color: Colors.black,
              //             ),
              //           ),
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => AddDoctor(
              //                         currentPatient: patient,
              //                       )),
              //             );
              //           },
              //           borderSide: BorderSide(
              //             color: Colors.red[200],
              //           )),
              //     ),
              //     OutlineButton(
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(30)),
              //         color: Colors.white,
              //         child: const Text(
              //           'Medicine',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.black,
              //           ),
              //         ),
              //         onPressed: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => MedicationPage(
              //                     currentPatient: patient,
              //                   )));
              //         },
              //         borderSide: BorderSide(
              //           color: Colors.red[200],
              //         )),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: OutlineButton(
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(30)),
              //         color: Colors.white,
              //         child: const Text(
              //           'Notify',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.black,
              //           ),
              //         ),
              //         onPressed: () {
              //           _showDialog("Send", context);
              //         },
              //         borderSide: BorderSide(
              //           color: Colors.red[200],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  SizedBox(width: 5),
                  Container(
                    width: 110,
                    child: OutlinedButton(
                        child: Text(AppLocalizations.of(context).downloadAll,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        onPressed: () {
                          checkStoragePermission(patientHistoryData);
                        },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],)
                    ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 110,
                    child: OutlinedButton(
                        child: Text(AppLocalizations.of(context).lastSixMonths,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        onPressed: () {
                          patientHistoryThreeOrSixMonths(username,"last_6_months").then((responseHistoryData) {
                                if (responseHistoryData != null && responseHistoryData.length > 0) {
                                  List<PatientHistory> historyData = responseHistoryData;
                                  checkStoragePermission(historyData);
                                }
                          });
                        },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],)
                    ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 110,
                    child: OutlinedButton(
                        child: Text(AppLocalizations.of(context).lastThreeMonths,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        onPressed: () {
                          patientHistoryThreeOrSixMonths(username,"last_3_months").then((responseHistoryData) {
                            if (responseHistoryData != null && responseHistoryData.length > 0) {
                              List<PatientHistory> historyData = responseHistoryData;
                              checkStoragePermission(historyData);
                            }
                          });
                        },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],)
                    ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context).patientsHistory),
              ),
            ])),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                return ListTile(
                    title: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (patientHistoryData.length - i).toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      (patientHistoryData[i].date)
                                              .toLocal()
                                              .day
                                              .toString() +
                                          dateMap[patientHistoryData[i]
                                              .date
                                              .toLocal()
                                              .day],
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.blue),
                                    ),
                                    Text(
                                        DateFormat('yMMM').add_jm().format(
                                            patientHistoryData[i]
                                                .date
                                                .toLocal()),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.blue)),
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (patientHistoryData[i].urineProtein != null)
                                  Text(
                                      AppLocalizations.of(context).urineProtein+": " +
                                          patientHistoryData[i]
                                              .urineProtein
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getUrineMeasurementColor(
                                            patientHistoryData[i]
                                                .urineProtein) /*patientHistoryData[i]
                                                      .urineProteinStatus ==
                                                  2
                                              ? Colors.red
                                              : Colors.black*/
                                        ,
                                      )),
                                if (patientHistoryData[i].medicineDosage != null)
                                  Text(
                                      AppLocalizations.of(context).medicineDosage+": " +
                                          patientHistoryData[i]
                                              .medicineDosage
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black)),
                                if (patientHistoryData[i].systolicBP != null)
                                  Text(
                                    AppLocalizations.of(context).systolic+": " +
                                        patientHistoryData[i]
                                            .systolicBP
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      //color: Color(int.parse(patientHistoryData[i].systolicBPGraphColor))
                                      color: patientHistoryData[i]
                                                  .systolicBPStatus ==
                                              2
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                if (patientHistoryData[i].diastolicBP != null)
                                  Text(
                                      AppLocalizations.of(context).diastolic+": " +
                                          patientHistoryData[i]
                                              .diastolicBP
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        //color: Color(int.parse(patientHistoryData[i].diastolicBPGraphColor))
                                        color: patientHistoryData[i]
                                                    .diastolicBPStatus ==
                                                2
                                            ? Colors.red
                                            : Colors.black,
                                      )),
                                //Text("Urine: "+doctorsDataList[i].diastolicBP.toString(), style: TextStyle(fontSize: 15)),
                                if (patientHistoryData[i].bodyWeight != null)
                                  Text(
                                      AppLocalizations.of(context).weight+": " +
                                          patientHistoryData[i]
                                              .bodyWeight
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        //color: Color(int.parse(patientHistoryData[i].weightGraphColor))
                                        color: patientHistoryData[i]
                                                    .bodyWeightStatus ==
                                                2
                                            ? Colors.red
                                            : Colors.black,
                                      )),
                                if (patientHistoryData[i].bodyHeight != null)
                                  Text(
                                      AppLocalizations.of(context).height+": " +
                                          patientHistoryData[i]
                                              .bodyHeight
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        //color: Color(int.parse(patientHistoryData[i].heightGraphColor))
                                        color: patientHistoryData[i]
                                                    .bodyHeightStatus ==
                                                2
                                            ? Colors.red
                                            : Colors.black,
                                      )),
                                if (patientHistoryData[i].bmi != null)
                                  Text(
                                      AppLocalizations.of(context).bmi+": " +
                                          patientHistoryData[i]
                                              .bmi
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 12,
                                        //color: Color(int.parse(patientHistoryData[i].bmiGraphColor))
                                        color:
                                            patientHistoryData[i].bmiStatus == 2
                                                ? Colors.red
                                                : Colors.black,
                                      )),
                                if (patientHistoryData[i].category != null)
                                  patientHistoryData[i].category.toString() !=
                                          ""
                                      ? Text(
                                      AppLocalizations.of(context).category+": " +
                                              patientHistoryData[i]
                                                  .category
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .black /*patientHistoryData[i]
                                                      .urineProteinStatus ==
                                                  2
                                              ? Colors.red
                                              : Colors.black*/
                                            ,
                                          ))
                                      : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _showDeleteDialog(
                                    patientHistoryData[i].patientId,
                                    patientHistoryData[i].date,
                                    context,
                                    i);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Image.asset('images/dustbin.png',
                                      width: 20.0, height: 20.0),
                                  GestureDetector(
                                    onTap: () {},
                                    child: new Image.asset(
                                        patientHistoryData[i].urineProtein == 3 ||
                                            patientHistoryData[i].urineProtein == 4 ||
                                            patientHistoryData[i].systolicBPStatus == 2 ||
                                            patientHistoryData[i].diastolicBPStatus == 2 ||
                                            patientHistoryData[i].bodyWeightStatus == 2 ||
                                            patientHistoryData[i].bodyHeightStatus == 2 ||
                                            patientHistoryData[i].bmiStatus == 2
                                            ? 'images/fire.png'
                                            : 'images/history_kidney.png',

                                        /* (patientHistoryData != null) &&
                                                  patientHistoryData[i]
                                                          .patientDataFireStatus ==
                                                      2|| patientHistoryData[i]
                                                          .doctorDataFireStatus ==
                                                      2
                                              ? 'images/fire.png'
                                              : 'images/history_kidney.png',*/
                                        width: 50.0,
                                        height: 50.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                    if (patientHistoryData[i].comments != '')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                                AppLocalizations.of(context).extraComments+": " +
                                    patientHistoryData[i].comments.toString(),
                                style: TextStyle(fontSize: 15)),
                          )
                        ],
                      ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ));
              },
                  childCount: (patientHistoryData != null)
                      ? patientHistoryData.length
                      : 0

                  //doctorsDataList?.length??0
                  ),
            ),
          ]))
        ]));
  }

  checkStoragePermission(List<PatientHistory> patientHistoryData) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      List<List<dynamic>> rows = List<List<dynamic>>();

      List<dynamic> row = List();
      row.add(AppLocalizations.of(context).date);
      row.add(AppLocalizations.of(context).urineProtein);
      row.add(AppLocalizations.of(context).medicineDosage);
      row.add(AppLocalizations.of(context).systolic);
      row.add(AppLocalizations.of(context).diastolic);
      row.add(AppLocalizations.of(context).weight);
      row.add(AppLocalizations.of(context).height);
      row.add(AppLocalizations.of(context).bmi);
      row.add(AppLocalizations.of(context).category);
      row.add("Extra Comment");
      rows.add(row);

      for (int i = 0; i < patientHistoryData.length; i++) {
        List<dynamic> row = List();
        row.add((patientHistoryData[i].date).toLocal().day.toString() +
            dateMap[patientHistoryData[i].date.toLocal().day] +
            " " +
            DateFormat('yMMM')
                .add_jm()
                .format(patientHistoryData[i].date.toLocal()));
        row.add(patientHistoryData[i].urineProtein != null
            ? patientHistoryData[i].urineProtein.toString()
            : "");
        row.add(patientHistoryData[i].medicineDosage != null
            ? patientHistoryData[i].medicineDosage.toString()
            : "");
        row.add(patientHistoryData[i].systolicBP != null
            ? patientHistoryData[i].systolicBP.toString()
            : "");
        row.add(patientHistoryData[i].diastolicBP != null
            ? patientHistoryData[i].diastolicBP.toString()
            : "");
        row.add(patientHistoryData[i].bodyWeight != null
            ? patientHistoryData[i].bodyWeight.toString()
            : "");
        row.add(patientHistoryData[i].bodyHeight != null
            ? patientHistoryData[i].bodyHeight.toString()
            : "");
        row.add(patientHistoryData[i].bmi.toString());
        row.add(patientHistoryData[i].category != null
            ? patientHistoryData[i].category.toString()
            : "");
        row.add(patientHistoryData[i].comments != null
            ? patientHistoryData[i].comments.toString()
            : "");
        rows.add(row);
      }

      String csvData = ListToCsvConverter().convert(rows);
      final String directory =
          (await DownloadsPathProvider.downloadsDirectory).path;
      final path = directory +
          "/" +
          username.toString() +
          "_" +
          DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now()) +
          ".csv";
      print(path);
      final File file = File(path);
      await file.writeAsString(csvData);
      showToast(AppLocalizations.of(context).patientHistoryDownloadSuccessfully);
    } else if (status.isRestricted) {
      Permission.storage.request();
      showToast(AppLocalizations.of(context).pleaseGiveTheStoragePermissionFromSetting);
    } else {
      showToast(AppLocalizations.of(context).pleaseGiveTheStoragePermissionFromSetting);
    }
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);

    /*Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );*/
  }

  void _showDialog(message, context) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextField(
                  cursorColor: Colors.red,
                  onChanged: (String value) {
                    setState(() {
                      notify.notification = value;
                    });
                  },
                  decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[200])),
                      hintText: AppLocalizations.of(context).sendSomeAdviceToPatient),
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 30.0),
              Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40),
                  child: OutlinedButton(
                    onPressed: () {
                      notifyPatient(setState);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          !loading
                              ? Text(AppLocalizations.of(context).send,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator())),
                        ]),
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.red[200],)
                      ),
                  ))
            ]));
          });
        });
  }

  void _showDeleteDialog(patientId, date, context, index) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              //backgroundColor: Colors.grey,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.warning),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context).deleteEntry),
                  ),
                ],
              ),
              content: new Text(AppLocalizations.of(context).areYouSureYouWantToDeleteThisEntryQ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(AppLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                    child: new Text(AppLocalizations.of(context).ok),
                    onPressed: () async {
                      Navigator.pop(context);
                      await deletePatientHistory(patientId, date);
                      if (this.mounted)
                        setState(() {
                          getDetails();
                          // patientHistoryData.removeAt(index);
                          //doctorsDataList.removeWhere((i)=>i.;
                          //  Navigator.pop(context);
                          //  Navigator.of(context).pushReplacement();
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     '/patient', (Route<dynamic> route) => false);
                        });
                    })
              ]);
        });
  }

// void _showDialog(message, context) {
//   // flutter defined function
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//             //backgroundColor: Colors.grey,
//             title: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Icon(Icons.warning),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text("Delete entry"),
//                 ),
//               ],
//             ),
//             content: new Text(
//               "Are you sure you want to delete this entry?",
//             ),
//             actions: <Widget>[
//               new FlatButton(
//                 child: new Text("CANCEL"),
//                 onPressed: () {},
//               ),
//               new FlatButton(child: new Text("OK"), onPressed: () {})
//             ]);
//       });
// }
}

class UrineProtineData {
  final DateTime date;
  final int urineProtein;
  final Color color;

  UrineProtineData(this.date, this.urineProtein, this.color);
}

class MedicineDosage {
  final DateTime date;
  final double dosage;
  final Color color;

  MedicineDosage(this.date, this.dosage, this.color);
}

class SystolicBP {
  final DateTime date;
  final int systolic;
  final Color color;

  SystolicBP(this.date, this.systolic, this.color);
}

class DiastolicBp {
  final DateTime date;
  final int diastolic;
  final Color color;

  DiastolicBp(this.date, this.diastolic, this.color);
}

class Height {
  final DateTime date;
  final double height;
  final Color color;

  Height(this.date, this.height, this.color);
}

class Weight {
  final DateTime date;
  final double weight;
  final Color color;

  Weight(this.date, this.weight, this.color);
}

class Bmi {
  final DateTime date;
  final double bmi;
  final Color color;

  Bmi(this.date, this.bmi, this.color);
}
