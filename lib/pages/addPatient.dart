import 'dart:io';
//import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/patientDataModel.dart';
import 'package:utsarjan/pages/doctorRegistration.dart';
import 'package:utsarjan/services/patientSevices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPatient extends StatefulWidget {
  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  //AddPatient addPatient = new AddPatient();
  PatientData patientData;
  //String _imagePath = '';
  Color _pickImgBtnColor = Colors.red[200];

  List<Widget> list = new List();
  File imageFile;
  bool isloading = false;
  String dosagedropdown;
  String sosdropdown;
  String urinedropdown;
   final _scaffoldKey = GlobalKey<ScaffoldState>();

  double _steroidStrength = 0;
  TextEditingController _steroidAdviseDoseController = TextEditingController();

  bool loading = false;

  //Steroid
  List<DropdownMenuItem<ListItem>> _steroidFormulationItems;
  ListItem _steroidSelectedItem;
  List<ListItem> _steroidDropDownItem = [
    ListItem(1, "Formulation"),
    ListItem(2, "Syrup"),
    ListItem(3, "Tablet"),
  ];

  List<DropdownMenuItem<ListItem>> _steroidSyrupBrandNameItems;
  ListItem _steroidSyrupSelectedBrandNameItem;
  List<ListItem> _steroidSyrupBrandNameDropDownItems = [
    ListItem(1, "Name"),
    ListItem(2, "Kidpred"),
    ListItem(3, "Omnacortil"),
    ListItem(4, "Prednisolone"),
    ListItem(5, "Omnacortil Forte"),
  ];

  List<DropdownMenuItem<ListItem>> _steroidTabletBrandNameItems;
  ListItem _steroidTabletSelectedBrandNameItem;
  List<ListItem> _steroidTabletBrandNameDropDownItems = [
    ListItem(1, "Name"),
    ListItem(2, "Wysolone"),
    ListItem(3, "Omnacortil"),
    ListItem(4, "Prednisolone"),
  ];

  /*List<DropdownMenuItem<ListItem>> _steroidActualMedicineItems;
  ListItem _steroidActualMedicineSelectedItem;
  List<ListItem> _steroidActualMedicineDropDownItem = [
    ListItem(1, "Actual medicine"),
    ListItem(2, "Prednisolone"),
  ];*/

  List<DropdownMenuItem<ListItem>> _steroidSyrupStrengthItems;
  ListItem _steroidSyrupSelectedStrengthItem;
  List<ListItem> _steroidSyrupStrengthDropDownItems = [
    ListItem(1, "Strength"),
    ListItem(2, "5 mg per 5 ml"),
    ListItem(3, "15 mg per 5 ml"),
  ];

  List<DropdownMenuItem<ListItem>> _steroidTabletStrengthItems;
  ListItem _steroidTabletSelectedStrengthItem;
  List<ListItem> _steroidTabletStrengthDropDownItems = [
    ListItem(1, "Strength"),
    ListItem(2, "5 mg"),
    ListItem(3, "10 mg"),
    ListItem(4, "20 mg"),
    ListItem(5, "30 mg"),
    ListItem(6, "40 mg"),
  ];

  String _steroidAdvisedDose = "";

  List<DropdownMenuItem<ListItem>> _steroidTimesDayItems;
  ListItem _steroidTimesDaySelectedItem;
  List<ListItem> _steroidTimesDayDropDownItem = [
    ListItem(1, "Times a day"),
    ListItem(2, "Once a day"),
    ListItem(3, "Twice a day"),
    ListItem(4, "Thrice a day"),
    ListItem(5, "On alternate days"),
  ];

  String _steroidEffectiveDailyDose = "";
  String steroidBrandName = "Name";
  String steroidStrength = "Strength";

  @override
  void initState() {
    super.initState();

    _steroidFormulationItems = buildDropDownMenuItems(_steroidDropDownItem);
    _steroidSelectedItem = _steroidFormulationItems[0].value;

    _steroidSyrupBrandNameItems =
        buildDropDownMenuItems(_steroidSyrupBrandNameDropDownItems);
    _steroidSyrupSelectedBrandNameItem = _steroidSyrupBrandNameItems[0].value;

    _steroidTabletBrandNameItems =
        buildDropDownMenuItems(_steroidTabletBrandNameDropDownItems);
    _steroidTabletSelectedBrandNameItem = _steroidTabletBrandNameItems[0].value;

    /*_steroidActualMedicineItems =
        buildDropDownMenuItems(_steroidActualMedicineDropDownItem);
    _steroidActualMedicineSelectedItem = _steroidActualMedicineItems[1].value;*/

    _steroidSyrupStrengthItems =
        buildDropDownMenuItems(_steroidSyrupStrengthDropDownItems);
    _steroidSyrupSelectedStrengthItem = _steroidSyrupStrengthItems[0].value;

    _steroidTabletStrengthItems =
        buildDropDownMenuItems(_steroidTabletStrengthDropDownItems);
    _steroidTabletSelectedStrengthItem = _steroidTabletStrengthItems[0].value;

    _steroidTimesDayItems =
        buildDropDownMenuItems(_steroidTimesDayDropDownItem);
    _steroidTimesDaySelectedItem = _steroidTimesDayItems[0].value;

    SharedPreferences.getInstance().then((instance) {
      setState(() {
        patientData = new PatientData(
          patientId: instance.getString('username'),
          patientName: instance.getString('name'),
          date: DateTime.now(),
          day: DateFormat('yyyy-MM-dd').format(DateTime.now()),          
          urineProtein: 0,
          medicineDosage: 0,
          infectionStatus: false,
          comments: "",
          formulation: _steroidSelectedItem.name,
          brandName: steroidBrandName,
          //actualMedicine: _steroidActualMedicineSelectedItem.name,
          strength: steroidStrength,
          advisedDose: _steroidAdvisedDose,
          numberOfTime: _steroidTimesDaySelectedItem.name,
          dailyDose: _steroidEffectiveDailyDose,
        );
      });     
    });

  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void _countSteroidStrength() {
    String strength = "";
    if (_steroidSelectedItem.value == 2) {
      strength = _steroidSyrupSelectedStrengthItem.name;
    } else if (_steroidSelectedItem.value == 3) {
      strength = _steroidTabletSelectedStrengthItem.name;
    }
    setState(() {
      if (strength == "15 mg per 5 ml") {
        _steroidStrength = 3;
      } else if (strength == "250 mg per 5 ml") {
        _steroidStrength = 50;
      } else if (strength == "200 mg per ml") {
        _steroidStrength = 200;
      } else if(strength == "5 mg per 5 ml" || strength=="Strength") {
        _steroidStrength = 1;
      }else{
        List<String> temp = strength.split(" ");
        _steroidStrength = double.parse(temp[0]);
      }
    });
  }

  void _countSteroidEffectiveDose() {
    double temp = 0;
    if (_steroidAdvisedDose == "") {
      _steroidAdvisedDose = "0";
    }
    if (_steroidTimesDaySelectedItem.name == "Once a day") {
      temp = _steroidStrength * double.parse(_steroidAdvisedDose) * 1;
    } else if (_steroidTimesDaySelectedItem.name == "Twice a day") {
      temp = _steroidStrength * double.parse(_steroidAdvisedDose) * 2;
    } else if (_steroidTimesDaySelectedItem.name == "Thrice a day") {
      temp = _steroidStrength * double.parse(_steroidAdvisedDose) * 3;
    } else if (_steroidTimesDaySelectedItem.name == "On alternate days") {
      temp = _steroidStrength * double.parse(_steroidAdvisedDose) / 2;
    } else {
      temp = _steroidStrength * double.parse(_steroidAdvisedDose) * 1;
    }
    setState(() {
      _steroidEffectiveDailyDose = temp.toString();
      //patientData.dailyDose = _steroidEffectiveDailyDose;
    });

    //patientData.medicineDosage = temp.toInt();
    //patientData.medicineDosage = 0;
    print(patientData.medicineDosage);

  }

  // void _decrementUrine() {
  //   setState(() {
  //     // int pts= (patientData!=null)?patientData.urine!=:0'
  //     if (patientData.urine > 0) patientData.urine -= 1;
  //   });
  // }

  // void _incrementUrine() {
  //   setState(() {
  //     if (patientData.urine < 3) patientData.urine += 1;
  //   });
  // }
 void addPatientData() {

   if(patientData.urineProtein==''||patientData.urineProtein==null){
     showSnakBar(_scaffoldKey, AppLocalizations.of(context).selectUrineProteinValue);
   }
  //  else if(patientData.medicineDosage==null|| patientData.medicineDosage == ''){
  //     showSnakBar(_scaffoldKey, "Enter Medicine Dosage");
  //  }
   else{

     setState(() {
       loading = true;
     });

             print(patientDataToJson(patientData));

             /*int multipleValue=1 ;
             if(patientData.sos=='b.i.d (2)'){
               multipleValue=2;
             }else if(patientData.sos=='t.i.d (3)'){
               multipleValue=3;
             }else{
               multipleValue=1;
             }
         patientData.medicineDosage = patientData.medicineDosage*multipleValue;*/

      addPatientDataByPatient(patientData, imageFile).then((patient) {
                     // print("success patient data resp "+patient.toString());

        setState(() {
          loading = false;
        });

         Navigator.of(context).pushNamedAndRemoveUntil('/patient', (Route<dynamic> route) => false);
       });
   }
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

  Future _pickImage() async {
    String imagePath;
    try {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedMimeTypes: ['image/jpeg', 'image/png'],
      );
      imagePath = await FlutterDocumentPicker.openDocument(params: params);
      if (imagePath != null) imageFile = File(imagePath);
    } catch (e) {
      imagePath = 'Error: $e';
    } finally {
      setState(() {
        if (imageFile != null) _pickImgBtnColor = Colors.green;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).urineProtein),
          backgroundColor: Colors.red[200],         
        ),
         key: _scaffoldKey,
        body:
            //  (patientData!=null)
            //     ? CircularProgressIndicator()
            //     :
            ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
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
                                top: 20, left: 20, right: 20, bottom: 10),
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: <Widget>[
                                  Text(AppLocalizations.of(context).date+": "),
                                  (patientData != null)
                                      ? Text(patientData.date
                                          .toString()
                                          .split(" ")[0])
                                      : Text("")
                                ]),
                              ),
                            ]),
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
                                //: new Border.all(color: Colors.lightBlueAccent, width: 3),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 40.0,
                                      color: Colors.transparent)
                                ]),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 20, right: 20, bottom: 8),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Image.asset('images/urine.png',
                                            width: 40.0, height: 40.0),
                                        Text(AppLocalizations.of(context).urineProtein),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child:
                                              new DropdownButtonHideUnderline(
                                                  child: new DropdownButton<
                                                      String>(
                                            isExpanded: false,
                                            // hint: Text("Urine"),
                                            value: urinedropdown,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                if (newValue == "Negative"||newValue == "Negative ")
                                                  patientData.urineProtein = 0;
                                                else if (newValue == "Trace")
                                                  patientData.urineProtein = 0;
                                                else if (newValue == "30+")
                                                  patientData.urineProtein = 1;
                                                else if (newValue == "100++")
                                                  patientData.urineProtein = 2;
                                                else if (newValue == "300+++")
                                                  patientData.urineProtein = 3; 
                                                else if (newValue == "2000++++")
                                                  patientData.urineProtein = 4;                                                
                                                urinedropdown = newValue;
                                              });
                                            },
                                            items: <String>[
                                              'Negative',
                                             'Trace',
                                              '30+',
                                              '100++',
                                              '300+++',
                                              '2000++++'
                                            ].map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                          )),
                                        ),                                     
                                      ],
                                    ),
                                  ],
                                ))))),
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
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Image.asset('images/medicine.png',
                                          width: 50.0, height: 50.0),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context).medicineDosage),
                                      ),
                                    ]),
                                SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context).writeSteroidDosageMedicationPage,
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 10),
                                Visibility(
                                  visible: false,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                    new Container(
                                      width: 60,
                                  margin: EdgeInsets.only(right:20 ),
                                      child:TextField(
                              cursorColor: Colors.red[200],
                              decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red[200])),
                                     isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                                    hintText: AppLocalizations.of(context).dsage),
                              style: TextStyle(fontSize: 14),
                             // keyboardType: TextInputType.number,
                            //  maxLength: 3,
                              onChanged: (value) {
                                  //patientData.medicineDosage = int.parse(value);
                              },
                            ), ),
                               Container(
                                   width: 144,
                                   child:   new DropdownButtonHideUnderline(
                                          child: new DropdownButton<String>(
                                        isExpanded: false,
                                        hint: Text(AppLocalizations.of(context).times),
                                        value: sosdropdown,
                                        isDense: true,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            patientData.sos = newValue;
                                            sosdropdown = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'Alternate Day (1)',
                                          'o.d (1)',
                                          'b.i.d (2)',
                                          't.i.d (3)',
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                      )),
                               )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                    child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).formulation+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: DropdownButton<ListItem>(
                                            value: _steroidSelectedItem,
                                            items: _steroidFormulationItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidSelectedItem);
                                                setState(() {
                                                  print(value.value);
                                                  _steroidSelectedItem = value;
                                                  patientData.formulation = _steroidSelectedItem.name;
                                                });
                                              });
                                            }),
                                      ),
                                    ]),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).name+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: _steroidSelectedItem.value == 2
                                            ? DropdownButton<ListItem>(
                                            value: _steroidSyrupSelectedBrandNameItem,
                                            items: _steroidSyrupBrandNameItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidSyrupSelectedBrandNameItem);
                                                _steroidSyrupSelectedBrandNameItem = value;
                                                patientData.brandName = _steroidSyrupSelectedBrandNameItem.name;
                                              });
                                            })
                                            : DropdownButton<ListItem>(
                                            value: _steroidTabletSelectedBrandNameItem,
                                            items: _steroidTabletBrandNameItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidTabletSelectedBrandNameItem);
                                                _steroidTabletSelectedBrandNameItem = value;
                                                patientData.brandName = _steroidTabletSelectedBrandNameItem.name;
                                              });
                                            }),
                                      )
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).actualMedicine+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Prednisolone",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).strength + ":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: _steroidSelectedItem.value == 2
                                            ? DropdownButton<ListItem>(
                                            value: _steroidSyrupSelectedStrengthItem,
                                            items: _steroidSyrupStrengthItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidSyrupSelectedStrengthItem);
                                                _steroidSyrupSelectedStrengthItem = value;
                                                _countSteroidStrength();
                                                _countSteroidEffectiveDose();
                                                patientData.strength = _steroidSyrupSelectedStrengthItem.name;
                                              });
                                            })
                                            : DropdownButton<ListItem>(
                                            value: _steroidTabletSelectedStrengthItem,
                                            items: _steroidTabletStrengthItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidTabletSelectedStrengthItem);
                                                _steroidTabletSelectedStrengthItem = value;
                                                _countSteroidStrength();
                                                _countSteroidEffectiveDose();
                                                patientData.strength = _steroidTabletSelectedStrengthItem.name;
                                              });
                                            }),
                                      )
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).advisedDose+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 50,
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
                                          style: TextStyle(fontSize: 16),
                                          keyboardType: TextInputType.number,
                                          //  maxLength: 3,
                                          controller: _steroidAdviseDoseController,
                                          onChanged: (value) {
                                            _steroidAdviseDoseController.text = value;
                                            _steroidAdviseDoseController.selection = TextSelection.fromPosition(TextPosition(offset: _steroidAdviseDoseController.text.length));
                                            setState(() {
                                              _steroidAdvisedDose = value;
                                              _countSteroidStrength();
                                              _countSteroidEffectiveDose();
                                              patientData.advisedDose = _steroidAdvisedDose;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          _steroidSelectedItem.value == 2
                                              ? "ml"
                                              : "tablets",
                                          style: TextStyle(fontSize: 16)),
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).noOfTimesADay+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: DropdownButton<ListItem>(
                                            value: _steroidTimesDaySelectedItem,
                                            items: _steroidTimesDayItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(_steroidTimesDaySelectedItem);
                                                setState(() {
                                                  print(value.value);
                                                  _steroidTimesDaySelectedItem = value;
                                                  _countSteroidStrength();
                                                  _countSteroidEffectiveDose();
                                                  patientData.numberOfTime = _steroidTimesDaySelectedItem.name;
                                                });
                                              });
                                            }),
                                      ),
                                    ]),
                                    SizedBox(height: 10),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).effectiveDailyDose+":",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 60,
                                        child: TextField(
                                          cursorColor: Colors.red[200],
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: _steroidEffectiveDailyDose),
                                          decoration: InputDecoration(
                                              focusedBorder: new UnderlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: Colors.red[200])),
                                              isDense: true,
                                              contentPadding:
                                              EdgeInsets.symmetric(vertical: 7),
                                              hintText: ""),
                                          style: TextStyle(fontSize: 16),
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text("mg", style: TextStyle(fontSize: 16)),
                                    ]),
                                    SizedBox(height: 10),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        )))
              ],
            ),
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
                            top: 15, left: 20, right: 20, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).extraCommentsComplications,
                                style: TextStyle(color: Colors.red[200]),
                              ),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              cursorColor: Colors.red[200],
                              decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  hintText: AppLocalizations.of(context).anyOtherSymptoms),
                              style: TextStyle(fontSize: 17),
                              onChanged: (value) {
                                patientData.comments = value;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: false,
                              child: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  // height: 200,
                                  child: Center(
                                child: imageFile == null
                                    ? Text("")
                                    : Image.file(
                                        imageFile,
                                        // width: 200,
                                        // height: 200,
                                      ),
                              )),
                            ),
                            Visibility(
                              visible: false,
                              child: new OutlinedButton(
                                  child: Text(AppLocalizations.of(context).uploadPhoto,
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                  onPressed: () {
                                  //  _pickImage();
                                    _showDialog(context);
                                    setState(() {
                                      // uploadImage(File(_imagePath))
                                      //     .then((value) {});
                                    });
                                  },style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: _pickImgBtnColor)
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),

            //new Container(
            //width: 250,
            // padding: const EdgeInsets.only(
            //     left: 50.0, top: 50.0, right: 50.0),
            //child:
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: new OutlinedButton(
                  child: !loading
                      ?Text(
                    AppLocalizations.of(context).send,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ):Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator())),
                  onPressed: addPatientData,
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red[200],)
                ),
              ),
            ),
          ],
        ));
  }
    void showSnakBar(scaffoldKey, msg) {
    print(msg);
    final snackBar =new SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(msg),
      backgroundColor: Colors.red,      
    );

    scaffoldKey.currentState..showSnackBar(snackBar);
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

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}