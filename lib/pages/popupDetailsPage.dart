import 'package:flutter/material.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/services/doctorServices.dart';

//import 'package:utsarjan/services/doctorServices.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupdetailsPage extends StatefulWidget {
  final String username;

  const PopupdetailsPage({this.username});

  @override
  _PopupdetailsPageState createState() => _PopupdetailsPageState();
}

class _PopupdetailsPageState extends State<PopupdetailsPage> {
  bool history = false;
  bool ischecked2 = false;

  bool ischecked3 = false;

  bool ischecked4 = false;
  bool ischecked5 = false;
  bool button = false;
  bool button1 = false;
  String username;

  bool authenticate = false;
  bool nephrosis = false;
  Patient patient;

  // Details details;
  bool b;

  String birthdayWeightYes = "0",birthdayWeightNo = "0", birthdayPretermYes = "0",birthdayPretermNo = "0";
  String familySyndromeYes = "0",familySyndromeNo = "0", familyKidneyFailureYes = "0",familyKidneyFailureNo = "0";
  String familySyndromeName = "",familyKidneyFailureName="";
  String familyAsthmaYes = "0",familyAsthmaNo = "0", familyAtopyYes = "0",familyAtopyNo = "0", familyRhinitisYes = "0",familyRhinitisNo = "0";

  bool loading = false;

  @override
  void initState() {
    username = widget.username;
    print("((((((((((((((((((((((((((((((");
    getDetailsOfPatient(username).then((authenticationdetails) {
      setState(() {
        patient = authenticationdetails;
        print(patientToJson(patient));

        authenticate = patient.authenticate;
        nephrosis = patient.nephrosis;


        if(patient.authenticateData.historyBirthdayWeight.contains(",")){
          birthdayWeightYes = patient.authenticateData.historyBirthdayWeight.split(",")[0];
          birthdayWeightNo = patient.authenticateData.historyBirthdayWeight.split(",")[1];
        }else{
          birthdayWeightYes="0";
          birthdayWeightNo="0";
        }

        if(patient.authenticateData.historyBirthdayPreterm.contains(",")){
          birthdayPretermYes = patient.authenticateData.historyBirthdayPreterm.split(",")[0];
          birthdayPretermNo = patient.authenticateData.historyBirthdayPreterm.split(",")[1];
        }else{
          birthdayPretermYes="0";
          birthdayPretermNo="0";
        }

        if(patient.authenticateData.historyFamilySyndrome.contains(",")){
          familySyndromeYes = patient.authenticateData.historyFamilySyndrome.split(",")[0];
          familySyndromeNo = patient.authenticateData.historyFamilySyndrome.split(",")[1];
          familySyndromeName = patient.authenticateData.historyFamilySyndrome.split(",")[2];
        }else{
          familySyndromeYes="0";
          familySyndromeNo="0";
          familySyndromeName = "";
        }

        if(patient.authenticateData.historyFamilyKidneyDisease.contains(",")){
          familyKidneyFailureYes = patient.authenticateData.historyFamilyKidneyDisease.split(",")[0];
          familyKidneyFailureNo = patient.authenticateData.historyFamilyKidneyDisease.split(",")[1];
          familyKidneyFailureName = patient.authenticateData.historyFamilyKidneyDisease.split(",")[2];
        }else{
          familyKidneyFailureYes="0";
          familyKidneyFailureNo="0";
          familyKidneyFailureName = "";
        }

        if(patient.authenticateData.historyPastAsthma.contains(",")){
          familyAsthmaYes = patient.authenticateData.historyPastAsthma.split(",")[0];
          familyAsthmaNo = patient.authenticateData.historyPastAsthma.split(",")[1];
        }else{
          familyAsthmaYes="0";
          familyAsthmaNo="0";
        }

        if(patient.authenticateData.historyPastAtopy.contains(",")){
          familyAtopyYes = patient.authenticateData.historyPastAtopy.split(",")[0];
          familyAtopyNo = patient.authenticateData.historyPastAtopy.split(",")[1];
        }else{
          familyAtopyYes="0";
          familyAtopyNo="0";
        }

        if(patient.authenticateData.historyPastAllergicRhinitis.contains(",")){
          familyRhinitisYes = patient.authenticateData.historyPastAllergicRhinitis.split(",")[0];
          familyRhinitisNo = patient.authenticateData.historyPastAllergicRhinitis.split(",")[1];
        }else{
          familyRhinitisYes="0";
          familyRhinitisNo="0";
        }


      });
    });

    super.initState();
  }

//  changePatientDetails(patient)
//                                                 .then((authentication) {
//                                               setState(() {
//                                                 if (authentication != null) {
//                                                   patient = authentication;
//                                                   print(patientToJson(patient));

//                                                   print("finish");
//                                                 }
//                                               });
//                                             });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).utsarjan),
        backgroundColor: Colors.red[200],
      ),
      body: patient == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).patientHistory,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context).birthHistory+" : "+AppLocalizations.of(context).birthWeight+" < 2.5 Kg",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: birthdayWeightYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        birthdayWeightYes = "1";
                                      }else{
                                        birthdayWeightYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: birthdayWeightNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        birthdayWeightNo = "1";
                                      }else{
                                        birthdayWeightNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context).birthHistory+" : Preterm (<9months)",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: birthdayPretermYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        birthdayPretermYes = "1";
                                      }else{
                                        birthdayPretermYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: birthdayPretermNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        birthdayPretermNo = "1";
                                      }else{
                                        birthdayPretermNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context).familyHistoryOfNephroticSyndrome,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familySyndromeYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familySyndromeYes = "1";
                                      }else{
                                        familySyndromeYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familySyndromeNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familySyndromeNo = "1";
                                      }else{
                                        familySyndromeNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          visible: familySyndromeYes=='1'?true:false,
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context).inWhom+":",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 150,
                                child: TextField(
                                  cursorColor: Colors.red[200],
                                  decoration: InputDecoration(
                                      focusedBorder: new UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red[200])),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 7),
                                      hintText: ""),
                                  style: TextStyle(fontSize: 14),
                                  controller:
                                      TextEditingController(text: familySyndromeName),
                                  onChanged: (value) {
                                    familySyndromeName = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context).familyHistoryOfKidneyDiseaseOfKidneyFailure,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyKidneyFailureYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyKidneyFailureYes = "1";
                                      }else{
                                        familyKidneyFailureYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyKidneyFailureNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyKidneyFailureNo = "1";
                                      }else{
                                        familyKidneyFailureNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          visible: familyKidneyFailureYes == '1'?true:false,
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context).inWhom+":",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 150,
                                child: TextField(
                                  cursorColor: Colors.red[200],
                                  decoration: InputDecoration(
                                      focusedBorder: new UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red[200])),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 7),
                                      hintText: ""),
                                  style: TextStyle(fontSize: 14),
                                  controller: TextEditingController(
                                      text: familyKidneyFailureName),
                                  onChanged: (value) {
                                    familyKidneyFailureName = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context).pastHistorySuggestiveOfAsthma,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyAsthmaYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyAsthmaYes = "1";
                                      }else{
                                        familyAsthmaYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyAsthmaNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyAsthmaNo = "1";
                                      }else{
                                        familyAsthmaNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context).pastHistorySuggestiveOfAtopy,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyAtopyYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyAtopyYes = "1";
                                      }else{
                                        familyAtopyYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyAtopyNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyAtopyNo = "1";
                                      }else{
                                        familyAtopyNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context).pastHistorySuggestiveOfAllergicRhinitis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyRhinitisYes=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyRhinitisYes = "1";
                                      }else{
                                        familyRhinitisYes = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).yes)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Colors.red[200],
                                  value: familyRhinitisNo=="1"?true:false,
                                  onChanged: (bool val) {
                                    setState(() {
                                      if(val){
                                        familyRhinitisNo = "1";
                                      }else{
                                        familyRhinitisNo = "0";
                                      }
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context).no)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                    elevation: 4,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).patientDetails),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppLocalizations.of(context).updateThisInformationWithUtmostSurity,
                                style:
                                    TextStyle(color: Colors.pink, fontSize: 10),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context).authenticate,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    new Switch(
                                        value: authenticate,
                                        activeColor: Colors.red[200],
                                        onChanged: (bool value) {
                                          // _showDialog("", context);
                                          setState(() {
                                             //button = value;
                                            print(
                                                "^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                                            /*changePatientDetails(patient)
                                                .then((authentication) {
                                              setState(() {
                                                //if (authentication != null) {
                                                  //patient = authentication;
                                                  print(patientToJson(patient));

                                                  print("finish");
                                                //}
                                              });
                                            });*/
                                            authenticate = value;
                                            if (authenticate == false)
                                              // patient = patient;
                                              print(authenticate);
                                          });
                                        }),
                                  ]),
                              Container(
                                height: 20,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).nephroticSyndrome,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      new Switch(
                                          value: nephrosis,
                                          activeColor: Colors.red[200],
                                          onChanged: (bool value) {
                                            setState(() {
                                              //button1 = value;
                                              /*changePatientDetails(patient)
                                                  .then((authentication) {
                                                setState(() {
                                                  if (authentication != null) {
                                                    //patient = authentication;
                                                    print(
                                                        patientToJson(patient));

                                                    print("finish");
                                                  }
                                                });
                                              });*/
                                              nephrosis = value;
                                              print(nephrosis);
                                            });
                                          }),
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]))),
                Container(
                  width: 200,
                  padding: EdgeInsets.all(30),
                  child: OutlinedButton(
                      child: !loading
                          ? Text(
                        AppLocalizations.of(context).updateAll,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator())),
                      onPressed: _handleSendPress,
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _handleSendPress() {
    setState(() {
      loading = true;
    });

    patient.authenticateData.historyBirthdayWeight = birthdayWeightYes+","+birthdayWeightNo;
    patient.authenticateData.historyBirthdayPreterm = birthdayPretermYes+","+birthdayPretermNo;
    patient.authenticateData.historyFamilySyndrome = familySyndromeYes+","+familySyndromeNo+","+familySyndromeName;
    patient.authenticateData.historyFamilyKidneyDisease = familyKidneyFailureYes+","+familyKidneyFailureNo+","+familyKidneyFailureName;
    patient.authenticateData.historyPastAsthma = familyAsthmaYes+","+familyAsthmaNo;
    patient.authenticateData.historyPastAtopy = familyAtopyYes+","+familyAtopyNo;
    patient.authenticateData.historyPastAllergicRhinitis = familyRhinitisYes+","+familyRhinitisNo;

    patient.authenticate = authenticate;
    patient.nephrosis = nephrosis;

    print(patientToJson(patient));

    changePatientDetails(patient).then((authentication) {

      setState(() {
        loading = false;
      });

      showToast(AppLocalizations.of(context).updateDataSuccessfully);
    });
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

// void _showDialog(message, context) {
//   // flutter defined function
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 40,
//               width: 150,
//               alignment: Alignment.bottomCenter,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                       BorderRadius.circular(30)), // make rounded corner
//               child: Center(
//                 child: const Text(
//                   'Details Updated',
//                   style: TextStyle(
//                     decoration: TextDecoration.none,
//                     fontSize: 15,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ));
//       });
// }
}
