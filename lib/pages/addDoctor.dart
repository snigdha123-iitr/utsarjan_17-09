import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utsarjan/model/doctorDataModel.dart';
import 'package:utsarjan/model/patientModel.dart';
//import 'package:utsarjan/model/listOfPatientsModel.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDoctor extends StatefulWidget {
  final Patient currentPatient;

  AddDoctor({this.currentPatient});
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  Patient currentPatient;
  //var date= DateTime.now();
  DoctorData doctorData;
  
  double bmi = 0;
  String categorydropdown;
  String stagedropdown;
  String categoryError;
  String stageError;
  List<String> stages, ssnsList, ssnsIrList, ssnsLrList;
  int age;
  Patient patient;
  bool loading = false;

  double calculateBMI(double height, double weight) {
    setState(() {
      doctorData.bmi =
          doctorData.bodyWeight / pow(doctorData.bodyHeight / 100, 2);
    });
    return doctorData.bmi;
  }

  @override
  void initState() {
    currentPatient = widget.currentPatient;
    setState(() {
      doctorData = new DoctorData(
        patientName: currentPatient.name,
        patientId: currentPatient.username,
        gender: currentPatient.gender,
        age: currentPatient.age,
        date: DateTime.now(),
        day: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        systolicBP: 0,
        diastolicBP: 0,
        bodyWeight: 0,
        bodyHeight: 0,
        comments: "",
        category: "",
        stage: "",
        // age: 0,
      );
    });
    stages = ["Stage"];
    ssnsList = ["Stage", "0", "1", "2", "3"];
    ssnsIrList = ["Stage", "4", "5", "6", "7", "8", "9", "10"];
    ssnsLrList = ["Stage", "4", "5", "6", "7", "8", "9", "10"];

    super.initState();
  }

  Future takePhoto(context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future takeLibrary(context) async {
    File picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  File imageFile;
  // String _imagePath = '';
  Color _pickImgBtnColor = Colors.red[200];

  Future _pickImage() async {
    String imagePath;
    try {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedMimeTypes: ['image/jpeg', 'image/png'],
      );
      imagePath = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      imagePath = 'Error: $e';
    } finally {
      setState(() {
        if (imagePath != null) {
          imageFile = File(imagePath);
          _pickImgBtnColor = Colors.green;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text(AppLocalizations.of(context).addData),
            //automaticallyImplyLeading: false,
            backgroundColor: Colors.red[200]),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: new BoxDecoration(
                          //: new Border.all(color: Colors.lightBlueAccent, width: 3),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40.0, color: Colors.transparent)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Image.asset('images/bloodpressure.png',
                                width: 50.0, height: 50.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: Text("Blood Presure",
                              //     style: TextStyle(
                              //       fontSize: 15,
                              //     )),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(AppLocalizations.of(context).systolic+"        "),
                                        Expanded(
                                            child: TextField(
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.red,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.red[200])),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              doctorData.systolicBP =
                                                  int.parse(value);
                                            });
                                          },

                                          // keyboardType: TextInputType.number,
                                          // inputFormatters: [
                                          //   WhitelistingTextInputFormatter
                                          //       .digitsOnly,
                                          // ],
                                        )),
                                        Text('('+AppLocalizations.of(context).mmOfHg+')')
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(AppLocalizations.of(context).diastolic+"      "),
                                        Expanded(
                                            child: TextField(
                                          keyboardType: TextInputType.number,

                                          cursorColor: Colors.red,

                                          decoration: InputDecoration(
                                            focusedBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.red[200])),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              doctorData.diastolicBP =
                                                  int.parse(value);
                                            });
                                          },
                                          // keyboardType: TextInputType.number,
                                          // inputFormatters: [
                                          //   WhitelistingTextInputFormatter
                                          //       .digitsOnly,
                                          // ],
                                        )),
                                         Text('('+AppLocalizations.of(context).mmOfHg+')')
                                      ],
                                    ),

                                  ]),
                              // Expanded(
                              //   child: Column(
                              //     children: <Widget>[
                              //       TextField(),
                              //     ],
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40.0, color: Colors.transparent)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            new Image.asset('images/weight.png',
                                width: 50.0, height: 50.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context).bodyWeight+"                  "),
                            ),
                            Expanded(
                                child: TextField(
                              keyboardType: TextInputType.number,

                              cursorColor: Colors.red,

                              decoration: InputDecoration(
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[200])),
                                hintText: AppLocalizations.of(context).kg,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  //   print("kjvcxjhgfdghkl;bn");
                                  //   print(value);
                                  //   print(double.parse(value));
                                  doctorData.bodyWeight = double.parse(value);
                                  // print(doctorData.bodyWeight);
                                  // print("555556665");
                                });
                              },
                              // keyboardType: TextInputType.number,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter.digitsOnly,
                              // ],
                            )),
                          ],
                        ),
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40.0, color: Colors.transparent)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context).bodyHeight+"                             "),
                            Expanded(
                                child: TextField(
                              keyboardType: TextInputType.number,

                              cursorColor: Colors.red,

                              decoration: InputDecoration(
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[200])),
                                hintText: AppLocalizations.of(context).cm,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  doctorData.bodyHeight = double.parse(value);
                                  print("bodyheight : " +
                                      doctorData.bodyHeight.toString());
                                });
                              },
                              // keyboardType: TextInputType.number,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter.digitsOnly,
                              // ],
                            )),
                          ],
                        ),
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40.0, color: Colors.transparent)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context).bmi+"   "),
                            (doctorData != null &&
                                    doctorData.bodyHeight != null &&
                                    doctorData.bodyWeight != null &&
                                    doctorData.bodyHeight > 0 &&
                                    doctorData.bodyWeight > 0)
                                ? Text(calculateBMI(doctorData.bodyHeight,
                                        doctorData.bodyWeight)
                                    .toString())
                                : Text("")
                          ],
                        ),
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 40.0, color: Colors.transparent)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).patient+"    ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                    isExpanded: false,
                                    hint: Text(AppLocalizations.of(context).category),
                                    value: categorydropdown,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        doctorData.category = newValue;
                                        categorydropdown = newValue;
                                        stagedropdown = "Stage";
                                        if (newValue == "SSNS")
                                          stages = ssnsList;
                                        else if (newValue == "SRNS-IR")
                                          stages = ssnsIrList;
                                        else if (newValue == "SRNS-LR")
                                          stages = ssnsLrList;
                                        else if (newValue == "Category")
                                          stages = ["Stage"];
                                      });
                                    },
                                    items: <String>[
                                      'SSNS',
                                      'SRNS-IR',
                                      'SRNS-LR'
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                  )),
                                ),
                                Visibility(
                                  visible: false,
                                  child: new DropdownButtonHideUnderline(
                                      child: new DropdownButton<String>(
                                    isExpanded: false,
                                    hint: Text("stage"),
                                    value: stagedropdown,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        stageError =
                                            stageError != null ? null : 'error';
                                        stageError = null;
                                        //doctorData.stage = newValue;
                                        doctorData.stage = "";
                                        stagedropdown = newValue;
                                      });
                                    },
                                    items: stages.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                  )),
                                ),
                              ]),
                        )))),

            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Material(
            //         elevation: 5,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10)),
            //         child: Container(
            //           decoration: new BoxDecoration(
            //               borderRadius: BorderRadius.circular(10),
            //               boxShadow: [
            //                 BoxShadow(
            //                     blurRadius: 40.0, color: Colors.transparent)
            //               ]),
            //           child: Padding(
            //             padding: const EdgeInsets.only(
            //                 top: 20, left: 20, right: 20, bottom: 20),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: <Widget>[
            //                 Text("Medicines"),
            //                 Padding(
            //                   padding: EdgeInsets.all(8.0),
            //                 ),
            //                 Text("Syrup"),
            //                 Padding(
            //                   padding: EdgeInsets.all(8.0),
            //                 ),
            //                 Text("Tablets")
            //               ],
            //             ),
            //           ),
            //         ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 40.0, color: Colors.transparent)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).extraComments,
                                style: TextStyle(color: Colors.red[200]),
                              )
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  hintText:
                                  AppLocalizations.of(context).something),
                              style: TextStyle(fontSize: 17),
                              onChanged: (value) {
                                doctorData.comments = value;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: false,
                              child: Center(
                                child: new OutlinedButton(
                                    child: const Text('Upload Photo',
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                    onPressed: () {
                                      print(
                                          'imageimageiiiiiiiiiiiiiiimmmmmmmmmaaaaaaaaaaaaaaaageeeeeeeeee');
                                      // if(image == null){
                                      //_pickImage().then((val) {});
                                     // _pickImage();
                                      _showDialog(context);
                                      // }

                                      //  upload(File(imageFile));
                                      //doctorData.photo=imageFile;
                                    },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: _pickImgBtnColor,)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
            new Container(
              width: 270,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: new OutlinedButton(
                    child: !loading
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
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      print(doctorDataToJson(doctorData));
                      print("ssssssssssssssss");
                      addPatientDataByDoctor(doctorData, imageFile)
                          .then((doctor) {
                        print("success");
                        // print(doctorData.patientName);
                        // print(doctorData.date);
                        setState(() {
                          loading = false;
                        });
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/doctor', (Route<dynamic> route) => false);
                      });

                      //  Navigator.pop(context);
                    },style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red[200],)
                ),
                ),
              ),
            ),
          ]),
        ]));
  }

  Future<void> _showDialog(BuildContext context) {
    // flutter defined function
    //selectImage(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(title: new Text(AppLocalizations.of(context).addPhoto), children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context).takePhoto),
            onPressed: () async {
              takePhoto(context);
              // Navigator.pop(context);
              // File imageFile =
              //     await ImagePicker.pickImage(source: ImageSource.camera);
              // setState(() {
              //   file = imageFile;
              // });
            },
          ),
          SizedBox(
            height: 10,
          ),
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context).chooseFromLibrary),
            onPressed: () async {
              takeLibrary(context);
              // Navigator.of(context).pop();
              // File imageFile =
              //     await ImagePicker.pickImage(source: ImageSource.gallery);
              // setState(() {
              //   file = imageFile;
              // });
            },
          ),
          SizedBox(
            height: 10,
          ),
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context).cancelSmaller),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]);
      },
    );
  }
}
