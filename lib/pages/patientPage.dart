import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utsarjan/charts/charts.dart';
import 'package:utsarjan/model/doctorDataModel.dart';
import 'package:utsarjan/model/doctorModel.dart';
import 'package:utsarjan/model/loginModel.dart';
import 'package:utsarjan/model/medicationModel.dart';
import 'package:utsarjan/model/patientDataModel.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/model/updateDoctorModel.dart';
import 'package:utsarjan/pages/aboutNephrosis.dart';
import 'package:utsarjan/model/patientHistoryDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/pages/medicationgetPage.dart';
import 'package:utsarjan/pages/notificationsPage.dart';
import 'package:utsarjan/pages/testsPage.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:utsarjan/services/loginServices.dart';
import 'package:utsarjan/services/medicineServices.dart';
import 'package:utsarjan/services/patientSevices.dart';
import 'addPatient.dart';
import 'package:age/age.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

//import 'package:bezier_chart/bezier_chart.dart';
//import 'package:intl/intl.dart' as intl;
//import 'bezier_chart_config.dart';
// "expo-image-picker": "^6.0.0",
class PatientPage extends StatefulWidget {
  final Patient currentPatient;
  PatientPage({this.currentPatient});
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  List<PatientHistory> dummyHistoryDataList = [
    PatientHistory(
      systolicBP: 120,
      diastolicBP: 70,
      urineProtein: 3,
      bodyHeight: 52,
      bodyWeight: 3.4,
      medicineDosage: 30,
      date: DateTime.parse('2020-01-10 10:29:04Z'),
      day: '2020-01-10',
      comments: "Dizziness,headache",
    ),
  ];
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
    31: "th",
    32: "st"
  };

  Patient currentPatient;
  bool isDummy = false;
  DateTime currentDate = DateTime.now();

  List<PatientData> patientDataList;
  List<PatientHistory> patientHistoryData;
  List<DoctorData> doctorsDataList;
  List<MedicineData> medicationList=[];

  DoctorData doctorData;
  Doctor doctor;
  String mobile;
  String username;
  Patient patient;
  DateTime dob;
  // int monthsOnSet = 0;
  //int month = 0;
  // int year;
  //var date1 = DateTime.now();
  SharedPreferences preferences;
  Doctor doctors;
  bool loaded = false;
  bool relapseData = false;
  UpdateDoctorData updateDoctorData = new UpdateDoctorData();

  double calculateBMIOfUser(double bodyHeight, double bodyWeight) {
    return bodyWeight / pow(bodyHeight, 2);
  }

  var minDate = DateTime.now().subtract(new Duration(days: 50));
  var maxDate = DateTime.now().add(new Duration(days: 10));
  var isChange =  DateTime.now().add(new Duration(days: 10));
  // var doctorsDatalist;
  // int month = 0;

  @override
  void initState() {
   // patientHistoryData = dummyHistoryDataList;
    currentPatient = widget.currentPatient;

    SharedPreferences.getInstance().then((instance) {
      if (this.mounted)
        setState(() {
          username = instance.getString('username');
          preferences = instance;
          patientDetails(username).then((patientDetail) {
            patientToJson(patientDetail);
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
                patient.currentCategory = patient.currentCategory != null
                    ? patient.currentCategory
                    : patient.previousCategory;
                patient.monthsOnSet =
                    '${(monthsOnSet.years)} yr, ${(monthsOnSet.months)} mo';
                patient.age = '${(age.years)} yr, ${(age.months)} mo';
              });
            if (instance.getString('name') == null)
              instance.setString('name', patient.name);
          });

          patientHistory(username).then((responseHistoryData) {
           // print("AA_S -- outside" + patientHistoryDataToJson(responseHistoryData));
            if (this.mounted)
              setState(() {
                if (responseHistoryData != null &&
                    responseHistoryData.length > 0) {
                //  print(patientHistoryDataToJson(responseHistoryData));
                  patientHistoryData =responseHistoryData;
                  print("AA_S -- " + patientHistoryDataToJson(patientHistoryData));
                }
              });
          });

          patientData(username).then((patientData) {
          //print("AA_S -- " + patientDataListToJson(patientData));
            if (this.mounted)
              setState(() {
                patientDataList = patientData;
                /*for(int i=0;i<patientDataList.length;i++){
                  if(patientDataList[i].medicineDosage == null){
                    print("AA_S -- Medicine Dosage : Empty " + patientDataList[i].date.toString());
                  }else{
                    print("AA_S -- Medicine Dosage : " + patientDataList[i].medicineDosage.toString() + " Date " +
                        patientDataList[i].date.toString());
                  }
                }*/
              });
          });

          getPatientDataByDoctor(username).then((patientDataByDoctor) {
            if (this.mounted)
              setState(() {
                //  print(patientDataByDoctor[0]);
                doctorsDataList = patientDataByDoctor;
              });
          });
        });
          getAllMedicines(username).then((medicineData) {
     // print(medicineListToJson(medicineData));
      setState(() {       
        if (medicineData != null) medicationList = medicineData;
      });     
    });
    });
    super.initState();
  }
void updateMedicine(){
     getAllMedicines(username).then((medicineData) {
     // print(medicineListToJson(medicineData));
      setState(() {       
        if (medicineData != null) medicationList = medicineData;
      }); 
      });
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   bool isChanged= DateFormat('yyyy-mm-dd').format(maxDate)==DateFormat('yyyy-mm-dd').format(DateTime.now().add(new Duration(days: 10)))?false:true;
    //   var minValue =  patientDataList != null? DateTime(minDate.year,minDate.month,minDate.day):null;
    //  var maxValue = patientDataList != null ? DateTime(maxDate.year,maxDate.month,maxDate.day):null;
    int patientDataLength =
        (patientDataList != null) ? patientDataList.length : 0;

    List<UrineProteinData> newUrineProteinData = [];

    if (patientDataLength > 0) {
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

        newUrineProteinData.add(UrineProteinData(
            DateTime.parse(patientDataList[i].day),
            patientDataList[i].urineProtein,
            color));
      }
    } else {
      // newUrineProteinData.add(UrineProteinData(
      //     minDate.subtract(new Duration(days: 1)), 0, Color(0xffe2e856e)));
      // newUrineProteinData.add(UrineProteinData(minDate, 1, Color(0xffe2e856e)));
      // //  newUrineProteinData.add(UrineProteinData(minDate.add(new Duration(days: 1)), 2, Color(0xffe2e856e)));
      // newUrineProteinData.add(
      //     UrineProteinData(minDate.add(new Duration(days: 1)), 3, Colors.red));
      // newUrineProteinData.add(
      //     UrineProteinData(minDate.add(new Duration(days: 2)), 3, Colors.red));
      // newUrineProteinData.add(
      //     UrineProteinData(minDate.add(new Duration(days: 3)), 3, Colors.red));
      // newUrineProteinData.add(UrineProteinData(
      //     minDate.add(new Duration(days: 4)), 0, Color(0xffe2e856e)));

      // newUrineProteinData.add(UrineProteinData(DateTime(5), 0, Color(0xffe2e856e)));
      // newUrineProteinData.add(UrineProteinData(DateTime(7), 1, Color(0xffe2e856e)));
      // newUrineProteinData.add(UrineProteinData(DateTime(9), 2, Color(0xffe2e856e)));
      // newUrineProteinData.add(UrineProteinData(DateTime(10), 3, Colors.red));
      // newUrineProteinData.add(UrineProteinData(DateTime(15), 3, Colors.red));
      // newUrineProteinData.add(UrineProteinData(DateTime(20), 3, Colors.red));
      // newUrineProteinData.add(UrineProteinData(DateTime(25), 0, Color(0xffe2e856e)));
    }

   Color _getUrineMeasurementColor(urineProtein){
     Color color;
     if (urineProtein == 3 || urineProtein == 4) {
       color = Colors.red;
     }else{
       color = Colors.black;
     }
     return color;
   }

    List<MedicineDosage> newMedicineDosageData = [];
    if (patientDataLength > 0)
      for (int i = 0; i < patientDataLength; i++) {
        // DateTime day = patientDataList[i].day;
       //if( patientDataList[i].medicineDosage!=0) {
         print("Dosage -- " + patientDataList[i].medicineDosage.toString());
         newMedicineDosageData.add(MedicineDosage(
            DateTime.parse(patientDataList[i].day),
            patientDataList[i].medicineDosage,
            Colors.greenAccent));
       //}
      }
    else {
      // newMedicineDosageData.add(MedicineDosage(
      //     minDate.subtract(new Duration(days: 1)), 10, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(
      //     minDate.add(new Duration(days: 3)), 20, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(test
      //     minDate.add(new Duration(days: 4)), 30, Colors.greenAccent));

      // newMedicineDosageData.add(MedicineDosage(minDate.add(new Duration(days: 3)), 20, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(minDate.add(new Duration(days: 4)), 30, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(minDate.add(new Duration(days: 5)), 10, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(DateTime(5), 10, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(DateTime(20), 20, Colors.greenAccent));
      // newMedicineDosageData.add(MedicineDosage(DateTime(25), 30, Colors.greenAccent));
    }

    List<DiastolicBp> newDiastolicBPData = [];
    int doctorDataLength =
        (doctorsDataList != null) ? doctorsDataList.length : 0;
    if (doctorDataLength > 0 && patientDataLength > 0)
      for (int i = 0; i < doctorDataLength; i++) {
        Color color;     
       if(doctorsDataList[i].diastolicBP !=null){ 
         color = Color(int.parse(doctorsDataList[i].diastolicBPGraphColor));
         newDiastolicBPData.add(DiastolicBp(
            DateTime.parse(doctorsDataList[i].day),
            doctorsDataList[i].diastolicBP,
            color));}
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
       if(doctorsDataList[i].systolicBP!=null){ 
          color = Color(int.parse(doctorsDataList[i].systolicBPGraphColor));
          newSystolicBPData.add(SystolicBP(DateTime.parse(doctorsDataList[i].day),
            doctorsDataList[i].systolicBP, color));}
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
       
        if(doctorsDataList[i].bodyHeight!=null){
           Color color = Color(int.parse(doctorsDataList[i].heightGraphColor));
          newHeightData.add(Height(DateTime.parse(doctorsDataList[i].day),
            doctorsDataList[i].bodyHeight, color));}
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
        
        if(doctorsDataList[i].bodyWeight!=null){
          Color color = Color(int.parse(doctorsDataList[i].weightGraphColor));
          newWeightData.add(Weight(DateTime.parse(doctorsDataList[i].day),
            doctorsDataList[i].bodyWeight, color));}
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
         if(doctorsDataList[i].bmi!=null){
               Color color = Color(int.parse(doctorsDataList[i].bmiGraphColor));
           newBmi.add(Bmi(DateTime.parse(doctorsDataList[i].day),
            doctorsDataList[i].bmi, color));};
      }
    else {
      // newBmi.add(
      //     Bmi(minDate.subtract(new Duration(days: 1)), 11.1, Colors.yellow));
      // newBmi.add(Bmi(minDate, 12.2, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 1)), 13.3, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 2)), 14.6, Colors.grey));
      // newBmi.add(Bmi(minDate.add(new Duration(days: 3)), 16.1, Colors.red));
    }

    return new Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context).patient),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.red[200],
            actions: <Widget>[
              PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                       PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset('images/How_to_use_the_App.png',
                                width: 30.0, height: 35.0),
                            //Icon(Icons.picture_as_pdf),
                             Text("  "+AppLocalizations.of(context).howToUseApp),
                          ]),
                          onTap: () {
                            openBrowser("https://youtu.be/bbeOKPZyvxo");
                          },
                        )),
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset(
                              'images/notification.png',
                              width: 35.0,
                              height: 40.0,
                            ),
                            //Icon(Icons.notifications),
                            Text(" "+AppLocalizations.of(context).notifications),
                          ]),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationsPage(
                                          patientId: username,
                                          isFrom:AppLocalizations.of(context).notifications
                                        )));
                          },
                        )),
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset('images/map.png',
                                width: 35.0, height: 40.0),
                            //Icon(Icons.local_hospital),
                            Text(" "+AppLocalizations.of(context).nearbyHospitals),
                          ]),
                          onTap: () => launch(
                              // "https://www.google.com/maps/search/$transformedParameter")
                              "https://maps.google.com/"),
                          // onTap: () => launch("https://google.com/maps/search/nearbyhospitals"),
                        )),
                        // PopupMenuItem(
                        //     child: InkWell(
                        //   child: Row(children: <Widget>[
                        //     new Image.asset('images/Advice_Complaint.png',
                        //         width: 30.0, height: 35.0),
                        //     //Icon(Icons.picture_as_pdf),
                        //      Text("  Advice/Complaint"),
                        //   ]),
                        //   onTap: () {},
                        // )),
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(
                            children: <Widget>[
                              new Image.asset('images/arrows.png',
                                  width: 35.0, height: 40.0),
                              // Icon(Icons.person),
                              Text(" "+AppLocalizations.of(context).changeDoc),
                            ],
                          ),
                          onTap: () {
                            showDialog1("", context);
                          },
                        )),
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset('images/faq.png',
                                width: 35.0, height: 40.0),
                            //Icon(Icons.details),
                            Text(" "+ AppLocalizations.of(context).aboutTheDisease),
                          ]),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutNephrosis()));
                          },
                        )),
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset('images/logout.png',
                                width: 35.0, height: 40.0),

                            //Icon(Icons.exit_to_app),
                            Text(" "+ AppLocalizations.of(context).logout),
                          ]),
                          onTap: () {
                            Login login = new Login();
                            login.username = username;
                            logoutUser(login).then((login) {
                              if (login.status) {
                                SharedPreferences.getInstance().then((onValue) {
                                  onValue.clear();
                                  Navigator.of(context).pushNamedAndRemoveUntil( '/home', (Route<dynamic> route) => false);
                                });
                              }
                            });
                          },
                        )),
                      ])
            ]),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Card(
            elevation: 4,
            child: Container(
              child: Row(
                children: <Widget>[
                  new Image.asset('images/ptprofile.png',
                      width: 80.0, height: 80.0),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                     // flex: 1,
                      child: Padding(
                                padding: const EdgeInsets.all(5),                               
                      child:Table(           
                          children: [
                            TableRow(
                              children: [
                                Text(AppLocalizations.of(context).name+': '),
                                   Row(
                                  children: <Widget>[                           
                               Flexible(child:Text((patient != null && patient.name != null)
                                          ? patient.name
                                          : "",
                                    ),),
                            //          SizedBox(
                            //   width: 5,
                            // ),
                                    if (patient != null &&
                                        patient.status != null)
                                     Expanded(
                                        child:    
                                     new Image.asset(
                                            'images/correct.png',
                                            width: 17.0,
                                            height: 17.0),  )                                                                
                              ],
                            ),]),
                         
                            TableRow(
                              children: [
                                Text(AppLocalizations.of(context).category+': '),
                                Text((patient != null &&
                                        patient.currentCategory != null)
                                    ? patient.currentCategory
                                    : ''),
                              ],
                            ),
                            //  SizedBox(
                            //   height: 2,
                            // ),
                            TableRow(
                              children: [
                                Text(AppLocalizations.of(context).doctorName+': '),
                                Text((patient != null &&
                                        patient.doctorName != null)
                                    ? patient.doctorName
                                    : ""),
                              ],
                            ),
                            //  SizedBox(
                            //   height: 2,
                            // ),
                            TableRow(
                              children: [
                                Text(AppLocalizations.of(context).doctorMobile+': '),
                                Row(
                                  children: <Widget>[
                                    Text((patient != null &&
                                            patient.doctorMobile != null)
                                        ? patient.doctorMobile
                                        : ""/*"XXXXXXXXXX"*/),
                                   Expanded(
                                        child:InkWell(
                                        child: new Image.asset(
                                            'images/call.png',
                                            width: 17.0,
                                            height: 17.0),
                                        onTap: () => launch(
                                            "tel:${patient.doctorMobile}"),)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //  SizedBox(
                            //   height: 2,
                            // ),
                            TableRow(
                              children: [
                                Text(AppLocalizations.of(context).relapseYr+': '),
                                Text(
                                    (patient != null && patient.relapse != null)
                                        ? patient.relapse.toString()
                                        : ""),
                              ],
                            ),
                            //  SizedBox(
                            //   height: 2,
                            // ),
                            TableRow(
                              children: [
                                Text(
                                    AppLocalizations.of(context).ageAtOnset+': ',
                                ),
                                Text((patient != null &&
                                        patient.monthsOnSet != null)
                                    ? patient.monthsOnSet
                                    : "")
                              ],
                            ),
                            // SizedBox(
                            //   height: 2,
                            // ),
                            TableRow(children: [
                              Text(AppLocalizations.of(context).currentAge+': ', textAlign: TextAlign.start),
                              Row(
                                children: <Widget>[
                                Text(
                                      (patient != null && patient.age != null
                                          ? patient.age.toString()
                                          // "${patient.age.split('.')[0].toString()} yr, ${patient.age.split('.')[1].toString()} mo"

                                          // -${patient.dob}"
                                          : ""),
                                    ),
                                 
                                ],
                              ),
                            ])
                          ]))),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,            
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                              child: Text(
                                AppLocalizations.of(context).urineProtein,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPatient()),
                                );
                              },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red[200],)
                            ),
                          ),
                        ),
                        OutlinedButton(
                            child: Text(
                              AppLocalizations.of(context).medicines,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => MedicationPage(
                              //               currentPatient: patient,
                              //               updateMedicine: updateMedicine,
                              //             )));

                              // comment code

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Medicationget(
                                      patientId: username,
                                      isFrom:"Patient"
                                  )));

                              /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Medicationget(
                                        // currentPatient: patient,
                                        // updateMedicine: updateMedicine
                                        patientId: username,
                                      )));*/
                            },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.red[200],)
                          ),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                              child: Text(
                                AppLocalizations.of(context).reports,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestsPage(
                                               patientId: username,
                                        )));
                              },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red[200],)
                            ),),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            width: 10),
                              MaterialButton(
                              minWidth: 0,
                              height: 0,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide( color: Colors.red[200], ),
                                  borderRadius: BorderRadius.circular(50)),
                              color: Colors.white,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 12.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  minDate =
                                      minDate.subtract(new Duration(days: 50));
                                  maxDate =
                                      maxDate.subtract(new Duration(days: 50));
                                });
                              },
                           ),
                       //   SizedBox(width: 100,),
                        Expanded(
                          child: Center(
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text('Prednisolone'))),
                        ),
                          Visibility(
                            visible: false,
                            child: Container(
                              height:40,
                              width: 230,
                              child:  CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                medicationList.length>0?  medicationList.map((item){
                  print(medicineDataToJson(item));
                 if(item.medicineName!=''&&item.medicineName!=null){
                   return Center(child:Padding(
                     padding: EdgeInsets.only(bottom:5),
                     child:item.fromDate!=null?
                     Text(item.medicineName+" "+'(from '+item.fromDate.split(" ")[0]+')'):
                     Text(item.medicineName+" "+'(from )')
                     ));
                   }else{return SizedBox(height: 0,);}
                  }
                  ).toList():[]
                ))]),

                            ),
                          ),
                     MaterialButton(
                              minWidth: 0,
                              height: 0,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide( color: Colors.red[200], ),
                                  borderRadius: BorderRadius.circular(50)),
                            color: Colors.white,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 12.0,                             
                            ),
                            onPressed: () {
                             if(isChanged) {
                                setState(() {
                                minDate = minDate.add(new Duration(days: 50));
                                maxDate = maxDate.add(new Duration(days: 50));
                              });
                              }
                            },),
                        SizedBox(
                            width: 10),
                      ]),
                     SizedBox(
                      height: 10), 
                  // if (patientDataList?.isEmpty ?? true)
                  //   Center(
                  //     child: Text(
                  //       '* Dummy Data for educational purpose',
                  //       style: TextStyle(color: Colors.red),
                  //     ),
                  //   ),
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: (patientDataList == null)
                          ? Center(child: CircularProgressIndicator())
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
                                    maxDate.day)
                              ),
                              primaryYAxis: NumericAxis(
                                //  majorGridLines:
                                //       MajorGridLines(color: Colors.transparent),
                                //  rangePadding: ChartRangePadding.additional,
                                   minimum: 0,
                                  // maximum: 30,
                                  interval: 5,
                                  title: AxisTitle(
                                    text: AppLocalizations.of(context).dsage,
                                    alignment: ChartAlignment.center
                                  )),
                              axes: <ChartAxis>[
                                  //  dateTimeAxisOpposed,
                                  NumericAxis(
                                   // rangePadding: ChartRangePadding.auto,
                                    title: AxisTitle(text: AppLocalizations.of(context).urineProtein, alignment: ChartAlignment.center),
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
                                        (MedicineDosage data, _) => data.color,
                                    animationDuration: 100,
                                      dataLabelSettings: DataLabelSettings(
                                          //isVisible: true,
                                          // labelPosition: LabelPosition.outside,
                                          labelIntersectAction:
                                              LabelIntersectAction.none)
                                  ),
                                  LineSeries<UrineProteinData, DateTime>(
                                    color: Color(0xffe2e856e),
                                    dataSource: newUrineProteinData,
                                    enableTooltip: true,
                                    xAxisName: 'xAxis',
                                    yAxisName: 'yAxis',
                                    xValueMapper: (UrineProteinData data, _) =>
                                        data.date,
                                    yValueMapper: (UrineProteinData data, _) =>
                                        data.urineProtein,
                                    pointColorMapper:
                                        (UrineProteinData data, _) =>
                                            data.color,
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
                                  ),
                                ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.multiline_chart,
                            color: Colors.greenAccent),
                      ),
                      Text(AppLocalizations.of(context).dsage),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.multiline_chart,
                            color: Color(0xffe2e856e)),
                      ),
                      Text(AppLocalizations.of(context).urineProtein),
                      // Text("Dosage"),
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
                            zoomPanBehavior:
                                ZoomPanBehavior(enablePinching: true),
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
                                  xValueMapper: (DiastolicBp data, _) =>
                                      data.date,
                                  pointColorMapper: (DiastolicBp data, _) =>
                                      data.color,
                                  yValueMapper: (DiastolicBp data, _) =>
                                      data.diastolic,
                                  markerSettings:
                                      MarkerSettings(isVisible: true),
                                ),
                                LineSeries<SystolicBP, DateTime>(
                                    // opacity:1,
                                    color: Colors.blue,
                                    dataSource: newSystolicBPData,
                                    xValueMapper: (SystolicBP data, _) =>
                                        data.date,
                                    yValueMapper: (SystolicBP data, _) =>
                                        data.systolic,
                                    xAxisName: 'xAxis',
                                    yAxisName: 'yAxis',
                                    lineColor: Colors.blue,
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
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
                            zoomPanBehavior:
                                ZoomPanBehavior(enablePinching: true),
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
                                  pointColorMapper: (Height data, _) =>
                                      data.color,
                                  yValueMapper: (Height data, _) => data.height,
                                  markerSettings:
                                      MarkerSettings(isVisible: true),
                                ),
                                LineSeries<Weight, DateTime>(
                                    color: Colors.purpleAccent[100],
                                    dataSource: newWeightData,
                                    xAxisName: 'xAxis',
                                    yAxisName: 'yAxis',
                                    xValueMapper: (Weight data, _) => data.date,
                                    yValueMapper: (Weight data, _) =>
                                        data.weight,
                                    pointColorMapper: (Weight data, _) =>
                                        data.color,
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
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
                        child:
                            Icon(Icons.multiline_chart, color: Colors.purple),
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
                                zoomPanBehavior:
                                    ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x),
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
                                    minimum: DateTime(minDate.year,
                                        minDate.month, minDate.day),
                                    maximum: DateTime(maxDate.year,
                                        maxDate.month, maxDate.day)),
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
                                        xValueMapper: (Bmi data, _) =>
                                            data.date,
                                        yValueMapper: (Bmi data, _) => data.bmi,
                                        pointColorMapper: (Bmi data, _) =>
                                            data.color,
                                        markerSettings:
                                            MarkerSettings(isVisible: true)),
                                    LineSeries<Bmi, DateTime>(
                                        color: Colors.grey,
                                        opacity: 1.0,
                                        dataSource: newBmi,
                                        xValueMapper: (Bmi data, _) =>
                                            data.date,
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
                            },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.red[200],)
                          ),),
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
                            },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.red[200],)
                          ),),
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
                        ),),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context).yourHistory),
                  ),
                ]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                  //   print(patientHistoryData[i].day);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        DateTime.parse(
                                                    patientHistoryData[i].day)
                                                .day
                                                .toString() +
                                            dateMap[DateTime.parse(
                                                    patientHistoryData[i].day)
                                                .day],
                                        style: TextStyle(
                                            fontSize: 30, color:Colors.blue),
                                      ),
                                      Text(
                                          DateFormat('yMMM').add_jm().format(
                                              (patientHistoryData[i].date)
                                                  .toLocal()),
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.blue))
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (patientHistoryData[i].urineProtein !=
                                      null)
                                    Text(
                                        AppLocalizations.of(context).urineProtein+": " +
                                            patientHistoryData[i]
                                                .urineProtein
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getUrineMeasurementColor(patientHistoryData[i]
                                              .urineProtein)/*patientHistoryData[i]
                                                      .urineProteinStatus ==
                                                  2
                                              ? Colors.red
                                              : Colors.black*/,
                                        )),
                                  if (patientHistoryData[i].medicineDosage != null)
                                    Text(
                                        AppLocalizations.of(context).medicineDosage+": " +
                                            patientHistoryData[i]
                                                .medicineDosage
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        )),
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
                                              patientHistoryData[i].bmiStatus ==
                                                      2
                                                  ? Colors.red
                                                  : Colors.black,
                                        )),
                                  if (patientHistoryData[i].category != null)
                                    patientHistoryData[i].category.toString() != "" ? Text(
                                        AppLocalizations.of(context).category+": " + patientHistoryData[i].category.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black/*patientHistoryData[i]
                                                      .urineProteinStatus ==
                                                  2
                                              ? Colors.red
                                              : Colors.black*/,
                                        )):Container(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showDialog(patientHistoryData[i].patientId,
                                      patientHistoryData[i].date, context, i);
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

                                          /*(patientHistoryData != null) &&
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
                     if(patientHistoryData[i].comments!="") Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Flexible(child:Text(
                            AppLocalizations.of(context).extraComments+": " +
                                  patientHistoryData[i].comments.toString(),
                              style: TextStyle(fontSize: 15)),)
                        ],
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ));
                },
                    childCount: (patientHistoryData != null)
                        ? patientHistoryData.length
                        : 0),
              ),
            ]),
          )
        ]));
  }

  openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print("not open");
    }
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

      for(int i=0;i<patientHistoryData.length;i++){

        List<dynamic> row = List();
        row.add((patientHistoryData[i].date).toLocal().day.toString() +
            dateMap[patientHistoryData[i].date.toLocal().day] + " " + DateFormat('yMMM').add_jm().format(
            patientHistoryData[i]
                .date
                .toLocal()));
        row.add(patientHistoryData[i].urineProtein!=null?patientHistoryData[i].urineProtein.toString():"");
        row.add(patientHistoryData[i].medicineDosage!=null?patientHistoryData[i].medicineDosage.toString():"");
        row.add(patientHistoryData[i].systolicBP!=null?patientHistoryData[i].systolicBP.toString():"");
        row.add(patientHistoryData[i].diastolicBP!=null?patientHistoryData[i].diastolicBP.toString():"");
        row.add(patientHistoryData[i].bodyWeight!=null?patientHistoryData[i].bodyWeight.toString():"");
        row.add(patientHistoryData[i].bodyHeight!=null?patientHistoryData[i].bodyHeight.toString():"");
        row.add(patientHistoryData[i].bmi.toString());
        row.add(patientHistoryData[i].category!=null?patientHistoryData[i].category.toString():"");
        row.add(patientHistoryData[i].comments!=null?patientHistoryData[i].comments.toString():"");
        rows.add(row);
      }

      String csvData = ListToCsvConverter().convert(rows);
      final String directory = (await DownloadsPathProvider.downloadsDirectory).path;
      final path = directory + "/" + username.toString() + "_" +
          DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now()) + ".csv";
      print(path);
      final File file = File(path);
      await file.writeAsString(csvData);
      showToast(AppLocalizations.of(context).yourHistoryDownloadSuccessfully);
      /* String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);*/
    }else if(status.isRestricted){
      Permission.storage.request();
      showToast(AppLocalizations.of(context).pleaseGiveTheStoragePermissionFromSetting);
    }else{
      showToast(AppLocalizations.of(context).pleaseGiveTheStoragePermissionFromSetting);
    }
  }

  void showToast(String message) {

    Toast.show(message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,backgroundColor: Colors.red,
        textColor: Colors.white);

  /*  Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );*/
  }

  void showDialog1(message, context) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog

          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    //backgroundColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Image.asset('images/switch_doc.png',
                                  width: 30.0, height: 30.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  " " + AppLocalizations.of(context).changeDoc,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: TextField(
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  hintText: AppLocalizations.of(context).enterDoctorsNumber),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              onChanged: (value) {
                                mobile = value;
                                doctorDetails(mobile).then((doctorData) {
                                  if (doctorData != null) {
                                    if (this.mounted)
                                      setState(() {
                                        doctor = doctorData;
                                        // print("+++++++++++++++++++++++++++++++");
                                        // print(doctorToJson(doctor));                                        // print(doctor.name);
                                        // print(doctor.hospital);
                                      });
                                  }
                                });
                              },
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                              elevation: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppLocalizations.of(context).doctorName+":"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text((doctor != null &&
                                                doctor.name != null)
                                            ? doctor.name
                                            : ""),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(AppLocalizations.of(context).doctorHospital+": "),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text((doctor != null &&
                                                doctor.hospital != null)
                                            ? doctor.hospital
                                            : ""),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: OutlinedButton(
                              child: Text(AppLocalizations.of(context).change,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                //  print("doctor");
                                print(patient.doctorMobile);
                                // setState(() {
                                updateDoctorData.doctorName = doctor.name;
                                updateDoctorData.doctorHospital =
                                    doctor.hospital;
                                updateDoctorData.doctorMobile = doctor.mobile;
                                updateDoctorData.patientId = username;

                                changeDoctor(updateDoctorData)
                                    .then((patientData) {
                                  if (patientData != null) {
                                    updateDoctorData = patientData;
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/patient',
                                            (Route<dynamic> route) => false);
                                    // print(updateDoctorDataToJson(patientData));
                                  }
                                });
                                // });
                                //});
                              },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.red[200],)
                                  ),
                            )),
                          ),
                        ],
                      ),
                    ));
              }));
        });
  }

  void _showDialog(patientId, date, context, index) {
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
                    onPressed: ()async {
                     await deletePatientHistory(patientId, date);
                      if (this.mounted)
                        setState(() {
                         // patientHistoryData.removeAt(index);
                          //doctorsDataList.removeWhere((i)=>i.;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/patient', (Route<dynamic> route) => false);
                        });
                    })
              ]);
        });
  }
}

class SalesData {
  SalesData(this.day, this.sales, this.color);
  final double day;
  final double sales;
  final Color color;
}

class UrineProteinData {
  final DateTime date;
  final int urineProtein;
  final Color color;
  UrineProteinData(this.date, this.urineProtein, this.color);
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
