import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/pages/patientPage.dart';
import 'package:toast/toast.dart';
import 'package:utsarjan/services/globalData.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Medicationget extends StatefulWidget {
  final String patientId;
  final String isFrom;

  const Medicationget({this.patientId, this.isFrom});

  @override
  _MedicationgetState createState() => _MedicationgetState();
}

class _MedicationgetState extends State<Medicationget> {
  double _steroidStrength = 0;
  TextEditingController _steroidAdviseDoseController = TextEditingController();

  double _otherStrength = 0;
  TextEditingController _otherAdviseDoseController = TextEditingController();
  double _otherStrength1 = 0;
  TextEditingController _otherAdviseDoseController1 = TextEditingController();
  double _otherStrength2 = 0;
  TextEditingController _otherAdviseDoseController2 = TextEditingController();

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

  String _steroidActualMedicine = "Prednisolone";

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
  String _steroidHowManyDays = "";
  String _steroidTakenYes = "0";//_steroidTakenNo = "0";
  String _steroidRemark = "";

  /*List<OtherListItem> otherMedicineArray = [];
  List<List<DropdownMenuItem<ListItem>>> otherItemArray = [];
  List<ListItem> otherSelectItemArray = [];
  List<List<ListItem>> otherDropDownItemArray = [];*/

  // Other Medicine
  List<DropdownMenuItem<ListItem>> _otherFormulationItems;
  ListItem _otherSelectedItem;
  List<ListItem> _otherDropDownItem = [
    ListItem(1, "Formulation"),
    ListItem(2, "Syrup"),
    ListItem(3, "Tablet"),
    ListItem(4, "Capsule"),
  ];

  List<DropdownMenuItem<ListItem>> _otherSyrupBrandNameItems;
  ListItem _otherSyrupSelectedBrandNameItem;
  List<ListItem> _otherSyrupBrandNameDropDownItems = [
    ListItem(1, "Name"),
    ListItem(2, "Cellcept"),
    ListItem(3, "Mycept"),
    ListItem(4, "Mofecon"),
    ListItem(5, "Panimun Bioral"),
    ListItem(6, "Zymun Bioral"),
    ListItem(7, "Arpimun "),
    ListItem(8, "Cyclograf ME"),
    ListItem(9, "Shelcal"),
    ListItem(10, "Cipcal"),
  ];

  List<DropdownMenuItem<ListItem>> _otherTabletBrandNameItems;
  ListItem _otherTabletSelectedBrandNameItem;
  List<ListItem> _otherTabletBrandNameDropDownItems = [
    ListItem(1, "Name"),
    ListItem(2, "Cellcept"),
    ListItem(3, "Cellmune"),
    ListItem(4, "Mofilet"),
    ListItem(5, "Mofecon"),
    ListItem(6, "Mycept"),
    ListItem(7, "Mycofit"),
    ListItem(8, "Mycofit-S"),
    ListItem(9, "Mofilet-S"),
    ListItem(10, "Mycept-S"),
    ListItem(11, "Other-S preparations"),
    ListItem(12, "Endoxan"),
    ListItem(13, "Cycloxan"),
    ListItem(14, "Dicaris"),
    ListItem(15, "Vermisole"),
    ListItem(16, "Vitilex"),
    ListItem(17, "Dewormis"),
    ListItem(18, "Envas"),
    ListItem(19, "Enam"),
    ListItem(20, "Dilvas"),
    ListItem(21, "Dilpril"),
    ListItem(22, "Amlong"),
    ListItem(23, "Amlopres"),
    ListItem(24, "Amlopin"),
    ListItem(25, "Shelcal"),
    ListItem(26, "Cipcal"),
    ListItem(27, "Lasix"),
  ];

  List<DropdownMenuItem<ListItem>> _otherCapsuleBrandNameItems;
  ListItem _otherCapsuleSelectedBrandNameItem;
  List<ListItem> _otherCapsuleBrandNameDropDownItems = [
    ListItem(1, "Name"),
    ListItem(2, "Cellcept"),
    ListItem(3, "Cellmune"),
    ListItem(4, "Mofilet"),
    ListItem(5, "Mofecon"),
    ListItem(6, "Mycept"),
    ListItem(7, "Mycofit"),
    ListItem(8, "Mycofit-S"),
    ListItem(9, "Mofilet-S"),
    ListItem(10, "Mycept-S"),
    ListItem(11, "Other-S preparations"),
    ListItem(12, "Panimun Bioral"),
    ListItem(13, "Zymun Bioral"),
    ListItem(14, "Arpimun"),
    ListItem(15, "Cyclograf"),
    ListItem(16, "Pangraf"),
    ListItem(17, "Rolitrans"),
    ListItem(18, "Takfa"),
    ListItem(19, "Tacrograf")
  ];

  List<DropdownMenuItem<ListItem>> _otherSyrupActualMedicineItems;
  ListItem _otherSyrupActualMedicineSelectedItem;
  List<ListItem> _otherSyrupActualMedicineDropDownItem = [
    ListItem(1, "Actual medicine"),
    ListItem(2, "Mycophenolate mofetil"),
    ListItem(3, "Cyclosporine"),
    ListItem(4, "Calcium carbonate")
  ];

  List<DropdownMenuItem<ListItem>> _otherTabletActualMedicineItems;
  ListItem _otherTabletActualMedicineSelectedItem;
  List<ListItem> _otherTabletActualMedicineDropDownItem = [
    ListItem(1, "Actual medicine"),
    ListItem(2, "Mycophenolate mofetil"),
    ListItem(3, "Cyclophosphamide"),
    ListItem(4, "Levamisole"),
    ListItem(5, "Enalapril"),
    ListItem(6, "Amlodipine"),
    ListItem(7, "Calcium carbonate"),
    ListItem(8, "Furosemide")
  ];

  List<DropdownMenuItem<ListItem>> _otherCapsuleActualMedicineItems;
  ListItem _otherCapsuleActualMedicineSelectedItem;
  List<ListItem> _otherCapsuleActualMedicineDropDownItem = [
    ListItem(1, "Actual medicine"),
    ListItem(2, "Mycophenolate mofetil"),
    ListItem(3, "Cyclosporine"),
    ListItem(4, "Tacrolimus")
  ];

  List<DropdownMenuItem<ListItem>> _otherSyrupStrengthItems;
  ListItem _otherSyrupSelectedStrengthItem;
  List<ListItem> _otherSyrupStrengthDropDownItems = [
    ListItem(1, "Strength"),
    ListItem(2, "200 mg per ml"),
    ListItem(3, "100 mg per ml"),
    ListItem(4, "250 mg per 5 ml"),
  ];

  List<DropdownMenuItem<ListItem>> _otherTabletStrengthItems;
  ListItem _otherTabletSelectedStrengthItem;
  List<ListItem> _otherTabletStrengthDropDownItems = [
    ListItem(1, "Strength"),
    ListItem(2, "500 mg"),
    ListItem(3, "250 mg"),
    ListItem(4, "360 mg (~=500 mg)"),
    ListItem(5, "180 mg (~=250 mg)"),
    ListItem(6, "50 mg"),
    ListItem(7, "100 mg"),
    ListItem(8, "150 mg"),
    ListItem(9, "2.5 mg"),
    ListItem(10, "5 mg"),
    ListItem(11, "400 mg"),
    ListItem(12, "40 mg"),
  ];

  List<DropdownMenuItem<ListItem>> _otherCapsuleStrengthItems;
  ListItem _otherCapsuleSelectedStrengthItem;
  List<ListItem> _otherCapsuleStrengthDropDownItems = [
    ListItem(1, "Strength"),
    ListItem(2, "500 mg"),
    ListItem(3, "250 mg"),
    ListItem(4, "360 mg (~=500 mg)"),
    ListItem(5, "180 mg (~=250 mg)"),
    ListItem(6, "25 mg"),
    ListItem(7, "50 mg"),
    ListItem(8, "100 mg"),
    ListItem(9, "0.25 mg"),
    ListItem(10, "0.5 mg"),
    ListItem(11, "1 mg"),
    ListItem(12, "2 mg"),
  ];

  String _otherAdvisedDose = "";

  List<DropdownMenuItem<ListItem>> _otherTimesDayItems;
  ListItem _otherTimesDaySelectedItem;
  List<ListItem> _otherTimesDayDropDownItem = [
    ListItem(1, "Times a day"),
    ListItem(2, "Once a day"),
    ListItem(3, "Twice a day"),
    ListItem(4, "On alternate days"),
  ];

  String _otherEffectiveDailyDose = "";
  String _otherHowManyDays = "";
  String _otherTakenYes = "0";//,_otherTakenNo = "0";
  String _otherRemark = "";

  // Other 1

  List<DropdownMenuItem<ListItem>> _otherFormulationItems1;
  ListItem _otherSelectedItem1;

  List<DropdownMenuItem<ListItem>> _otherSyrupBrandNameItems1;
  ListItem _otherSyrupSelectedBrandNameItem1;

  List<DropdownMenuItem<ListItem>> _otherTabletBrandNameItems1;
  ListItem _otherTabletSelectedBrandNameItem1;

  List<DropdownMenuItem<ListItem>> _otherCapsuleBrandNameItems1;
  ListItem _otherCapsuleSelectedBrandNameItem1;

  List<DropdownMenuItem<ListItem>> _otherSyrupActualMedicineItems1;
  ListItem _otherSyrupActualMedicineSelectedItem1;

  List<DropdownMenuItem<ListItem>> _otherTabletActualMedicineItems1;
  ListItem _otherTabletActualMedicineSelectedItem1;

  List<DropdownMenuItem<ListItem>> _otherCapsuleActualMedicineItems1;
  ListItem _otherCapsuleActualMedicineSelectedItem1;

  List<DropdownMenuItem<ListItem>> _otherSyrupStrengthItems1;
  ListItem _otherSyrupSelectedStrengthItem1;

  List<DropdownMenuItem<ListItem>> _otherTabletStrengthItems1;
  ListItem _otherTabletSelectedStrengthItem1;

  List<DropdownMenuItem<ListItem>> _otherCapsuleStrengthItems1;
  ListItem _otherCapsuleSelectedStrengthItem1;

  String _otherAdvisedDose1 = "";

  List<DropdownMenuItem<ListItem>> _otherTimesDayItems1;
  ListItem _otherTimesDaySelectedItem1;

  String _otherEffectiveDailyDose1 = "";
  String _otherHowManyDays1 = "";
  String _otherTakenYes1 = "0";//,_otherTakenNo1 = "0";
  String _otherRemark1 = "";

  // Other 2

  List<DropdownMenuItem<ListItem>> _otherFormulationItems2;
  ListItem _otherSelectedItem2;

  List<DropdownMenuItem<ListItem>> _otherSyrupBrandNameItems2;
  ListItem _otherSyrupSelectedBrandNameItem2;

  List<DropdownMenuItem<ListItem>> _otherTabletBrandNameItems2;
  ListItem _otherTabletSelectedBrandNameItem2;

  List<DropdownMenuItem<ListItem>> _otherCapsuleBrandNameItems2;
  ListItem _otherCapsuleSelectedBrandNameItem2;

  List<DropdownMenuItem<ListItem>> _otherSyrupActualMedicineItems2;
  ListItem _otherSyrupActualMedicineSelectedItem2;

  List<DropdownMenuItem<ListItem>> _otherTabletActualMedicineItems2;
  ListItem _otherTabletActualMedicineSelectedItem2;

  List<DropdownMenuItem<ListItem>> _otherCapsuleActualMedicineItems2;
  ListItem _otherCapsuleActualMedicineSelectedItem2;

  List<DropdownMenuItem<ListItem>> _otherSyrupStrengthItems2;
  ListItem _otherSyrupSelectedStrengthItem2;

  List<DropdownMenuItem<ListItem>> _otherTabletStrengthItems2;
  ListItem _otherTabletSelectedStrengthItem2;

  List<DropdownMenuItem<ListItem>> _otherCapsuleStrengthItems2;
  ListItem _otherCapsuleSelectedStrengthItem2;

  String _otherAdvisedDose2 = "";

  List<DropdownMenuItem<ListItem>> _otherTimesDayItems2;
  ListItem _otherTimesDaySelectedItem2;

  String _otherEffectiveDailyDose2 = "";
  String _otherHowManyDays2 = "";
  String _otherTakenYes2 = "0";//,_otherTakenNo2="0";
  String _otherRemark2 = "";

  bool isOtherOne = false;
  bool isOtherTwo = false;

  var output = {};

  Future getCountrie() async {
    var response = await http.get(
        '$serverIP/users/doctor/getMedicationByPatient?patient=' + (widget.patientId));
    final post = json.decode(response.body);
    return post;
  }

  var countries = {};

  String patientId;
  String username;

  void initState() {
    super.initState();

    patientId = widget.patientId;
    print("PatientId  -- " + patientId);

    SharedPreferences.getInstance().then((instance) {
      setState(() {
        username = instance.getString('username');
      });
    });

    getCountrie().then((post) {
      setState(() {
        countries = post;
        print(countries);

        if (countries['data'] != null && countries['data'].length > 0) {
          if (countries['data'][0] != null) {
            int steroidType = 0;

            for (int i = 0; i < _steroidFormulationItems.length; i++) {
              if (_steroidFormulationItems[i].value.name ==
                  countries['data'][0]['formulation']) {
                _steroidSelectedItem = _steroidFormulationItems[i].value;
                steroidType = _steroidFormulationItems[i].value.value;
                break;
              }
            }

            /*for (int i = 0; i < _steroidActualMedicineItems.length; i++) {
              if (_steroidActualMedicineItems[i].value.name ==
                  countries['data'][0]['actualMedicine']) {
                _steroidActualMedicineSelectedItem =
                    _steroidActualMedicineItems[i].value;
                break;
              }
            }*/

            for (int i = 0; i < _steroidTimesDayItems.length; i++) {
              if (_steroidTimesDayItems[i].value.name ==
                  countries['data'][0]['numberOfTimes']) {
                _steroidTimesDaySelectedItem = _steroidTimesDayItems[i].value;
                break;
              }
            }

            if(isEmpty(countries['data'][0]['advisedDose'].toString())) {
              _steroidAdvisedDose = "0";
            }else{
              _steroidAdvisedDose = countries['data'][0]['advisedDose'].toString();
            }
            _steroidAdviseDoseController.text = _steroidAdvisedDose;
            _steroidAdviseDoseController.selection = TextSelection.fromPosition(
                TextPosition(offset: _steroidAdviseDoseController.text.length));

            if(isEmpty(countries['data'][0]['effectiveDailyDose'].toString())) {
              _steroidEffectiveDailyDose = "0";
            }else{
              _steroidEffectiveDailyDose = countries['data'][0]['effectiveDailyDose'].toString();
            }
            _steroidHowManyDays =
            countries['data'][0]['howManyDays'] == null ? "" : countries['data'][0]['howManyDays'].toString();

            _steroidRemark = countries['data'][0]['remarks'];

            if(countries['data'][0]['taken'].toString().contains("*")) {
              _steroidTakenYes = countries['data'][0]['taken'].toString().split("*")[0];
              //_steroidTakenNo = countries['data'][0]['taken'].toString().split("*")[1];
            }else{
              _steroidTakenYes = countries['data'][0]['taken'];
              //_steroidTakenNo = "0";
            }

            if (steroidType == 2) {
              for (int i = 0; i < _steroidSyrupBrandNameItems.length; i++) {
                if (_steroidSyrupBrandNameItems[i].value.name ==
                    countries['data'][0]['brandName']) {
                  _steroidSyrupSelectedBrandNameItem =
                      _steroidSyrupBrandNameItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _steroidSyrupStrengthItems.length; i++) {
                if (_steroidSyrupStrengthItems[i].value.name ==
                    countries['data'][0]['strength']) {
                  _steroidSyrupSelectedStrengthItem =
                      _steroidSyrupStrengthItems[i].value;
                  break;
                }
              }
            } else {
              for (int i = 0; i < _steroidTabletBrandNameItems.length; i++) {
                if (_steroidTabletBrandNameItems[i].value.name ==
                    countries['data'][0]['brandName']) {
                  _steroidTabletSelectedBrandNameItem =
                      _steroidTabletBrandNameItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _steroidTabletStrengthItems.length; i++) {
                if (_steroidTabletStrengthItems[i].value.name ==
                    countries['data'][0]['strength']) {
                  _steroidTabletSelectedStrengthItem =
                      _steroidTabletStrengthItems[i].value;
                  break;
                }
              }
            }

            int otherType = 0;

            for (int i = 0; i < _otherFormulationItems.length; i++) {
              if (_otherFormulationItems[i].value.name ==
                  countries['data'][0]['formulationOther'].toString().split("*")[0]) {
                _otherSelectedItem = _otherFormulationItems[i].value;
                otherType = _otherFormulationItems[i].value.value;
                break;
              }
            }

            for (int i = 0; i < _otherTimesDayItems.length; i++) {
              if (_otherTimesDayItems[i].value.name ==
                  countries['data'][0]['numberOfTimesOther'].toString().split("*")[0]) {
                _otherTimesDaySelectedItem = _otherTimesDayItems[i].value;
                break;
              }
            }

            _otherAdvisedDose =
                countries['data'][0]['advisedDoseOther'].toString().split("*")[0];
            _otherAdviseDoseController.text = _otherAdvisedDose;
            _otherAdviseDoseController.selection = TextSelection.fromPosition(
                TextPosition(offset: _otherAdviseDoseController.text.length));
            _otherEffectiveDailyDose =
                countries['data'][0]['effectiveDailyDoseOther'].toString().split("*")[0];
            _otherHowManyDays =
                countries['data'][0]['howManyDaysOther'].toString().split("*")[0];
            _otherRemark = countries['data'][0]['remarksOther'].toString().split("*")[0];

            //_otherTakenOrNot = countries['data'][0]['takenOther'].toString().split("*")[0];

            if(countries['data'][0]['takenOther'].toString().contains("*")) {
              _otherTakenYes = countries['data'][0]['takenOther'].toString().split("*")[0];
              //_otherTakenNo = countries['data'][0]['takenOther'].toString().split("*")[1];
            }else{
              _otherTakenYes = countries['data'][0]['takenOther'];
              //_otherTakenNo = "0";
            }

            if (otherType == 2) {
              for (int i = 0; i < _otherSyrupBrandNameItems.length; i++) {
                if (_otherSyrupBrandNameItems[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[0]) {
                  _otherSyrupSelectedBrandNameItem =
                      _otherSyrupBrandNameItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupActualMedicineItems.length; i++) {
                if (_otherSyrupActualMedicineItems[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[0]) {
                  _otherSyrupActualMedicineSelectedItem =
                      _otherSyrupActualMedicineItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupStrengthItems.length; i++) {
                if (_otherSyrupStrengthItems[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[0]) {
                  _otherSyrupSelectedStrengthItem =
                      _otherSyrupStrengthItems[i].value;
                  break;
                }
              }
            } else if (otherType == 3) {
              for (int i = 0; i < _otherTabletBrandNameItems.length; i++) {
                if (_otherTabletBrandNameItems[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[0]) {
                  _otherTabletSelectedBrandNameItem =
                      _otherTabletBrandNameItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletActualMedicineItems.length; i++) {
                if (_otherTabletActualMedicineItems[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[0]) {
                  _otherTabletActualMedicineSelectedItem =
                      _otherTabletActualMedicineItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletStrengthItems.length; i++) {
                if (_otherTabletStrengthItems[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[0]) {
                  _otherTabletSelectedStrengthItem =
                      _otherTabletStrengthItems[i].value;
                  break;
                }
              }
            } else if (otherType == 4) {
              for (int i = 0; i < _otherCapsuleBrandNameItems.length; i++) {
                if (_otherCapsuleBrandNameItems[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[0]) {
                  _otherCapsuleSelectedBrandNameItem =
                      _otherCapsuleBrandNameItems[i].value;
                  break;
                }
              }
              for (int i = 0;
                  i < _otherCapsuleActualMedicineItems.length;
                  i++) {
                if (_otherCapsuleActualMedicineItems[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[0]) {
                  _otherCapsuleActualMedicineSelectedItem =
                      _otherCapsuleActualMedicineItems[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherCapsuleStrengthItems.length; i++) {
                if (_otherCapsuleStrengthItems[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[0]) {
                  _otherCapsuleSelectedStrengthItem =
                      _otherCapsuleStrengthItems[i].value;
                  break;
                }
              }
            }

            //Other 1

            int otherType1 = 0;

            for (int i = 0; i < _otherFormulationItems1.length; i++) {
              if (_otherFormulationItems1[i].value.name ==
                  countries['data'][0]['formulationOther'].toString().split("*")[1]) {
                _otherSelectedItem1 = _otherFormulationItems1[i].value;
                otherType1 = _otherFormulationItems1[i].value.value;
                break;
              }
            }

            for (int i = 0; i < _otherTimesDayItems1.length; i++) {
              if (_otherTimesDayItems1[i].value.name ==
                  countries['data'][0]['numberOfTimesOther'].toString().split("*")[1]) {
                _otherTimesDaySelectedItem1 = _otherTimesDayItems1[i].value;
                break;
              }
            }

            _otherAdvisedDose1 = countries['data'][0]['advisedDoseOther'].toString().split("*")[1];
            _otherAdviseDoseController1.text = _otherAdvisedDose1;
            _otherAdviseDoseController1.selection = TextSelection.fromPosition(TextPosition(offset: _otherAdviseDoseController1.text.length));
            if(_otherAdvisedDose1!=""){
              isOtherOne = true;
            }
            print("AA_S -- _otherAdvisedDose1" + _otherAdvisedDose1);
            _otherEffectiveDailyDose1 = countries['data'][0]['effectiveDailyDoseOther'].toString().split("*")[1];
            _otherHowManyDays1 = countries['data'][0]['howManyDaysOther'].toString().split("*")[1];
            _otherRemark1 = countries['data'][0]['remarksOther'].toString().split("*")[1];

            //_otherTakenOrNot1 = countries['data'][0]['takenOther'].toString().split("*")[1];

            if(countries['data'][0]['takenOther'].toString().contains("*")) {
              _otherTakenYes1 = countries['data'][0]['takenOther'].toString().split("*")[1];
              //_otherTakenNo1 = countries['data'][0]['takenOther'].toString().split("*")[3];
            }else{
              _otherTakenYes1 = countries['data'][0]['takenOther'];
              //_otherTakenNo1 = "0";
            }

            if (otherType1 == 2) {
              for (int i = 0; i < _otherSyrupBrandNameItems1.length; i++) {
                if (_otherSyrupBrandNameItems1[i].value.name == countries['data'][0]['brandNameOther'].toString().split("*")[1]) {
                  _otherSyrupSelectedBrandNameItem1 = _otherSyrupBrandNameItems1[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupActualMedicineItems1.length; i++) {
                if (_otherSyrupActualMedicineItems1[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[1]) {
                  _otherSyrupActualMedicineSelectedItem1 =
                      _otherSyrupActualMedicineItems1[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupStrengthItems1.length; i++) {
                if (_otherSyrupStrengthItems1[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[1]) {
                  _otherSyrupSelectedStrengthItem1 =
                      _otherSyrupStrengthItems1[i].value;
                  break;
                }
              }
            } else if (otherType1 == 3) {
              for (int i = 0; i < _otherTabletBrandNameItems1.length; i++) {
                if (_otherTabletBrandNameItems1[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[1]) {
                  _otherTabletSelectedBrandNameItem1 =
                      _otherTabletBrandNameItems1[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletActualMedicineItems1.length; i++) {
                if (_otherTabletActualMedicineItems1[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[1]) {
                  _otherTabletActualMedicineSelectedItem1 =
                      _otherTabletActualMedicineItems1[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletStrengthItems1.length; i++) {
                if (_otherTabletStrengthItems1[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[1]) {
                  _otherTabletSelectedStrengthItem1 =
                      _otherTabletStrengthItems1[i].value;
                  break;
                }
              }
            } else if (otherType1 == 4) {
              for (int i = 0; i < _otherCapsuleBrandNameItems1.length; i++) {
                if (_otherCapsuleBrandNameItems1[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[1]) {
                  _otherCapsuleSelectedBrandNameItem1 =
                      _otherCapsuleBrandNameItems1[i].value;
                  break;
                }
              }
              for (int i = 0;
              i < _otherCapsuleActualMedicineItems1.length;
              i++) {
                if (_otherCapsuleActualMedicineItems1[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[1]) {
                  _otherCapsuleActualMedicineSelectedItem1 =
                      _otherCapsuleActualMedicineItems1[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherCapsuleStrengthItems1.length; i++) {
                if (_otherCapsuleStrengthItems1[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[1]) {
                  _otherCapsuleSelectedStrengthItem1 =
                      _otherCapsuleStrengthItems1[i].value;
                  break;
                }
              }
            }


            //Other 2

            int otherType2 = 0;

            for (int i = 0; i < _otherFormulationItems2.length; i++) {
              if (_otherFormulationItems2[i].value.name ==
                  countries['data'][0]['formulationOther'].toString().split("*")[2]) {
                _otherSelectedItem2 = _otherFormulationItems2[i].value;
                otherType2 = _otherFormulationItems2[i].value.value;
                break;
              }
            }

            for (int i = 0; i < _otherTimesDayItems2.length; i++) {
              if (_otherTimesDayItems2[i].value.name ==
                  countries['data'][0]['numberOfTimesOther'].toString().split("*")[2]) {
                _otherTimesDaySelectedItem2 = _otherTimesDayItems2[i].value;
                break;
              }
            }

            _otherAdvisedDose2= countries['data'][0]['advisedDoseOther'].toString().split("*")[2];
            _otherAdviseDoseController2.text = _otherAdvisedDose2;
            _otherAdviseDoseController2.selection = TextSelection.fromPosition(TextPosition(offset: _otherAdviseDoseController2.text.length));
            if(_otherAdvisedDose2!=""){
              isOtherTwo = true;
            }
            _otherEffectiveDailyDose2 = countries['data'][0]['effectiveDailyDoseOther'].toString().split("*")[2];
            _otherHowManyDays2 = countries['data'][0]['howManyDaysOther'].toString().split("*")[2];
            _otherRemark2 = countries['data'][0]['remarksOther'].toString().split("*")[2];

            //_otherTakenOrNot2 = countries['data'][0]['takenOther'].toString().split("*")[2];

            if(countries['data'][0]['takenOther'].toString().contains("*")) {
              _otherTakenYes2 = countries['data'][0]['takenOther'].toString().split("*")[2];
              //_otherTakenNo2 = countries['data'][0]['takenOther'].toString().split("*")[5];
            }else{
              _otherTakenYes2 = countries['data'][0]['takenOther'];
              //_otherTakenNo2 = "0";
            }

            if (otherType2 == 2) {
              for (int i = 0; i < _otherSyrupBrandNameItems2.length; i++) {
                if (_otherSyrupBrandNameItems2[i].value.name == countries['data'][0]['brandNameOther'].toString().split("*")[2]) {
                  _otherSyrupSelectedBrandNameItem2 = _otherSyrupBrandNameItems2[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupActualMedicineItems2.length; i++) {
                if (_otherSyrupActualMedicineItems2[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[2]) {
                  _otherSyrupActualMedicineSelectedItem2 =
                      _otherSyrupActualMedicineItems2[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherSyrupStrengthItems2.length; i++) {
                if (_otherSyrupStrengthItems2[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[2]) {
                  _otherSyrupSelectedStrengthItem2 =
                      _otherSyrupStrengthItems2[i].value;
                  break;
                }
              }
            } else if (otherType2 == 3) {
              for (int i = 0; i < _otherTabletBrandNameItems2.length; i++) {
                if (_otherTabletBrandNameItems2[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[2]) {
                  _otherTabletSelectedBrandNameItem2 =
                      _otherTabletBrandNameItems2[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletActualMedicineItems2.length; i++) {
                if (_otherTabletActualMedicineItems2[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[2]) {
                  _otherTabletActualMedicineSelectedItem2 =
                      _otherTabletActualMedicineItems2[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherTabletStrengthItems2.length; i++) {
                if (_otherTabletStrengthItems2[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[2]) {
                  _otherTabletSelectedStrengthItem2 =
                      _otherTabletStrengthItems2[i].value;
                  break;
                }
              }
            } else if (otherType2 == 4) {
              for (int i = 0; i < _otherCapsuleBrandNameItems2.length; i++) {
                if (_otherCapsuleBrandNameItems2[i].value.name ==
                    countries['data'][0]['brandNameOther'].toString().split("*")[2]) {
                  _otherCapsuleSelectedBrandNameItem2 =
                      _otherCapsuleBrandNameItems2[i].value;
                  break;
                }
              }
              for (int i = 0;
              i < _otherCapsuleActualMedicineItems2.length;
              i++) {
                if (_otherCapsuleActualMedicineItems2[i].value.name ==
                    countries['data'][0]['actualMedicineOther'].toString().split("*")[2]) {
                  _otherCapsuleActualMedicineSelectedItem2 =
                      _otherCapsuleActualMedicineItems2[i].value;
                  break;
                }
              }
              for (int i = 0; i < _otherCapsuleStrengthItems2.length; i++) {
                if (_otherCapsuleStrengthItems2[i].value.name ==
                    countries['data'][0]['strengthOther'].toString().split("*")[2]) {
                  _otherCapsuleSelectedStrengthItem2 =
                      _otherCapsuleStrengthItems2[i].value;
                  break;
                }
              }
            }


          }
        }
      });
    });

    //Steroid

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

    addOtherMedicine();
  }

  void addOtherMedicine() {
    // Other Medicine

    _otherFormulationItems = buildDropDownMenuItems(_otherDropDownItem);
    _otherSelectedItem = _otherFormulationItems[0].value;

    _otherSyrupBrandNameItems =
        buildDropDownMenuItems(_otherSyrupBrandNameDropDownItems);
    _otherSyrupSelectedBrandNameItem = _otherSyrupBrandNameItems[0].value;

    _otherTabletBrandNameItems =
        buildDropDownMenuItems(_otherTabletBrandNameDropDownItems);
    _otherTabletSelectedBrandNameItem = _otherTabletBrandNameItems[0].value;

    _otherCapsuleBrandNameItems =
        buildDropDownMenuItems(_otherCapsuleBrandNameDropDownItems);
    _otherCapsuleSelectedBrandNameItem = _otherCapsuleBrandNameItems[0].value;

    _otherSyrupActualMedicineItems =
        buildDropDownMenuItems(_otherSyrupActualMedicineDropDownItem);
    _otherSyrupActualMedicineSelectedItem =
        _otherSyrupActualMedicineItems[0].value;

    _otherTabletActualMedicineItems =
        buildDropDownMenuItems(_otherTabletActualMedicineDropDownItem);
    _otherTabletActualMedicineSelectedItem =
        _otherTabletActualMedicineItems[0].value;

    _otherCapsuleActualMedicineItems =
        buildDropDownMenuItems(_otherCapsuleActualMedicineDropDownItem);
    _otherCapsuleActualMedicineSelectedItem =
        _otherCapsuleActualMedicineItems[0].value;

    _otherSyrupStrengthItems =
        buildDropDownMenuItems(_otherSyrupStrengthDropDownItems);
    _otherSyrupSelectedStrengthItem = _otherSyrupStrengthItems[0].value;

    _otherTabletStrengthItems =
        buildDropDownMenuItems(_otherTabletStrengthDropDownItems);
    _otherTabletSelectedStrengthItem = _otherTabletStrengthItems[0].value;

    _otherCapsuleStrengthItems =
        buildDropDownMenuItems(_otherCapsuleStrengthDropDownItems);
    _otherCapsuleSelectedStrengthItem = _otherCapsuleStrengthItems[0].value;

    _otherTimesDayItems = buildDropDownMenuItems(_otherTimesDayDropDownItem);
    _otherTimesDaySelectedItem = _otherTimesDayItems[0].value;

    otherMedicineOne();

    otherMedicineTwo();

    /* setState(() {
      otherMedicineArray.add(new OtherListItem(
          _otherSelectedItem, _otherSyrupSelectedBrandNameItem, _otherSyrupActualMedicineSelectedItem,
          _otherSyrupSelectedStrengthItem, "",
          _otherTimesDaySelectedItem, "", "Taken", ""));
    });*/
  }

  void otherMedicineOne(){
    // Other 1

    _otherFormulationItems1 = buildDropDownMenuItems(_otherDropDownItem);
    _otherSelectedItem1 = _otherFormulationItems1[0].value;

    _otherSyrupBrandNameItems1 =
        buildDropDownMenuItems(_otherSyrupBrandNameDropDownItems);
    _otherSyrupSelectedBrandNameItem1 = _otherSyrupBrandNameItems1[0].value;

    _otherTabletBrandNameItems1 =
        buildDropDownMenuItems(_otherTabletBrandNameDropDownItems);
    _otherTabletSelectedBrandNameItem1 = _otherTabletBrandNameItems1[0].value;

    _otherCapsuleBrandNameItems1 =
        buildDropDownMenuItems(_otherCapsuleBrandNameDropDownItems);
    _otherCapsuleSelectedBrandNameItem1 = _otherCapsuleBrandNameItems1[0].value;

    _otherSyrupActualMedicineItems1 =
        buildDropDownMenuItems(_otherSyrupActualMedicineDropDownItem);
    _otherSyrupActualMedicineSelectedItem1 =
        _otherSyrupActualMedicineItems1[0].value;

    _otherTabletActualMedicineItems1 =
        buildDropDownMenuItems(_otherTabletActualMedicineDropDownItem);
    _otherTabletActualMedicineSelectedItem1 =
        _otherTabletActualMedicineItems1[0].value;

    _otherCapsuleActualMedicineItems1 =
        buildDropDownMenuItems(_otherCapsuleActualMedicineDropDownItem);
    _otherCapsuleActualMedicineSelectedItem1 =
        _otherCapsuleActualMedicineItems1[0].value;

    _otherSyrupStrengthItems1 =
        buildDropDownMenuItems(_otherSyrupStrengthDropDownItems);
    _otherSyrupSelectedStrengthItem1 = _otherSyrupStrengthItems1[0].value;

    _otherTabletStrengthItems1 =
        buildDropDownMenuItems(_otherTabletStrengthDropDownItems);
    _otherTabletSelectedStrengthItem1 = _otherTabletStrengthItems1[0].value;

    _otherCapsuleStrengthItems1 =
        buildDropDownMenuItems(_otherCapsuleStrengthDropDownItems);
    _otherCapsuleSelectedStrengthItem1 = _otherCapsuleStrengthItems1[0].value;

    _otherTimesDayItems1 = buildDropDownMenuItems(_otherTimesDayDropDownItem);
    _otherTimesDaySelectedItem1 = _otherTimesDayItems1[0].value;
  }

  void otherMedicineTwo(){
    // Other 2

    _otherFormulationItems2 = buildDropDownMenuItems(_otherDropDownItem);
    _otherSelectedItem2 = _otherFormulationItems2[0].value;

    _otherSyrupBrandNameItems2 =
        buildDropDownMenuItems(_otherSyrupBrandNameDropDownItems);
    _otherSyrupSelectedBrandNameItem2 = _otherSyrupBrandNameItems2[0].value;

    _otherTabletBrandNameItems2 =
        buildDropDownMenuItems(_otherTabletBrandNameDropDownItems);
    _otherTabletSelectedBrandNameItem2 = _otherTabletBrandNameItems2[0].value;

    _otherCapsuleBrandNameItems2 =
        buildDropDownMenuItems(_otherCapsuleBrandNameDropDownItems);
    _otherCapsuleSelectedBrandNameItem2 = _otherCapsuleBrandNameItems2[0].value;

    _otherSyrupActualMedicineItems2 =
        buildDropDownMenuItems(_otherSyrupActualMedicineDropDownItem);
    _otherSyrupActualMedicineSelectedItem2 =
        _otherSyrupActualMedicineItems2[0].value;

    _otherTabletActualMedicineItems2 =
        buildDropDownMenuItems(_otherTabletActualMedicineDropDownItem);
    _otherTabletActualMedicineSelectedItem2 =
        _otherTabletActualMedicineItems2[0].value;

    _otherCapsuleActualMedicineItems2 =
        buildDropDownMenuItems(_otherCapsuleActualMedicineDropDownItem);
    _otherCapsuleActualMedicineSelectedItem2 =
        _otherCapsuleActualMedicineItems2[0].value;

    _otherSyrupStrengthItems2 =
        buildDropDownMenuItems(_otherSyrupStrengthDropDownItems);
    _otherSyrupSelectedStrengthItem2 = _otherSyrupStrengthItems2[0].value;

    _otherTabletStrengthItems2 =
        buildDropDownMenuItems(_otherTabletStrengthDropDownItems);
    _otherTabletSelectedStrengthItem2 = _otherTabletStrengthItems2[0].value;

    _otherCapsuleStrengthItems2 =
        buildDropDownMenuItems(_otherCapsuleStrengthDropDownItems);
    _otherCapsuleSelectedStrengthItem2 = _otherCapsuleStrengthItems2[0].value;

    _otherTimesDayItems2 = buildDropDownMenuItems(_otherTimesDayDropDownItem);
    _otherTimesDaySelectedItem2 = _otherTimesDayItems2[0].value;
  }

  ///Steroid

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
    });
  }

  void _countOtherStrength() {
    String strength = "";
    if (_otherSelectedItem.value == 2) {
      strength = _otherSyrupSelectedStrengthItem.name;
    } else if (_otherSelectedItem.value == 3) {
      strength = _otherTabletSelectedStrengthItem.name;
    } else if (_otherSelectedItem.value == 4) {
      strength = _otherCapsuleSelectedStrengthItem.name;
    }
    setState(() {
      if (strength == "15 mg per 5 ml") {
        _otherStrength = 3;
      } else if (strength == "250 mg per 5 ml") {
        _otherStrength = 50;
      } else if (strength == "200 mg per ml") {
        _otherStrength = 200;
      } else if(strength == "5 mg per 5 ml" || strength=="Strength") {
        _otherStrength = 1;
      } else {
        List<String> temp = strength.split(" ");
        _otherStrength = double.parse(temp[0]);
      }
    });
  }

  void _countOtherEffectiveDose() {
    double temp = 0;
    if (_otherAdvisedDose == "") {
      _otherAdvisedDose = "0";
    }
    if (_otherTimesDaySelectedItem.name == "Once a day") {
      temp = _otherStrength * double.parse(_otherAdvisedDose) * 1;
    } else if (_otherTimesDaySelectedItem.name == "Twice a day") {
      temp = _otherStrength * double.parse(_otherAdvisedDose) * 2;
    } else if (_otherTimesDaySelectedItem.name == "Thrice a day") {
      temp = _otherStrength * double.parse(_otherAdvisedDose) * 3;
    } else if (_otherTimesDaySelectedItem.name == "On alternate days") {
      temp = _otherStrength * double.parse(_otherAdvisedDose) / 2;
    } else {
      temp = _otherStrength * double.parse(_otherAdvisedDose) * 1;
    }
    setState(() {
      _otherEffectiveDailyDose = temp.toString();
    });
  }

  void _countOtherStrength1() {
    String strength = "";
    if (_otherSelectedItem1.value == 2) {
      strength = _otherSyrupSelectedStrengthItem1.name;
    } else if (_otherSelectedItem1.value == 3) {
      strength = _otherTabletSelectedStrengthItem1.name;
    } else if (_otherSelectedItem1.value == 4) {
      strength = _otherCapsuleSelectedStrengthItem1.name;
    }
    setState(() {
      if (strength == "15 mg per 5 ml") {
        _otherStrength1 = 3;
      } else if (strength == "250 mg per 5 ml") {
        _otherStrength1 = 50;
      } else if (strength == "200 mg per ml") {
        _otherStrength1 = 200;
      } else if(strength == "5 mg per 5 ml" || strength=="Strength") {
        _otherStrength1 = 1;
      }else{
        List<String> temp = strength.split(" ");
        _otherStrength1 = double.parse(temp[0]);
      }
    });
  }

  void _countOtherEffectiveDose1() {
    double temp = 0;
    if (_otherAdvisedDose1 == "") {
      _otherAdvisedDose1 = "0";
    }
    if (_otherTimesDaySelectedItem1.name == "Once a day") {
      temp = _otherStrength1 * double.parse(_otherAdvisedDose1) * 1;
    } else if (_otherTimesDaySelectedItem1.name == "Twice a day") {
      temp = _otherStrength1 * double.parse(_otherAdvisedDose1) * 2;
    } else if (_otherTimesDaySelectedItem1.name == "Thrice a day") {
      temp = _otherStrength1 * double.parse(_otherAdvisedDose1) * 3;
    } else if (_otherTimesDaySelectedItem1.name == "On alternate days") {
      temp = _otherStrength1 * double.parse(_otherAdvisedDose1) / 2;
    } else {
      temp = _otherStrength1 * double.parse(_otherAdvisedDose1) * 1;
    }
    setState(() {
      _otherEffectiveDailyDose1 = temp.toString();
    });
  }

  void _countOtherStrength2() {
    String strength = "";
    if (_otherSelectedItem2.value == 2) {
      strength = _otherSyrupSelectedStrengthItem2.name;
    } else if (_otherSelectedItem2.value == 3) {
      strength = _otherTabletSelectedStrengthItem2.name;
    } else if (_otherSelectedItem2.value == 4) {
      strength = _otherCapsuleSelectedStrengthItem2.name;
    }
    setState(() {
      if (strength == "15 mg per 5 ml") {
        _otherStrength2 = 3;
      } else if (strength == "250 mg per 5 ml") {
        _otherStrength2 = 50;
      } else if (strength == "200 mg per ml") {
        _otherStrength2 = 200;
      } else if(strength == "5 mg per 5 ml" || strength=="Strength") {
        _otherStrength2 = 1;
      }else{
        List<String> temp = strength.split(" ");
        _otherStrength2 = double.parse(temp[0]);
      }
    });
  }

  void _countOtherEffectiveDose2() {
    double temp = 0;
    if (_otherAdvisedDose2 == "") {
      _otherAdvisedDose2 = "0";
    }
    if (_otherTimesDaySelectedItem2.name == "Once a day") {
      temp = _otherStrength2 * double.parse(_otherAdvisedDose2) * 1;
    } else if (_otherTimesDaySelectedItem2.name == "Twice a day") {
      temp = _otherStrength2 * double.parse(_otherAdvisedDose2) * 2;
    } else if (_otherTimesDaySelectedItem2.name == "Thrice a day") {
      temp = _otherStrength2 * double.parse(_otherAdvisedDose2) * 3;
    } else if (_otherTimesDaySelectedItem2.name == "On alternate days") {
      temp = _otherStrength2 * double.parse(_otherAdvisedDose2) / 2;
    } else {
      temp = _otherStrength2 * double.parse(_otherAdvisedDose2) * 1;
    }
    setState(() {
      _otherEffectiveDailyDose2 = temp.toString();
    });
  }

  Future<bool> _handleKeyboard() {
    if (!(MediaQuery.of(context).viewInsets.bottom == 0.0)) {
      FocusScope.of(context).requestFocus(FocusNode());
      return Future<bool>.value(false);
    } else {
      Navigator.of(context).pop();
      return Future<bool>.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleKeyboard(),
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red[200],
          title: Text(
            AppLocalizations.of(context).medications,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: GestureDetector(
          onTap:(){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                elevation: 4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                              AppLocalizations.of(context).steroids,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).formulation+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                                        });
                                      });
                                    }),
                              ),
                            ]),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).name+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: _steroidSelectedItem.value == 2
                                    ? DropdownButton<ListItem>(
                                        value: _steroidSyrupSelectedBrandNameItem,
                                        items: _steroidSyrupBrandNameItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _steroidSyrupSelectedBrandNameItem);
                                            _steroidSyrupSelectedBrandNameItem =
                                                value;
                                          });
                                        })
                                    : DropdownButton<ListItem>(
                                        value:
                                            _steroidTabletSelectedBrandNameItem,
                                        items: _steroidTabletBrandNameItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _steroidTabletSelectedBrandNameItem);
                                            _steroidTabletSelectedBrandNameItem =
                                                value;
                                          });
                                        }),
                              )
                            ]),
                            SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).actualMedicine+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                                AppLocalizations.of(context).strength+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: _steroidSelectedItem.value == 2
                                    ? DropdownButton<ListItem>(
                                        value: _steroidSyrupSelectedStrengthItem,
                                        items: _steroidSyrupStrengthItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _steroidSyrupSelectedStrengthItem);
                                            _steroidSyrupSelectedStrengthItem =
                                                value;
                                            _countSteroidStrength();
                                            _countSteroidEffectiveDose();
                                          });
                                        })
                                    : DropdownButton<ListItem>(
                                        value: _steroidTabletSelectedStrengthItem,
                                        items: _steroidTabletStrengthItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _steroidTabletSelectedStrengthItem);
                                            _steroidTabletSelectedStrengthItem =
                                                value;
                                            _countSteroidStrength();
                                            _countSteroidEffectiveDose();
                                          });
                                        }),
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
                                  autofocus: false,
                                  controller: _steroidAdviseDoseController,
                                  onChanged: (value) {
                                    _steroidAdviseDoseController.text = value;
                                    _steroidAdviseDoseController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _steroidAdviseDoseController
                                                .text.length));
                                    setState(() {
                                      _steroidAdvisedDose = value;
                                      _countSteroidStrength();
                                      _countSteroidEffectiveDose();
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
                            /*SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                "Advised dose:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                                    _steroidAdviseDoseController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _steroidAdviseDoseController
                                                .text.length));
                                    setState(() {
                                      _steroidAdvisedDose = value;
                                      _countSteroidStrength();
                                      _countSteroidEffectiveDose();
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
                            ]),*/
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).noOfTimesADay+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                            Visibility(
                              visible: widget.isFrom == 'Doctor' ? true : false,
                              child: /*_steroidSelectedItem.value == 2
                                  ? */Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        Text(AppLocalizations.of(context).tillUrineIsNegativeOrTrace,
                                            style: TextStyle(fontSize: 16)),
                                        Row(children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context).forHowManyDays+":",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 30,
                                            child: TextField(
                                              cursorColor: Colors.red[200],
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      new UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .red[200])),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 7),
                                                  hintText: ""),
                                              controller: TextEditingController(
                                                  text: _steroidHowManyDays),
                                              style: TextStyle(fontSize: 16),
                                              keyboardType: TextInputType.number,
                                              //  maxLength: 3,
                                              onChanged: (value) {
                                                _steroidHowManyDays = value;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(AppLocalizations.of(context).weeks,
                                              style: TextStyle(fontSize: 16)),
                                        ]),
                                      ],
                                    )
                                  //: Container(),
                            ),
                            Visibility(
                              visible: widget.isFrom == 'Doctor' ? false : true,
                              child: Column(
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            Radio(
                                              activeColor: Colors.red[200],
                                              value: "1",
                                              groupValue : _steroidTakenYes,
                                              onChanged: (String val) {
                                                setState(() {
                                                    _steroidTakenYes = "1";
                                                });
                                              },
                                            ),
                                            Text(AppLocalizations.of(context).taken)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            Radio(
                                              activeColor: Colors.red[200],
                                              value: "0",
                                              groupValue : _steroidTakenYes,
                                              onChanged: (String val) {
                                                setState(() {
                                                  _steroidTakenYes = "0";
                                                });
                                              },
                                            ),
                                            Text(AppLocalizations.of(context).notTaken)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              cursorColor: Colors.red[200],
                              decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 7),
                                  hintText: AppLocalizations.of(context).remark),
                              style: TextStyle(fontSize: 17),
                              autofocus: false,
                              controller:
                                  TextEditingController(text: _steroidRemark),
                              onChanged: (value) {
                                _steroidRemark = value;
                              },
                            ),
                            SizedBox(height: 10),
                            /*Center(
                              child: OutlineButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.white,
                                  child: const Text('Update',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                  onPressed: () {
                                    setState(() {

                                    });
                                  },
                                  borderSide: BorderSide(
                                    color:  Colors.red[200],
                                  )),
                            )*/
                          ],
                        ),
                      ),
                    ]),
              ),
              Card(
                elevation: 4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                AppLocalizations.of(context).otherMedicines,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).formulation+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: DropdownButton<ListItem>(
                                    value: _otherSelectedItem,
                                    items: _otherFormulationItems,
                                    onChanged: (value) {
                                      setState(() {
                                        print(_otherSelectedItem);
                                        setState(() {
                                          print(value.value);
                                          _otherSelectedItem = value;
                                        });
                                      });
                                    }),
                              ),
                            ]),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).name+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: _otherSelectedItem.value == 2
                                    ? DropdownButton<ListItem>(
                                        value: _otherSyrupSelectedBrandNameItem,
                                        items: _otherSyrupBrandNameItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _otherSyrupSelectedBrandNameItem);
                                            _otherSyrupSelectedBrandNameItem =
                                                value;
                                          });
                                        })
                                    : _otherSelectedItem.value == 3
                                        ? DropdownButton<ListItem>(
                                            value:
                                                _otherTabletSelectedBrandNameItem,
                                            items: _otherTabletBrandNameItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    _otherTabletSelectedBrandNameItem);
                                                _otherTabletSelectedBrandNameItem =
                                                    value;
                                              });
                                            })
                                        : DropdownButton<ListItem>(
                                            value:
                                                _otherCapsuleSelectedBrandNameItem,
                                            items: _otherCapsuleBrandNameItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    _otherCapsuleSelectedBrandNameItem);
                                                _otherCapsuleSelectedBrandNameItem =
                                                    value;
                                              });
                                            }),
                              )
                            ]),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).actualMedicine+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: _otherSelectedItem.value == 2
                                    ? DropdownButton<ListItem>(
                                        value:
                                            _otherSyrupActualMedicineSelectedItem,
                                        items: _otherSyrupActualMedicineItems,
                                        onChanged: (value) {
                                          setState(() {
                                            print(
                                                _otherSyrupActualMedicineSelectedItem);
                                            _otherSyrupActualMedicineSelectedItem =
                                                value;
                                          });
                                        })
                                    : _otherSelectedItem.value == 3
                                        ? DropdownButton<ListItem>(
                                            value:
                                                _otherTabletActualMedicineSelectedItem,
                                            items:
                                                _otherTabletActualMedicineItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    _otherTabletActualMedicineSelectedItem);
                                                _otherTabletActualMedicineSelectedItem =
                                                    value;
                                              });
                                            })
                                        : DropdownButton<ListItem>(
                                            value:
                                                _otherCapsuleActualMedicineSelectedItem,
                                            items:
                                                _otherCapsuleActualMedicineItems,
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    _otherCapsuleActualMedicineSelectedItem);
                                                _otherCapsuleActualMedicineSelectedItem =
                                                    value;
                                              });
                                            }),
                              )
                            ]),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).strength+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: _otherSelectedItem.value == 2
                                    ? DropdownButton<ListItem>(
                                        value: _otherSyrupSelectedStrengthItem,
                                        items: _otherSyrupStrengthItems,
                                        onChanged: (value) {
                                          print(value.name);
                                          setState(() {
                                            _otherSyrupSelectedStrengthItem =
                                                value;
                                            _countOtherStrength();
                                            _countOtherEffectiveDose();
                                          });
                                        })
                                    : _otherSelectedItem.value == 3
                                        ? DropdownButton<ListItem>(
                                            value:
                                                _otherTabletSelectedStrengthItem,
                                            items: _otherTabletStrengthItems,
                                            onChanged: (value) {
                                              print(value.name);
                                              setState(() {
                                                _otherTabletSelectedStrengthItem =
                                                    value;
                                                _countOtherStrength();
                                                _countOtherEffectiveDose();
                                              });
                                            })
                                        : DropdownButton<ListItem>(
                                            value:
                                                _otherCapsuleSelectedStrengthItem,
                                            items: _otherCapsuleStrengthItems,
                                            onChanged: (value) {
                                              print(value.name);
                                              setState(() {
                                                _otherCapsuleSelectedStrengthItem =
                                                    value;
                                                _countOtherStrength();
                                                _countOtherEffectiveDose();
                                              });
                                            }),
                              )
                            ]),
                            SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).advisedDose+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                                  controller: _otherAdviseDoseController,
                                  //  maxLength: 3,
                                  autofocus: false,
                                  onChanged: (value) {
                                    _otherAdviseDoseController.text = value;
                                    _otherAdviseDoseController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _otherAdviseDoseController
                                                .text.length));
                                    setState(() {
                                      _otherAdvisedDose = value;
                                      _countOtherStrength();
                                      _countOtherEffectiveDose();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                  _otherSelectedItem.value == 2
                                      ? "ml"
                                      : "tablets",
                                  style: TextStyle(fontSize: 16)),
                            ]),
                            SizedBox(height: 10),
                            Row(children: <Widget>[
                              Text(
                                AppLocalizations.of(context).noOfTimesADay+":",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: DropdownButton<ListItem>(
                                    value: _otherTimesDaySelectedItem,
                                    items: _otherTimesDayItems,
                                    onChanged: (value) {
                                      setState(() {
                                        print(_otherTimesDaySelectedItem);
                                        setState(() {
                                          print(value.value);
                                          _otherTimesDaySelectedItem = value;
                                          _countOtherStrength();
                                          _countOtherEffectiveDose();
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
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 60,
                                child: TextField(
                                  cursorColor: Colors.red[200],
                                  enabled: false,
                                  controller: TextEditingController(
                                      text: _otherEffectiveDailyDose),
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
                            Visibility(
                              visible: widget.isFrom == 'Doctor' ? true : false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Row(children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context).forHowManyDays+":",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 30,
                                      child: TextField(
                                        cursorColor: Colors.red[200],
                                        decoration: InputDecoration(
                                            focusedBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red[200])),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(vertical: 7),
                                            hintText: ""),
                                        style: TextStyle(fontSize: 16),
                                        keyboardType: TextInputType.number,
                                        //  maxLength: 3,
                                        controller: TextEditingController(
                                            text: _otherHowManyDays),
                                        onChanged: (value) {
                                          _otherHowManyDays = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        _otherTabletSelectedBrandNameItem.name == "Lasix" ? "days"
                                            : (_otherTabletSelectedBrandNameItem.name == "Endoxan" ||
                                                    _otherTabletSelectedBrandNameItem.name == "Cycloxan")
                                                ? AppLocalizations.of(context).weeks
                                                : AppLocalizations.of(context).months,
                                        style: TextStyle(fontSize: 16)),
                                  ]),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: widget.isFrom == 'Doctor' ? false : true,
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Radio(
                                                activeColor: Colors.red[200],
                                                value: "1",
                                                groupValue: _otherTakenYes,
                                                onChanged: (String val) {
                                                  setState(() {
                                                      _otherTakenYes = "1";
                                                  });
                                                },
                                              ),
                                              Text(AppLocalizations.of(context).taken)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Radio(
                                                activeColor: Colors.red[200],
                                                value: "0",
                                                groupValue: _otherTakenYes,
                                                onChanged: (String val) {
                                                  setState(() {
                                                    _otherTakenYes = "0";
                                                  });
                                                },
                                              ),
                                              Text(AppLocalizations.of(context).notTaken)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(height: 5),
                            TextField(
                              cursorColor: Colors.red[200],
                              decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[200])),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 7),
                                  hintText: AppLocalizations.of(context).remark),
                              style: TextStyle(fontSize: 17),
                              autofocus: false,
                              controller:
                                  TextEditingController(text: _otherRemark),
                              onChanged: (value) {
                                _otherRemark = value;
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ]),
              ),
              Visibility(
                visible: isOtherOne,
                child: Card(
                  elevation: 4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context).otherMedicines+" 1",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isOtherOne = false;
                                        _otherAdvisedDose1 = "";
                                        _otherAdviseDoseController1.text = "";
                                        _otherEffectiveDailyDose1 = "0.0";
                                        _otherTakenYes = "0";
                                        //_otherTakenNo = "0";
                                        _otherRemark1="";
                                        otherMedicineOne();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[200]),
                                      child:
                                          Icon(Icons.remove, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).formulation+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: DropdownButton<ListItem>(
                                      value: _otherSelectedItem1,
                                      items: _otherFormulationItems1,
                                      onChanged: (value) {
                                        setState(() {
                                          print(_otherSelectedItem1);
                                          setState(() {
                                            print(value.value);
                                            _otherSelectedItem1 = value;
                                          });
                                        });
                                      }),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).name+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem1.value == 2
                                      ? DropdownButton<ListItem>(
                                          value:
                                              _otherSyrupSelectedBrandNameItem1,
                                          items: _otherSyrupBrandNameItems1,
                                          onChanged: (value) {
                                            setState(() {
                                              print(
                                                  _otherSyrupSelectedBrandNameItem1);
                                              _otherSyrupSelectedBrandNameItem1 =
                                                  value;
                                            });
                                          })
                                      : _otherSelectedItem1.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletSelectedBrandNameItem1,
                                              items: _otherTabletBrandNameItems1,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherTabletSelectedBrandNameItem1);
                                                  _otherTabletSelectedBrandNameItem1 =
                                                      value;
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleSelectedBrandNameItem1,
                                              items: _otherCapsuleBrandNameItems1,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherCapsuleSelectedBrandNameItem1);
                                                  _otherCapsuleSelectedBrandNameItem1 =
                                                      value;
                                                });
                                              }),
                                )
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).actualMedicine+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem1.value == 2
                                      ? DropdownButton<ListItem>(
                                          value:
                                              _otherSyrupActualMedicineSelectedItem1,
                                          items: _otherSyrupActualMedicineItems1,
                                          onChanged: (value) {
                                            setState(() {
                                              print(
                                                  _otherSyrupActualMedicineSelectedItem1);
                                              _otherSyrupActualMedicineSelectedItem1 =
                                                  value;
                                            });
                                          })
                                      : _otherSelectedItem1.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletActualMedicineSelectedItem1,
                                              items:
                                                  _otherTabletActualMedicineItems1,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherTabletActualMedicineSelectedItem1);
                                                  _otherTabletActualMedicineSelectedItem1 =
                                                      value;
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleActualMedicineSelectedItem1,
                                              items:
                                                  _otherCapsuleActualMedicineItems1,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherCapsuleActualMedicineSelectedItem1);
                                                  _otherCapsuleActualMedicineSelectedItem1 =
                                                      value;
                                                });
                                              }),
                                )
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).strength+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem1.value == 2
                                      ? DropdownButton<ListItem>(
                                          value: _otherSyrupSelectedStrengthItem1,
                                          items: _otherSyrupStrengthItems1,
                                          onChanged: (value) {
                                            print(value.name);
                                            setState(() {
                                              _otherSyrupSelectedStrengthItem1 =
                                                  value;
                                              _countOtherStrength1();
                                              _countOtherEffectiveDose1();
                                            });
                                          })
                                      : _otherSelectedItem1.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletSelectedStrengthItem1,
                                              items: _otherTabletStrengthItems1,
                                              onChanged: (value) {
                                                print(value.name);
                                                setState(() {
                                                  _otherTabletSelectedStrengthItem1 =
                                                      value;
                                                  _countOtherStrength1();
                                                  _countOtherEffectiveDose1();
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleSelectedStrengthItem1,
                                              items: _otherCapsuleStrengthItems1,
                                              onChanged: (value) {
                                                print(value.name);
                                                setState(() {
                                                  _otherCapsuleSelectedStrengthItem1 =
                                                      value;
                                                  _countOtherStrength1();
                                                  _countOtherEffectiveDose1();
                                                });
                                              }),
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).advisedDose+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  child: TextField(
                                    cursorColor: Colors.red[200],
                                    decoration: InputDecoration(
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red[200])),
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        hintText: ""),
                                    style: TextStyle(fontSize: 16),
                                    keyboardType: TextInputType.number,
                                    controller: _otherAdviseDoseController1,
                                    //  maxLength: 3,
                                    onChanged: (value) {
                                      _otherAdviseDoseController1.text = value;
                                      _otherAdviseDoseController1.selection =
                                          TextSelection.fromPosition(TextPosition(
                                              offset: _otherAdviseDoseController1
                                                  .text.length));
                                      setState(() {
                                        _otherAdvisedDose1 = value;
                                        _countOtherStrength1();
                                        _countOtherEffectiveDose1();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                    _otherSelectedItem1.value == 2
                                        ? "ml"
                                        : "tablets",
                                    style: TextStyle(fontSize: 16)),
                              ]),
                              SizedBox(height: 10),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).noOfTimesADay+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: DropdownButton<ListItem>(
                                      value: _otherTimesDaySelectedItem1,
                                      items: _otherTimesDayItems1,
                                      onChanged: (value) {
                                        setState(() {
                                          print(_otherTimesDaySelectedItem1);
                                          setState(() {
                                            print(value.value);
                                            _otherTimesDaySelectedItem1 = value;
                                            _countOtherStrength1();
                                            _countOtherEffectiveDose1();
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
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 60,
                                  child: TextField(
                                    cursorColor: Colors.red[200],
                                    enabled: false,
                                    controller: TextEditingController(
                                        text: _otherEffectiveDailyDose1),
                                    decoration: InputDecoration(
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red[200])),
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
                              Visibility(
                                visible: widget.isFrom == 'Doctor' ? true : false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).forHowManyDays+":",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 30,
                                        child: TextField(
                                          cursorColor: Colors.red[200],
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  new UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.red[200])),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 7),
                                              hintText: ""),
                                          style: TextStyle(fontSize: 16),
                                          keyboardType: TextInputType.number,
                                          //  maxLength: 3,
                                          controller: TextEditingController(
                                              text: _otherHowManyDays1),
                                          onChanged: (value) {
                                            _otherHowManyDays1 = value;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          _otherTabletSelectedBrandNameItem1
                                                      .name ==
                                                  "Lasix"
                                              ? AppLocalizations.of(context).days
                                              : (_otherTabletSelectedBrandNameItem1
                                                              .name ==
                                                          "Endoxan" ||
                                                      _otherTabletSelectedBrandNameItem1
                                                              .name ==
                                                          "Cycloxan")
                                                  ? AppLocalizations.of(context).weeks
                                                  : AppLocalizations.of(context).months,
                                          style: TextStyle(fontSize: 16)),
                                    ]),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible:
                                      widget.isFrom == 'Doctor' ? false : true,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                Radio(
                                                  activeColor: Colors.red[200],
                                                  value: "1",
                                                  groupValue: _otherTakenYes1,
                                                  onChanged: (String val) {
                                                    setState(() {
                                                        _otherTakenYes1 = "1";
                                                    });
                                                  },
                                                ),
                                                Text(AppLocalizations.of(context).taken),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                Radio(
                                                  activeColor: Colors.red[200],
                                                  value: "0",
                                                  groupValue: _otherTakenYes1,
                                                  onChanged: (String val) {
                                                    setState(() {
                                                      _otherTakenYes1 = "0";
                                                    });
                                                  },
                                                ),
                                                Text(AppLocalizations.of(context).notTaken),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 5),
                              TextField(
                                cursorColor: Colors.red[200],
                                decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red[200])),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 7),
                                    hintText: AppLocalizations.of(context).remark),
                                style: TextStyle(fontSize: 17),
                                controller:
                                    TextEditingController(text: _otherRemark1),
                                onChanged: (value) {
                                  _otherRemark1 = value;
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Visibility(
                visible: isOtherTwo,
                child: Card(
                  elevation: 4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context).otherMedicines+" 2",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isOtherTwo = false;
                                        _otherAdvisedDose2 = "";
                                        _otherAdviseDoseController2.text = "";
                                        _otherEffectiveDailyDose2 = "0.0";
                                        _otherTakenYes2 = "0";
                                        //_otherTakenNo2 = "0";
                                        _otherRemark2="";
                                        otherMedicineTwo();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[200]),
                                      child:
                                      Icon(Icons.remove, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).formulation+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: DropdownButton<ListItem>(
                                      value: _otherSelectedItem2,
                                      items: _otherFormulationItems2,
                                      onChanged: (value) {
                                        setState(() {
                                          print(_otherSelectedItem2);
                                          setState(() {
                                            print(value.value);
                                            _otherSelectedItem2 = value;
                                          });
                                        });
                                      }),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).name+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem2.value == 2
                                      ? DropdownButton<ListItem>(
                                          value:
                                              _otherSyrupSelectedBrandNameItem2,
                                          items: _otherSyrupBrandNameItems2,
                                          onChanged: (value) {
                                            setState(() {
                                              print(
                                                  _otherSyrupSelectedBrandNameItem2);
                                              _otherSyrupSelectedBrandNameItem2 =
                                                  value;
                                            });
                                          })
                                      : _otherSelectedItem2.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletSelectedBrandNameItem2,
                                              items: _otherTabletBrandNameItems2,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherTabletSelectedBrandNameItem2);
                                                  _otherTabletSelectedBrandNameItem2 =
                                                      value;
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleSelectedBrandNameItem2,
                                              items: _otherCapsuleBrandNameItems2,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherCapsuleSelectedBrandNameItem2);
                                                  _otherCapsuleSelectedBrandNameItem2 =
                                                      value;
                                                });
                                              }),
                                )
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).actualMedicine+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem2.value == 2
                                      ? DropdownButton<ListItem>(
                                          value:
                                              _otherSyrupActualMedicineSelectedItem2,
                                          items: _otherSyrupActualMedicineItems2,
                                          onChanged: (value) {
                                            setState(() {
                                              print(
                                                  _otherSyrupActualMedicineSelectedItem2);
                                              _otherSyrupActualMedicineSelectedItem2 =
                                                  value;
                                            });
                                          })
                                      : _otherSelectedItem2.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletActualMedicineSelectedItem2,
                                              items:
                                                  _otherTabletActualMedicineItems2,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherTabletActualMedicineSelectedItem2);
                                                  _otherTabletActualMedicineSelectedItem2 =
                                                      value;
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleActualMedicineSelectedItem2,
                                              items:
                                                  _otherCapsuleActualMedicineItems2,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(
                                                      _otherCapsuleActualMedicineSelectedItem2);
                                                  _otherCapsuleActualMedicineSelectedItem2 =
                                                      value;
                                                });
                                              }),
                                )
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).strength+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: _otherSelectedItem2.value == 2
                                      ? DropdownButton<ListItem>(
                                          value: _otherSyrupSelectedStrengthItem2,
                                          items: _otherSyrupStrengthItems2,
                                          onChanged: (value) {
                                            print(value.name);
                                            setState(() {
                                              _otherSyrupSelectedStrengthItem2 =
                                                  value;
                                              _countOtherStrength2();
                                              _countOtherEffectiveDose2();
                                            });
                                          })
                                      : _otherSelectedItem2.value == 3
                                          ? DropdownButton<ListItem>(
                                              value:
                                                  _otherTabletSelectedStrengthItem2,
                                              items: _otherTabletStrengthItems2,
                                              onChanged: (value) {
                                                print(value.name);
                                                setState(() {
                                                  _otherTabletSelectedStrengthItem2 =
                                                      value;
                                                  _countOtherStrength2();
                                                  _countOtherEffectiveDose2();
                                                });
                                              })
                                          : DropdownButton<ListItem>(
                                              value:
                                                  _otherCapsuleSelectedStrengthItem2,
                                              items: _otherCapsuleStrengthItems2,
                                              onChanged: (value) {
                                                print(value.name);
                                                setState(() {
                                                  _otherCapsuleSelectedStrengthItem2 =
                                                      value;
                                                  _countOtherStrength2();
                                                  _countOtherEffectiveDose2();
                                                });
                                              }),
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).advisedDose+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  child: TextField(
                                    cursorColor: Colors.red[200],
                                    decoration: InputDecoration(
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red[200])),
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        hintText: ""),
                                    style: TextStyle(fontSize: 16),
                                    keyboardType: TextInputType.number,
                                    controller: _otherAdviseDoseController2,
                                    //  maxLength: 3,
                                    onChanged: (value) {
                                      _otherAdviseDoseController2.text = value;
                                      _otherAdviseDoseController2.selection =
                                          TextSelection.fromPosition(TextPosition(
                                              offset: _otherAdviseDoseController2
                                                  .text.length));
                                      setState(() {
                                        _otherAdvisedDose2 = value;
                                        _countOtherStrength2();
                                        _countOtherEffectiveDose2();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                    _otherSelectedItem2.value == 2
                                        ? "ml"
                                        : "tablets",
                                    style: TextStyle(fontSize: 16)),
                              ]),
                              SizedBox(height: 10),
                              Row(children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).noOfTimesADay+":",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: DropdownButton<ListItem>(
                                      value: _otherTimesDaySelectedItem2,
                                      items: _otherTimesDayItems2,
                                      onChanged: (value) {
                                        setState(() {
                                          print(_otherTimesDaySelectedItem2);
                                          setState(() {
                                            print(value.value);
                                            _otherTimesDaySelectedItem2 = value;
                                            _countOtherStrength2();
                                            _countOtherEffectiveDose2();
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
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 60,
                                  child: TextField(
                                    cursorColor: Colors.red[200],
                                    enabled: false,
                                    controller: TextEditingController(
                                        text: _otherEffectiveDailyDose2),
                                    decoration: InputDecoration(
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red[200])),
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
                              Visibility(
                                visible: widget.isFrom == 'Doctor' ? true : false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).forHowManyDays+":",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 30,
                                        child: TextField(
                                          cursorColor: Colors.red[200],
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  new UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.red[200])),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 7),
                                              hintText: ""),
                                          style: TextStyle(fontSize: 16),
                                          keyboardType: TextInputType.number,
                                          //  maxLength: 3,
                                          controller: TextEditingController(
                                              text: _otherHowManyDays2),
                                          onChanged: (value) {
                                            _otherHowManyDays2 = value;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          _otherTabletSelectedBrandNameItem2
                                                      .name ==
                                                  "Lasix"
                                              ? AppLocalizations.of(context).days
                                              : (_otherTabletSelectedBrandNameItem2
                                                              .name ==
                                                          "Endoxan" ||
                                                      _otherTabletSelectedBrandNameItem2
                                                              .name ==
                                                          "Cycloxan")
                                                  ? AppLocalizations.of(context).weeks
                                                  : AppLocalizations.of(context).months,
                                          style: TextStyle(fontSize: 16)),
                                    ]),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible:
                                      widget.isFrom == 'Doctor' ? false : true,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                Radio(
                                                  activeColor: Colors.red[200],
                                                  value: "1",
                                                  groupValue: _otherTakenYes2,
                                                  onChanged: (String val) {
                                                    setState(() {
                                                        _otherTakenYes2 = "1";
                                                    });
                                                  },
                                                ),
                                                Text(AppLocalizations.of(context).taken),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                Radio(
                                                  activeColor: Colors.red[200],
                                                  value: "0",
                                                  groupValue: _otherTakenYes2,
                                                  onChanged: (String val) {
                                                    setState(() {
                                                      _otherTakenYes2 = "0";
                                                    });
                                                  },
                                                ),
                                                Text(AppLocalizations.of(context).notTaken),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 5),
                              TextField(
                                cursorColor: Colors.red[200],
                                decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red[200])),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 7),
                                    hintText: AppLocalizations.of(context).remark),
                                style: TextStyle(fontSize: 17),
                                controller:
                                    TextEditingController(text: _otherRemark2),
                                onChanged: (value) {
                                  _otherRemark2 = value;
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Visibility(
                visible: isOtherOne == true && isOtherTwo == true ? false : true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isOtherOne) {
                            isOtherOne = true;
                          } else if (!isOtherTwo) {
                            isOtherTwo = true;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red[200]),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: OutlinedButton(
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
                              addUpdateRecord();
                            });
                          },style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.red[200],)
                      ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addUpdateRecord() async {

    setState(() {
      loading = true;
    });

    String steroidBrandName = "Name";
    String steroidStrength = "Strength";
    if (_steroidSelectedItem.value == 2) {
      steroidBrandName = _steroidSyrupSelectedBrandNameItem.name;
      steroidStrength = _steroidSyrupSelectedStrengthItem.name;
    } else if (_steroidSelectedItem.value == 3) {
      steroidBrandName = _steroidTabletSelectedBrandNameItem.name;
      steroidStrength = _steroidTabletSelectedStrengthItem.name;
    }

    String otherBrandName = "Name";
    String otherActualMedicine = "Actual medicine";
    String otherStrength = "Strength";
    if (_otherSelectedItem.value == 2) {
      otherBrandName = _otherSyrupSelectedBrandNameItem.name;
      otherActualMedicine = _otherSyrupActualMedicineSelectedItem.name;
      otherStrength = _otherSyrupSelectedStrengthItem.name;
    } else if (_otherSelectedItem.value == 3) {
      otherBrandName = _otherTabletSelectedBrandNameItem.name;
      otherActualMedicine = _otherTabletActualMedicineSelectedItem.name;
      otherStrength = _otherTabletSelectedStrengthItem.name;
    } else if (_otherSelectedItem.value == 4) {
      otherBrandName = _otherCapsuleSelectedBrandNameItem.name;
      otherActualMedicine = _otherCapsuleActualMedicineSelectedItem.name;
      otherStrength = _otherCapsuleSelectedStrengthItem.name;
    }

    String otherBrandName1 = "Name";
    String otherActualMedicine1 = "Actual medicine";
    String otherStrength1 = "Strength";
    if (_otherSelectedItem1.value == 2) {
      otherBrandName1 = _otherSyrupSelectedBrandNameItem1.name;
      otherActualMedicine1 = _otherSyrupActualMedicineSelectedItem1.name;
      otherStrength1 = _otherSyrupSelectedStrengthItem1.name;
    } else if (_otherSelectedItem1.value == 3) {
      otherBrandName1 = _otherTabletSelectedBrandNameItem1.name;
      otherActualMedicine1 = _otherTabletActualMedicineSelectedItem1.name;
      otherStrength1 = _otherTabletSelectedStrengthItem1.name;
    } else if (_otherSelectedItem1.value == 4) {
      otherBrandName1 = _otherCapsuleSelectedBrandNameItem1.name;
      otherActualMedicine1 = _otherCapsuleActualMedicineSelectedItem1.name;
      otherStrength1 = _otherCapsuleSelectedStrengthItem1.name;
    }

    String otherBrandName2 = "Name";
    String otherActualMedicine2 = "Actual medicine";
    String otherStrength2 = "Strength";
    if (_otherSelectedItem2.value == 2) {
      otherBrandName2 = _otherSyrupSelectedBrandNameItem2.name;
      otherActualMedicine2 = _otherSyrupActualMedicineSelectedItem2.name;
      otherStrength2 = _otherSyrupSelectedStrengthItem2.name;
    } else if (_otherSelectedItem2.value == 3) {
      otherBrandName2 = _otherTabletSelectedBrandNameItem2.name;
      otherActualMedicine2 = _otherTabletActualMedicineSelectedItem2.name;
      otherStrength2 = _otherTabletSelectedStrengthItem2.name;
    } else if (_otherSelectedItem2.value == 4) {
      otherBrandName2 = _otherCapsuleSelectedBrandNameItem2.name;
      otherActualMedicine2 = _otherCapsuleActualMedicineSelectedItem2.name;
      otherStrength2 = _otherCapsuleSelectedStrengthItem2.name;
    }

    String formulation = _otherSelectedItem.name+"*"+_otherSelectedItem1.name+"*"+_otherSelectedItem2.name;
    String name = otherBrandName + "*" + otherBrandName1 + "*" + otherBrandName2;
    String actualMedicine = otherActualMedicine+"*"+otherActualMedicine1+"*"+otherActualMedicine2;
    String strength = otherStrength+"*"+otherStrength1+"*"+otherStrength2;
    String adviseDose = _otherAdvisedDose+"*"+_otherAdvisedDose1+"*"+_otherAdvisedDose2;
    String numberOfTime = _otherTimesDaySelectedItem.name+"*"+_otherTimesDaySelectedItem1.name+"*"+_otherTimesDaySelectedItem2.name;
    String effectiveDailyDose = _otherEffectiveDailyDose+"*"+_otherEffectiveDailyDose1+"*"+_otherEffectiveDailyDose2;
    String howManyDays = _otherHowManyDays+"*"+_otherHowManyDays1+"*"+_otherHowManyDays2;
    String taken = _otherTakenYes+"*"+_otherTakenYes1+"*"+_otherTakenYes2;
    String remark = _otherRemark+"*"+_otherRemark1+"*"+_otherRemark2;


    Map data = {
      // '_id': '605a02c136eb7751480d9a55',
      'username': username,
      'patientId': patientId,
      'formulation': _steroidSelectedItem.name,
      'brandName': steroidBrandName,
      'actualMedicine': _steroidActualMedicine,
      'strength': steroidStrength,
      'advisedDose': isEmpty(_steroidAdvisedDose)?"0":_steroidAdvisedDose,
      'numberOfTimes': _steroidTimesDaySelectedItem.name,
      'effectiveDailyDose': isEmpty(_steroidEffectiveDailyDose)?"0":_steroidEffectiveDailyDose,
      'howManyDays': _steroidHowManyDays,
      'taken': _steroidTakenYes,//+"*"+_steroidTakenNo,
      'formulationOther': formulation,
      'brandNameOther': name,
      'actualMedicineOther': actualMedicine,
      'strengthOther': strength,
      'advisedDoseOther': adviseDose,
      'numberOfTimesOther': numberOfTime,
      'effectiveDailyDoseOther': effectiveDailyDose,
      'howManyDaysOther': howManyDays,
      'takenOther': taken,
      'remarksOther': remark,
      'remarks': _steroidRemark,
      'date': DateTime.now().toString(),
      'day': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };
    // print(data);
    // data = json.encode(datafinal);
    print("AA_S -- "+data.toString()); /*"https://utsarjantry.herokuapp.com"*/
    var response = await http.post(
      "$serverIP/users/doctor/addMedication",
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.statusCode);

    //final posts = json.decode(response.body);
    //print(posts);
    //print(response.statusCode);
    if (response.statusCode == 201) {
      final posts = json.decode(response.body);
      setState(() {
        print(posts);
        showToast(posts['message']);
        setState(() {
          loading = false;
        });
        if(username==patientId) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/patient', (Route<dynamic> route) => false);
          /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(BuildContext context) => PatientPage() ),
                ( Route<dynamic> route ) => false);*/
        }
      });
    } else {
      if (response.statusCode == 401) {
        setState(() {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Button moved to separate widget'),
            duration: Duration(seconds: 5),
          ));
        });
      } else {
        if (response.statusCode == 404) {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) => usernotfound(context));
          });
        }
      }
    }
  }

  bool isEmpty(String value){
    if(value==null||value=='null'||value=='NULL'||value.isEmpty||value.length==0){
      return true;
    }else{
      return false;
    }
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  Widget usernotfound(BuildContext context) {
    return Dialog(
      child: Container(
        height: 50,
        child: Text(
          AppLocalizations.of(context).noUserFound,
          // textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class OtherListItem {
  ListItem formulation;
  ListItem name;
  ListItem actualMedicine;
  ListItem strength;
  String adviseDose;
  ListItem numberOfTime;
  String effectiveDose;
  String takenOrNot;
  String other;

  OtherListItem(
      this.formulation,
      this.name,
      this.actualMedicine,
      this.strength,
      this.adviseDose,
      this.numberOfTime,
      this.effectiveDose,
      this.takenOrNot,
      this.other);
}

//Steroid
class ListBrandnametabletItem {
  int value;
  String name;

  ListBrandnametabletItem(this.value, this.name);
}

class ListTimesadayItem {
  int value;
  String name;

  ListTimesadayItem(this.value, this.name);
}

class ListSyrupStrengthItem {
  int value;
  String name;

  ListSyrupStrengthItem(this.value, this.name);
}

class ListTabletStrengthItem {
  int value;
  String name;

  ListTabletStrengthItem(this.value, this.name);
}

class ListActualmedicineItem {
  int value;
  String name;

  ListActualmedicineItem(this.value, this.name);
}

class ListBrandnameItem {
  int value;
  String name;

  ListBrandnameItem(this.value, this.name);
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

//other mediince

class ListBrandnametabletOtherItem {
  int value;
  String name;

  ListBrandnametabletOtherItem(this.value, this.name);
}

class ListBrandnamecapsuleOtherItem {
  int value;
  String name;

  ListBrandnamecapsuleOtherItem(this.value, this.name);
}

class ListTimesadayOtherItem {
  int value;
  String name;

  ListTimesadayOtherItem(this.value, this.name);
}

class ListSyrupStrengthOtherItem {
  int value;
  String name;

  ListSyrupStrengthOtherItem(this.value, this.name);
}

class ListTabletStrengthOtherItem {
  int value;
  String name;

  ListTabletStrengthOtherItem(this.value, this.name);
}

class ListActualmedicineOtherItem {
  int value;
  String name;

  ListActualmedicineOtherItem(this.value, this.name);
}

class ListBrandnameOtherItem {
  int value;
  String name;

  ListBrandnameOtherItem(this.value, this.name);
}

class ListOtherItem {
  int value;
  String name;

  ListOtherItem(this.value, this.name);
}
