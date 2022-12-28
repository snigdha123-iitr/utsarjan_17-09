import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/doctorModel.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:utsarjan/services/patientSevices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:age/age.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientRegistration extends StatefulWidget {
  PatientRegistration({Key key, this.title,this.fcmToken}) : super(key: key);
  final String title;
  final String fcmToken;

  @override
  _PatientRegistrationState createState() => new _PatientRegistrationState();
}

class _PatientRegistrationState extends State<PatientRegistration> {
  TextEditingController controller = new TextEditingController();
  TextEditingController ageOnSetController = new TextEditingController();
  String username = "";
  String password = "";
  List<Doctor> doctorsList;
  Doctor doctor;
  String mobile;
  String doctorMobile;
  // int year = 0;
  // int monthsCounts = 0;
  List<String> stages, ssnsList, ssnsIrList, ssnsLrList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final dateFormat = DateFormat("MMMM d,yyyy");
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController uhidTextController = TextEditingController();
  final TextEditingController mobileNoTextController = TextEditingController();
  String name = "";
  bool validName = false;
  String uhid = "";
  bool validUhid = false;
  bool validmobileNumber = false;
  bool validEmail =false; 
  bool errorDateOnset=false;
  bool errorDateOfBirth=false;
  bool validFormat=false;
  String categorydropdown;
  String stagedropdown;
  String categoryError;
  String stageError;
  String genderdropdown;

  String age;
  String ageOnSet;
  DateTime currentDate = DateTime.now();
  DateTime dob;
  DateTime dateOfOnset;
  bool displayDoctor = false;
  String dateOfRegistration = DateFormat("yyyy-MM-dd").format(DateTime.now());
  Patient patient = new Patient();
  bool isLoading=false;

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    allDoctors().then((doctors) {
      setState(() {
        doctorsList = doctors;
      });
    });
    print(widget.fcmToken);
    stages = ["Stage"];
    ssnsList = ["Stage", "0", "1", "2", "3"];
    ssnsIrList = ["Stage", "4", "5", "6", "7", "8", "9", "10"];
    ssnsLrList = ["Stage", "4", "5", "6", "7", "8", "9", "10"];
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    uhidTextController.dispose();
    mobileNoTextController.dispose();
    super.dispose();
  }

  void signUpPatient() {

       Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
 bool isValidFormat= patient.email!=null&&(regex.hasMatch(patient.email.trim())); 

    if(patient.name==null||patient.name==''){
      setState(() {
        validName=true;
      });
//showSnakBar(_scaffoldKey, "Name is required");
return;
    }else if(patient.dob==null||patient.dob==''){
       setState(() {
        errorDateOfBirth=true;
      });
// showSnakBar(_scaffoldKey, "Select Date of Birth");
    }else if(patient.dateOfOnset==null||patient.dateOfOnset==''){
       setState(() {
        errorDateOnset=true;
      });
//showSnakBar(_scaffoldKey, "Select Date of Onset");
    }else if(patient.gender==null||patient.gender==''){ 
//showSnakBar(_scaffoldKey, "Select your gender");
    }
    else if(patient.uhid==null||patient.uhid==''){
  setState(() {
        validUhid=true;
      });
//showSnakBar(_scaffoldKey, "UHID is required ");
    }
    else if(patient.mobileNumber==null||patient.mobileNumber==''){
 setState(() {
        validmobileNumber=true;
      });
//showSnakBar(_scaffoldKey, "Mobile Number is required");
    }else if(patient.email==null||patient.email==''){
 setState(() {
        validEmail=true;
      });
//showSnakBar(_scaffoldKey, "Email is required");
    }
    else if(!isValidFormat){
 setState(() {
        validFormat=true;
      });
//showSnakBar(_scaffoldKey, "Invalid Email Format");
    }
     /*else if(patient.doctorMobile==null||patient.doctorMobile==''){
      setState(() {
        displayDoctor=true;
      });
      showSnakBar(_scaffoldKey, "Doctor Mobile Number is required");
    }*/
    else{
    //patient.password = patient.name.substring(0, patient.name.length > 6 ? 6 : patient.name.length) +'_' + patient.uhid;

      if(!displayDoctor){
        patient.doctorMobile = "9999999999";
        patient.doctorName = "Dr Navid Iqbal";
      }else{
        if(patient.doctorMobile==null||patient.doctorMobile==''){
          patient.doctorMobile = "9999999999";
          patient.doctorName = "Dr Navid Iqbal";
        }
      }

      patient.password = patient.name.substring(0, patient.name.length > 4 ? 4 : patient.name.length) + '_' +
          patient.uhid.substring(0, patient.uhid.length > 4 ? 4 : patient.uhid.length);

    patient.dateOfRegistration = dateOfRegistration;
    patient.fcmToken = widget.fcmToken;
    patient.dateOfOnset =
        dateOfOnset != null ? dateOfOnset.toString() : dateOfRegistration;
    patient.relapse = 0;
    // print('patient==>>');
    print(patientToJson(patient) + " -- ");
    setState(() {
      isLoading=true;
    });
    addPatient(patient).then((result) {
      if (result.status == true) {
        setState(() {
          isLoading=false;
          SharedPreferences.getInstance().then((instance) {
            instance.setString('username', username);
            //instance.setString('type', 'PATIENT');
          }).then((onValue) {
            Navigator.of(context).pushNamedAndRemoveUntil('/patient', (Route<dynamic> route) => false);
          });
        });
      } else{
         setState(() {
          isLoading=false;
          });
        showSnakBar(_scaffoldKey,result.message);}
     
    });
    }
  }

  void getAge(DateTime value) {
    setState(() {
      dob = value;
      AgeDuration age = Age.dateDifference(
          fromDate: dob, toDate: currentDate, includeToDate: false);
      patient.dob = value.toString();
      errorDateOfBirth=false;
      if (currentDate.year != null && dob.year != null) {
        patient.age = '${(age.years)} yr, ${(age.months)} mo';
      }
    });
  }

  void getOnSetAge(DateTime value) {
    setState(() {
      dateOfOnset = value;
      errorDateOnset=false;
      if (dateOfOnset != null) {
        AgeDuration age = Age.dateDifference(
            fromDate: dateOfOnset, toDate: currentDate, includeToDate: false);
        patient.dateOfOnset = DateFormat("yyyy-MM-dd").format(value).toString();
        patient.ageOnSet = '${(age.years)} yr, ${(age.months)} mo';
      } else {
        patient.dateOfOnset =
            DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
        patient.ageOnSet = '';
      }
      // if (currentDate.year != null && dateOfOnset.year != null) {

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).patientRegistration),
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.red[200],
        ),
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  TextField(
                      cursorColor: Colors.red,
                      autofocus: false,
                      controller: nameTextController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[200])),

                        hintText: AppLocalizations.of(context).name,
                        // labelText: 'Name',
                        errorText: validName ? AppLocalizations.of(context).nameIsRequired : null,
                      ),                    
                      onChanged: (value) {
                        setState(() {
                          nameTextController.text.isEmpty
                              ? validName = true
                              : validName = false;
                          name = value;
                          password = value;
                          patient.name = value;
                        });
                        patient.name = value;
                      }),
                  SizedBox(height: 20),
                  DateTimeField(
                    controller: controller,
                    // inputType: InputType.date,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[200])),
                      icon: const Icon(Icons.date_range),
                      hintText: AppLocalizations.of(context).dateOfBirth,
                     errorText: errorDateOfBirth? 'Select Date of Birth':null
                      // labelText: 'Date of Birth',
                      //hasFloatingPlaceholder: false
                    ),
                    onChanged: getAge,
                    format: dateFormat,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: currentValue ?? DateTime.now(),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      Text((patient.age != null)
                          ? AppLocalizations.of(context).ageYrs+":    " + patient.age
                          : AppLocalizations.of(context).ageYrs+":")
                    ],
                  ),
                  SizedBox(height: 20.0),
                  DateTimeField(
                    controller: ageOnSetController,
                    // inputType: InputType.date,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[200])),
                      icon: const Icon(Icons.date_range),
                      hintText: AppLocalizations.of(context).dateOfOnset,
                      errorText:errorDateOnset? AppLocalizations.of(context).selectDateOfOnset:null
                      // labelText: 'Date of Birth',
                      //hasFloatingPlaceholder: false
                    ),
                    onChanged: getOnSetAge,
                    format: dateFormat,                    
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: currentValue ?? DateTime.now(),
                      );                     
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      Text((patient.ageOnSet != null)
                          ? AppLocalizations.of(context).ageOnset+":    " + patient.ageOnSet
                          : AppLocalizations.of(context).ageOnset+":")
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                          isExpanded: false,
                          hint: Text(AppLocalizations.of(context).gender),
                          value: genderdropdown,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              patient.gender = newValue;
                              genderdropdown = newValue;
                            });
                          },
                          items: <String>[AppLocalizations.of(context).girl, AppLocalizations.of(context).boy].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ))
                      ]),
                  SizedBox(height: 10),
                  new TextField(
                      cursorColor: Colors.red,
                      controller: uhidTextController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[200])),
                        hintText: AppLocalizations.of(context).uhid,
                        // labelText: 'UHID',
                        errorText: validUhid ? AppLocalizations.of(context).uhidCanNotBeEmpty : null,
                      ),
                      // inputFormatters: [
                      //   new LengthLimitingTextInputFormatter(10)
                      // ],
                      onChanged: (String value) {
                        setState(() {
                          uhidTextController.text.isEmpty
                              ? validUhid = true
                              : validUhid = false;
                          uhid = value;
                          password = value;
                          patient.uhid = value;
                          patient.password = value;
                        });
                      }),
                  SizedBox(height: 20),
                  new TextField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[200])),
                        hintText: AppLocalizations.of(context).anotherHospitalIDOptional
                        // labelText: 'Optional ID (Optional)'
                        ),
                    onChanged: (value) => patient.optionalid = value,
                  ),
                  SizedBox(height: 20),
                  new TextField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[200])),
                      hintText: AppLocalizations.of(context).address,
                      // labelText: 'Address (Optional)'
                    ),
                    onChanged: (value) => patient.address = value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                          isExpanded: false,
                          hint: Text(AppLocalizations.of(context).category),
                          value: categorydropdown,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              patient.category = newValue;
                              categorydropdown = newValue;
                              patient.previousCategory = newValue;
                              stagedropdown = "Stage";  
                              if (newValue == "SSNS") {
                                stages = ssnsList;
                                patient.stage = "1";
                                patient.previousStage = "1";
                              } else if (newValue == "SRNS-IR") {
                                stages = ssnsIrList;
                                patient.stage = "2";
                                patient.previousStage = "2";
                              } else if (newValue == "SRNS-LR") {
                                stages = ssnsLrList;
                                patient.stage = "3";
                                patient.previousStage = "3";
                              }else if (newValue == "Category")
                                stages = ["Stage"];
                            });
                          },
                          items: <String>['SSNS', 'SRNS-IR', 'SRNS-LR']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        )),
                        // new DropdownButtonHideUnderline(
                        //     child: new DropdownButton<String>(
                        //   isExpanded: false,
                        //   hint: Text("Stage"),
                        //   value: stagedropdown,
                        //   isDense: true,
                        //   onChanged: (String newValue) {
                        //     setState(() {
                        //       stageError = stageError != null ? null : 'error';
                        //       stageError = null;
                        //       patient.stage = newValue;
                        //       stagedropdown = newValue;
                        //     });
                        //   },
                        //   items: stages.map((String value) {
                        //     return new DropdownMenuItem<String>(
                        //       value: value,
                        //       child: new Text(value),
                        //     );
                        //   }).toList(),
                        // )),
                        SizedBox(width: 150,)
                      ]),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Material(
                        color: Colors.white,
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: <Widget>[
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalizations.of(context).yourCredentials),
                                ]),
                            SizedBox(
                              height: 20.0,
                            ),
                            //(loading!=null)?CircularProgressIndicator():
                            TextField(
                                cursorColor: Colors.red,
                                controller: mobileNoTextController,
                                decoration: InputDecoration(
                                  fillColor: Colors.red[200],
                                  filled: true,
                                  hintText: AppLocalizations.of(context).mobileNumber,
                                   errorText: validmobileNumber ? AppLocalizations.of(context).mobileNumberIsRequired : null,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(10)
                                ],
                                onChanged: (String value) {
                                  setState(() {
                                    // mobileNoTextController.text.isEmpty
                                    //     ? validmobileNumber = true
                                    //     :
                                    validmobileNumber = false;
                                    patient.mobileNumber = value;
                                    patient.username = value;
                                    username = value;
                                  });

                                  // patient.username =value ;
                                  //  username = value;
                                }),
                            // Container(
                            //   height: 60,
                            //   width: 300,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(width: 1),
                            //       borderRadius: BorderRadius.circular(32.0),
                            //       color: Colors.red[200]),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(18.0),
                            //     child: Text((patient != null &&
                            //             patient.username != null)
                            //         ? patient.username
                            //         : ''),
                            //   ),
                            // ),

                            // TextField(
                            //     decoration: InputDecoration(
                            //       fillColor: Colors.red[200],
                            //       filled: true,
                            //       // contentPadding: EdgeInsets.fromLTRB(
                            //       //     20.0, 15.0, 20.0, 15.0),
                            //       //icon: Text("+91 -"),
                            //       // Icon(Icons.add),
                            //       hintText: "username(UHID)",

                            //       border: OutlineInputBorder(
                            //         // borderSide: new BorderSide(
                            //         //olor: Colors.red[200]
                            //         //),
                            //         borderRadius: BorderRadius.circular(
                            //           32.0,
                            //         ),
                            //       ),
                            //       //fillColor: Colors.lightBlue,
                            //     ),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         //Text(patient.uhid).toString();
                            //         patient.username = value;
                            //       });

                            //       // print("username is " +
                            //       //     value +
                            //       //     " --- " +
                            //       //     patient.username);
                            //     }),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              height: 60,
                              width: 300,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(32.0),
                                  color: Colors.red[200]),
                              child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text((patient != null &&
                                          patient.name != null &&
                                          patient.password != null)
                                      ? '${patient.name.substring(0, patient.name.length > 4 ? 4 : patient.name.length)}' +
                                          '_' +
                                          '${patient.uhid.substring(0, patient.uhid.length > 4 ? 4 : patient.uhid.length)}'
                                      : "")),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  hintText: AppLocalizations.of(context).email,
                                   errorText: validEmail?AppLocalizations.of(context).emailIsRequired:validFormat?AppLocalizations.of(context).invalidEmailFormat:null
                                  // labelText: "Email (Optional)",
                                  ),
                              onChanged: (value) =>{
                                  setState(() {
                                    validEmail = false;   
                                    validFormat=false;                                 
                                    patient.email = value;
                                  })
                                 },
                            ),
                          ]),
                        )),
                  )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(AppLocalizations.of(context).doctor),
                                    ),
                                    new Switch(
                                        value: displayDoctor,
                                        activeColor: Colors.red[200],
                                        onChanged: (bool e) {
                                          setState(() {
                                            displayDoctor = e;
                                            print(displayDoctor);
                                            patient.doctorMobile = "";
                                            patient.doctorName = "";
                                            doctor.name = "";
                                          });
                                        }),
                                  ]),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  child: (!displayDoctor)
                                      ? null
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                              TextField(
                                                  cursorColor: Colors.red,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                            .red[
                                                                        200])),
                                                    icon: Text("+91 -"),
                                                    hintText:
                                                    AppLocalizations.of(context).registeredDoctorsNumber,
                                                  ),
                                                  inputFormatters: [
                                                    new LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  onChanged: (value) {
                                                    mobile = value;
                                                    patient.doctorMobile =
                                                        value;
                                                    doctorDetails(mobile)
                                                        .then((doctorData) {
                                                      if (doctorData != null) {
                                                        setState(() {
                                                          doctor = doctorData;
                                                          patient.doctorName =
                                                              doctor.name;
                                                          print(
                                                              "+++++++++register++++++++++++++++++++++");
                                                          print(doctorToJson(
                                                              doctor));

                                                          print(doctor.name);
                                                        });
                                                      }
                                                    });
                                                    // setState(() => {userid = enabled});
                                                  }),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              TextField(
                                                  enabled: false,
                                                  cursorColor: Colors.red,
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                          .red[
                                                                      200])),
                                                      hintText: (doctor !=
                                                                  null &&
                                                              doctor.name !=
                                                                  null)
                                                          ? AppLocalizations.of(context).doctorName+":     " +
                                                              '${doctor.name}'
                                                          : AppLocalizations.of(context).doctorName+": "),
                                                  onChanged: (value) {
                                                    name = value;
                                                    setState(() {
                                                      patient.doctorName =
                                                          doctor.name;
                                                    });
                                                  }
                                                  //      SharedPreferences
                                                  //         .getInstance()
                                                  //     .then((instance) {
                                                  //   name = instance
                                                  //       .getString(
                                                  //           "name");
                                                  //           print("==========================123");
                                                  //           print(patient.doctorName);
                                                  //     });
                                                  //   });
                                                  // },

                                                  // ? "Doctor\'s Name: "
                                                  // :doctor.name
                                                  //     ),
                                                  // onChanged: (value) {
                                                  //   // setState(() => {userid = enabled});
                                                  //   setState(() {
                                                  //     doctor.name = value;
                                                  //   });
                                                  //}
                                                  ),
                                            ]),
                                );
                              }),
                            ]),
                          ))),
                  new Container(
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 50.0, right: 30.0,bottom: 50.0),
                    child: OutlinedButton(
                        child:isLoading?CircularProgressIndicator(backgroundColor: Colors.red[200],) : Text(
                          AppLocalizations.of(context).register,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: signUpPatient,
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.red[200],)
                      ),
                    ),
                  ),
                ])));
  }
}

void showSnakBar(scaffoldKey, msg) {
  print(msg);
  var snackBar = SnackBar(    
    duration: const Duration(seconds: 10),
    content: Text(msg),
    backgroundColor: Colors.red,
  );

  scaffoldKey.currentState..showSnackBar(snackBar);
}
