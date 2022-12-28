import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/notifyDataModel.dart';
import 'package:utsarjan/services/notificationServices.dart';
import 'package:utsarjan/services/globalData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllNotificationsPage extends StatefulWidget {
  final String username;
  final bool isTestNotification;

  const AllNotificationsPage({this.username,this.isTestNotification});
  @override
  _AllNotificationsPageState createState() => _AllNotificationsPageState();
}

class _AllNotificationsPageState extends State<AllNotificationsPage> {
  Notifications notify = new Notifications();  
  List<Notifications> notificationsList;
  // String doctorMobile;
  String username;
  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
      username = instance.getString('username');
      setState(() {
        print("oooooooooooooooooooooooooooooooooo");
        print(username);
        print("********************************************");
        notify = new Notifications(
          doctorId: username,
          date: DateTime.now(),
        );
        if(widget.isTestNotification){
         getTestNotifications(username,false).then((notify) {
          setState(() {
            print("000000000000000000123, istest true");
             //print(notificationsListToJson(notificationsList) );
            notificationsList = notify;

            for(int i=0;i<notificationsList.length;i++){
              print("Test -- " + notificationsList[i].photo);
            }

          });
        });
        }else{
          getNotifications(username).then((notify) {
          setState(() {
            print("00000000000000000000000000000000000000123 - getPostedNotification");
            notificationsList = notify;
            print(notificationsListToJson(notificationsList));

            /*for(int i=0;i<notificationsList.length;i++){

              print("Test false -- " + notificationsList[i].notification);
            }*/

          });
        }); 
        }       
      });
    });
    super.initState();
  }

  Widget listItem(Notifications notifications) {

    return Container(
    //  height: 100.0,
      padding: EdgeInsets.all(10.0),
      child: notifications.tests != "" || notifications.medicationDetail != null ? Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  notifications.patientDetail != null && notifications.doctorDetail != null ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(notifications.patientDetail.uhid != null ? AppLocalizations.of(context).uhid+": "+notifications.patientDetail.uhid : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  (notifications.patientDetail.name != null)
                                      ? AppLocalizations.of(context).name+": " + notifications.patientDetail.name
                                      : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(notifications.patientDetail.gender != null ? AppLocalizations.of(context).sex+": "+notifications.patientDetail.gender : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(notifications.patientDetail.age != null ? AppLocalizations.of(context).age+": "+notifications.patientDetail.age + " " + AppLocalizations.of(context).yrs : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context).date+": " + DateFormat('dd-MM-yyyy').format(notifications.date.toLocal()).toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),),
                                SizedBox(height: 3),
                                Text( AppLocalizations.of(context).time+": " + DateFormat('hh:mma').format(notifications.date.toLocal()).toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),),
                                SizedBox(height: 10),
                                Text(notifications.doctorDetail.hospital != null ? AppLocalizations.of(context).hospital+": "+notifications.doctorDetail.hospital : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(notifications.doctorDetail.name != null ? AppLocalizations.of(context).name+": "+notifications.doctorDetail.name : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  ) : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(DateFormat('hh:mma dd-MM-yyyy').format(notifications.date.toLocal()).toString(),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black54,
                              ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  notifications.photo != ''
                      ? GestureDetector(
                        onTap: (){
                          _showImage(context, notifications.photo);
                        },
                        child: Image.network(notifications.photo.contains("public")
                        ? serverIP + '/' + notifications.photo
                        : serverIP + '/public/' + notifications.photo),
                      )
                      : Text(notifications.medicationDetail != null ? setMedicineDetails(notifications.medicationDetail) : notifications.tests != "" ? getTestText(notifications.tests) : notifications.notification != null ? "\n"+notifications.notification : ""),
                  SizedBox(height: 3,),
                  //Text((notifications.patientName!=null)?notifications.patientName:"",)
                ]),
          )) : Card(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (notifications.patientName != null)
                          ? notifications.patientName
                          : "",
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 16,
                                color: Colors.black,
                              ),
                    ),
                  ),
                  Text( DateFormat('hh:mma dd-MM-yyyy').format(notifications.date.toLocal()).toString(), style: TextStyle(
                    color: Colors.black54,
                  ),)
                ],
              ),
              SizedBox(height: 3,),
              notifications.photo != ''
                  ? GestureDetector(
                    onTap: (){
                      _showImage(context, notifications.photo);
                    },
                    child: Image.network(notifications.photo.contains("public")
                    ? serverIP + '/' + notifications.photo
                    : serverIP + '/public/' + notifications.photo),
                  )
                  : Text(notifications.medicationDetail != null ? setMedicineDetails(notifications.medicationDetail) : notifications.tests != "" ? getTestText(notifications.tests) : notifications.notification != null ? "\n"+notifications.notification : ""),
               SizedBox(height: 3,),
              //Text((notifications.patientName!=null)?notifications.patientName:"",)
            ]),
      )),
    );
  }

  _showImage(BuildContext context, String image) {
    // flutter defined function
    //selectImage(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            child: Column(
                children: <Widget>[
                  Expanded(
                    child: PhotoView(
                      imageProvider: NetworkImage(
                          image.contains("public")
                              ? serverIP + '/' + image
                              : serverIP + '/public/' + image
                      ),
                    ),
                  ),
                  /*OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.white,
                  child:  const Text('Close',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  borderSide: BorderSide(
                    color: Colors.red[200],
                  )),*/
                ]),
          );
        });
      },
    );
  }

  String setMedicineDetails(DataModel medicineDetail){

    String medicine = "";

    medicine = AppLocalizations.of(context).formulation+": " + medicineDetail.formulation;
    medicine = medicine + "\n"+AppLocalizations.of(context).brandName+": " + medicineDetail.brandName;
    medicine = medicine + "\n"+AppLocalizations.of(context).actualMedicine+": " + medicineDetail.actualMedicine;
    medicine = medicine + "\n"+AppLocalizations.of(context).strength+": " + medicineDetail.strength;
    medicine = medicine + "\n"+AppLocalizations.of(context).advisedDose+": " + medicineDetail.advisedDose.toString();
    medicine = medicine + "\n"+AppLocalizations.of(context).numberOfTimes+": " + medicineDetail.numberOfTimes;
    medicine = medicine + "\n"+AppLocalizations.of(context).effectiveDailyDose+": " + medicineDetail.effectiveDailyDose.toString();
    medicine = medicine + "\n"+AppLocalizations.of(context).howManyDays+": " + medicineDetail.howManyDays.toString() + " "+AppLocalizations.of(context).weeks;
    medicine = medicine + "\n"+AppLocalizations.of(context).remark+": " + medicineDetail.remarks.toString();

    String formulationOne = medicineDetail.formulationOther.split("*")[0];
    String formulationTwo = medicineDetail.formulationOther.split("*")[1];
    String formulationThree = medicineDetail.formulationOther.split("*")[2];

    if(formulationOne != "Formulation") {
      String brandName = medicineDetail.brandNameOther.split("*")[0];
      medicine = medicine + "\n\n"+AppLocalizations.of(context).formulation+": " + formulationOne;
      medicine = medicine + "\n"+AppLocalizations.of(context).brandName+": " + brandName;
      medicine = medicine + "\n"+AppLocalizations.of(context).actualMedicine+": " +  medicineDetail.actualMedicineOther.split("*")[0];
      medicine = medicine + "\n"+AppLocalizations.of(context).strength+": " + medicineDetail.strengthOther.split("*")[0];
      medicine = medicine + "\n"+AppLocalizations.of(context).advisedDose+": " + medicineDetail.advisedDoseOther.split("*")[0];
      medicine = medicine + "\n"+AppLocalizations.of(context).numberOfTimes+": " + medicineDetail.numberOfTimesOther.split("*")[0];
      medicine = medicine + "\n"+AppLocalizations.of(context).effectiveDailyDose+": " + medicineDetail.effectiveDailyDoseOther.split("*")[0];
      medicine = medicine + "\n"+AppLocalizations.of(context).howManyDays+": " + medicineDetail.howManyDaysOther.split("*")[0] + " " + getDuration(brandName);
      medicine = medicine + "\n"+AppLocalizations.of(context).remark+": " + medicineDetail.remarksOther.split("*")[0];
    }

    if(formulationTwo != "Formulation") {
      String brandName = medicineDetail.brandNameOther.split("*")[1];
      medicine = medicine + "\n\n"+AppLocalizations.of(context).formulation+": " + formulationTwo;
      medicine = medicine + "\n"+AppLocalizations.of(context).brandName+": " + medicineDetail.brandNameOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).actualMedicine+": " + medicineDetail.actualMedicineOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).strength+": " + medicineDetail.strengthOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).advisedDose+": " + medicineDetail.advisedDoseOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).numberOfTimes+": " + medicineDetail.numberOfTimesOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).effectiveDailyDose+": " + medicineDetail.effectiveDailyDoseOther.split("*")[1];
      medicine = medicine + "\n"+AppLocalizations.of(context).howManyDays+": " + medicineDetail.howManyDaysOther.split("*")[1] + " " + getDuration(brandName);
      medicine = medicine + "\n"+AppLocalizations.of(context).remark+": " + medicineDetail.remarksOther.split("*")[1];
    }

    if(formulationThree != "Formulation") {
      String brandName = medicineDetail.brandNameOther.split("*")[2];
      medicine = medicine + "\n\n"+AppLocalizations.of(context).formulation+": " + formulationThree;
      medicine = medicine + "\n"+AppLocalizations.of(context).brandName+": " + medicineDetail.brandNameOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).actualMedicine+": " + medicineDetail.actualMedicineOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).strength+": " + medicineDetail.strengthOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).advisedDose+": " + medicineDetail.advisedDoseOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).numberOfTimes+": " + medicineDetail.numberOfTimesOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).effectiveDailyDose+": " + medicineDetail.effectiveDailyDoseOther.split("*")[2];
      medicine = medicine + "\n"+AppLocalizations.of(context).howManyDays+": " + medicineDetail.howManyDaysOther.split("*")[2] + " " + getDuration(brandName);
      medicine = medicine + "\n"+AppLocalizations.of(context).remark+": " + medicineDetail.remarksOther.split("*")[2];
    }

    return medicine;

  }

  getDuration(String brandName){
    String duration = brandName == "Lasix" ? AppLocalizations.of(context).days
        : (brandName == "Endoxan" || brandName == "Cycloxan")
        ? AppLocalizations.of(context).weeks
        : AppLocalizations.of(context).months;
    return duration;
  }

  String getTestText(String jsonTest){

    String examination = "";
    String eyeExamination = "";
    String bloodTest = "";
    String urineTest = "";

    var json = jsonDecode(jsonTest);

    String examinationText = json["examination"][0];
    if(examinationText!="") {
      if (examinationText.contains("*")) {
        List<dynamic> examinationArray = examinationText.split("*");
        for (int i = 0; i < examinationArray.length; i++) {
          if (examination == '') {
            examination = examinationArray[i] + "\n";
          } else {
            examination = examination + examinationArray[i] + "\n";
          }
        }
      } else {
        examination = examinationText + "\n";
      }
    }

    String eyeExaminationText = json["eye_examination"][0];
    if(eyeExaminationText!="") {
      if (eyeExaminationText.contains("*")) {
        List<dynamic> eyeExaminationArray = eyeExaminationText.split("*");
        for (int i = 0; i < eyeExaminationArray.length; i++) {
          if (eyeExamination == '') {
            eyeExamination = eyeExaminationArray[i] + "\n";
          } else {
            eyeExamination = eyeExamination + eyeExaminationArray[i] + "\n";
          }
        }
      } else {
        eyeExamination = eyeExaminationText + "\n";
      }
    }

    String bloodTestText = json["blood_tests"][0];
    if(bloodTestText!="") {
      if (bloodTestText.contains("*")) {
        List<dynamic> bloodTestArray = bloodTestText.split("*");
        for (int i = 0; i < bloodTestArray.length; i++) {
          if (bloodTest == '') {
            bloodTest = bloodTestArray[i] + "\n";
          } else {
            bloodTest = bloodTest + bloodTestArray[i] + "\n";
          }
        }
      } else {
        bloodTest = bloodTestText + "\n";
      }
    }

    String urineTestText = json["urine_tests"][0];
    if(urineTestText!="") {
      if (urineTestText.contains("*")) {
        List<dynamic> urineTestArray = urineTestText.split("*");
        for (int i = 0; i < urineTestArray.length; i++) {
          if (urineTest == '') {
            urineTest = urineTestArray[i] + "\n";
          } else {
            urineTest = urineTest + urineTestArray[i] + "\n";
          }
        }
      } else {
        urineTest = urineTestText + "\n";
      }
    }

    String additionalTest = json["additional_tests"][0];
    String comment = json["comment"] != null ? json["comment"][0] : "";

    String temp="";

    if(examination!=""){
      temp = AppLocalizations.of(context).examination+":\n"+examination;
    }

    if(eyeExamination!=""){
      temp = temp + "\n"+AppLocalizations.of(context).eyeExamination+"\n"+eyeExamination;
    }

    if(bloodTest!=""){
      temp = temp + "\n"+AppLocalizations.of(context).bloodTests+"\n"+bloodTest;
    }

    if(urineTest!=""){
      temp = temp + "\n"+AppLocalizations.of(context).urineTests+"\n"+urineTest;
    }

    if(additionalTest != ""){
      temp = temp + "\n"+AppLocalizations.of(context).additionalTests+"\n"+additionalTest;
    }

    if(comment != ""){
      temp = temp + "\n\n"+AppLocalizations.of(context).comm+"\n"+comment;
    }

    temp = temp + "\n\n"+AppLocalizations.of(context).requisitionIsElectronicallyGenerated;

    return temp;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context).notifications),
            backgroundColor: Colors.red[200],
            actions: <Widget>[
              PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: InkWell(
                          child: Row(children: <Widget>[
                            new Image.asset('images/logout.png',
                                width: 40.0, height: 40.0),
                            Text("  " + AppLocalizations.of(context).logout),
                          ]),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/home');
                          },
                        )),
                      ])
            ]),
        body: (notificationsList == null)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount:
                    (notificationsList == null) ? 0 : notificationsList.length,
                itemBuilder: (BuildContext context, i) {
                  print(notificationsList.length);
                  return listItem(notificationsList[i]);
                }));
  }
}
