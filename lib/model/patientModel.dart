// To parse this JSON data, do
//
//     final patient = patientFromJson(jsonString);

import 'dart:convert';

//import 'listOfPatientsModel.dart';

List<Patient> patientListFromJson(String str) => new List<Patient>.from(
    json.decode(str)["data"].map((x) => Patient.fromJson(x)));

String patientListToJson(List<Patient> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

Patient patientFromJsonStatus(String str) => Patient.fromJson(json.decode(str));

Patient patientFromJson(String str) =>
    Patient.fromJson(json.decode(str)["data"]);
String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
  String patientId;
  String fcmToken;
  String name;
  String dob;
  String day;
  String age;
  String uhid;
  String address;
  String password;
  String email;
  String doctorMobile;
  String doctorName;
  bool status;
  String message;
  String optionalid;
  String category;
  String stage;
  String username;
  String currentAge;
  int relapse;
  String dateOfRegistration;
  String gender;
  String mobileNumber;
  List<PatientsData> patientData;
  AuthenticateData authenticateData;
  String monthsOnSet;
  int relapseCount;
  String ageInMonth;
  String ageOnSet;
  String dateOfOnset;
  String currentCategory;
  String currentStage;
  String previousCategory;
  String previousStage;

  bool authenticate;
  bool nephrosis;

  //int medicineDosage;
  // DateTime date;

  Patient(
      {this.patientId,
      this.name,
      this.dob,
      this.day,
      this.age,
      this.ageInMonth,
      this.uhid,
      this.address,
      this.password,
      this.email,
      this.doctorMobile,
      this.doctorName,
      this.status,
      this.message,
      this.optionalid,
      this.category,
      this.stage,
      this.username,
      this.relapse,
      this.patientData,
      // this.month,
      this.mobileNumber,
      this.gender,
      this.authenticateData,
      this.monthsOnSet,
      this.currentAge,
      this.relapseCount,
      this.dateOfRegistration,
      this.ageOnSet,
      this.dateOfOnset,
      this.currentCategory,
      this.currentStage,
      this.previousCategory,
      this.previousStage,
      this.fcmToken,
      this.authenticate,
      this.nephrosis,

      //this.medicineDosage,
      //this.date
      });

  factory Patient.fromJson(Map<String, dynamic> json) {
    // print("23456789066666666");
    // print(json["dob"]);
    //print(json["patientData"]);
    Patient patient;
    if (json != null)
      patient = new Patient(
          patientId: json["_id"],
          name: json["name"],
          dob: json["dob"],
          day: json['day'],
          age: json["age"],
          ageInMonth: json["ageInmMnth"],
          uhid: json["uhid"],
          address: json["address"],
          password: json["password"],
          email: json["email"],
          doctorMobile: json["doctorMobile"],
          doctorName: json["doctorName"],
          status: json["status"],
          message: json["message"],
          optionalid: json["optionalid"],
          category: json["category"],
          stage: json["stage"],
          username: json["username"],
          relapse: json["relapse"],
          // month: json["month"],
          mobileNumber: json["mobileNumber"],
          gender: json["gender"],
          patientData: (json["patientData"] == null)
              ? null
              : List<PatientsData>.from(
                  json["patientData"].map((x) => PatientsData.fromJson(x))),
          authenticateData: AuthenticateData.fromJson(json),
          monthsOnSet: json["monthsOnSet"],
          currentAge: json["currentAge"],
          // relapseCountForAYear: json["relapseCountForAYear"] == null
          //     ? null
          //     : RelapseCountForAYear.fromJson(json["relapseCountForAYear"]),
          relapseCount: json["relapseCountForAYear"],
          dateOfRegistration: json['dateOfRegistration'],
          ageOnSet: json['ageOnSet'],
          dateOfOnset: json['dateOfOnset'],
          currentCategory: json['currentCategory'],
          currentStage: json['currentStage'],
          previousCategory: json['previousCategory'],
          previousStage: json['previousStage'],
          fcmToken:json['fcmToken'],
        authenticate: json["authenticate"] == null ? false : json["authenticate"],
        nephrosis: json["nephrosis"] == null ? false : json["nephrosis"],
          // date: DateTime.parse(json["date"]),
          // medicineDosage: int.parse(json["medicineDosage"]),
          );
    // print("dfjsdhfsdhffsf");
    // print(patient.authenticateData.toJson());
    return patient;
  }
  Map<String, dynamic> toJson() => {
        "_id": patientId,
        "name": name,
        "dob": dob,
        "day": day,
        "age": age,
        "ageInMonth": ageInMonth,
        "uhid": uhid,
        "address": address,
        "password": password,
        "email": email,
        "doctorMobile": doctorMobile,
        "doctorName": doctorName,
        "status": status,
        "message": message,
        "dob": dob,
        "uhid": uhid,
        "optionalid": optionalid,
        "category": category,
        "stage": stage,
        "username": username,
        "relapse": relapse,
        // "month": month,
        "mobileNumber": mobileNumber,
        "gender": gender,
        "patientData": patientData == null
            ? null
            : List<dynamic>.from(patientData.map((x) => x.toJson())),
        "authenticateData":
            authenticateData == null ? null : authenticateData.toJson(),
        "monthsOnSet": monthsOnSet,
        "currentAge": currentAge,
        // "relapseCountForAYear":
        //     relapseCountForAYear == null ? null : relapseCountForAYear.toJson(),
        "relapseCountForAYear": relapseCount,
        'dateOfRegistration': dateOfRegistration,
        'ageOnSet': ageOnSet,
        'dateOfOnset': dateOfOnset,
        'currentCategory': currentCategory,
        'currentStage': currentStage,
        'previousCategory': previousCategory,
        'previousStage': previousStage,
        'fcmToken':fcmToken,
        "authenticate": authenticate,
        "nephrosis": nephrosis,
        //"medicineDosage": medicineDosage,
        //"date": date.toString(),
      };
}

class PatientsData {
  String patientId;
  String patientName;
  DateTime date;
  String day;
  int urine;
  int medicineDosage;
  bool infectionStatus;
  String comments;
  //File photo;
  int relapse;

  PatientsData({
    this.patientId,
    this.patientName,
    this.date,
    this.day,
    this.urine,
    this.medicineDosage,
    this.infectionStatus,
    this.comments,
    // this.photo,
    this.relapse,
  });

  factory PatientsData.fromJson(Map<String, dynamic> json) {
    // print("3456790000000");
    // print(json["medicineDosage"]);
    PatientsData patientsData = new PatientsData(
      patientId: json["patientId"],
      patientName: json["patientName"],
      date: DateTime.parse(json["date"]),
      day: json["day"],
      urine: json["urine"],
      medicineDosage: int.parse(json["medicineDosage"]),
      infectionStatus: json["infectionStatus"],
      comments: json["comments"] != null ? json["comments"] : "",
      // photo: json["photo"],
      relapse: json["relapse"],
    );
    return patientsData;
  }

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "patientName": patientName,
        "date": date.toString(),
        "day": day,
        "urine": urine,
        "medicineDosage": medicineDosage,
        "infectionStatus": infectionStatus,
        "comments": comments,
        //"photo": photo,
        "relapse": relapse,
      };
}

class AuthenticateData {

  /*bool historyOfHighBloodPressurePriorToNephrosis;
  bool havingAMotherOrSisterWhoHadNephrosis;
  bool aHistoryOfObesity;
  bool aHistoryOfNephrosis;
  bool historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis;*/

  String historyBirthdayWeight;
  String historyBirthdayPreterm;
  String historyFamilySyndrome;
  String historyFamilyKidneyDisease;
  String historyPastAsthma;
  String historyPastAtopy;
  String historyPastAllergicRhinitis;

  AuthenticateData({
    this.historyBirthdayWeight,
    this.historyBirthdayPreterm,
    this.historyFamilySyndrome,
    this.historyFamilyKidneyDisease,
    this.historyPastAsthma,
    this.historyPastAtopy,
    this.historyPastAllergicRhinitis,
  });

  factory AuthenticateData.fromJson(Map<String, dynamic> json) =>
      AuthenticateData(
        historyBirthdayWeight: json["historyBirthdayWeight"] == null ? "" : json["historyBirthdayWeight"],
        historyBirthdayPreterm: json["historyBirthdayPreterm"] == null ? "" : json["historyBirthdayPreterm"],
        historyFamilySyndrome: json["historyFamilySyndrome"] == null ? "" : json["historyFamilySyndrome"],
        historyFamilyKidneyDisease: json["historyFamilyKidneyDisease"] == null ? "" : json["historyFamilyKidneyDisease"],
        historyPastAsthma: json["historyPastAsthma"] == null ? "" : json["historyPastAsthma"],
        historyPastAtopy: json["historyPastAtopy"] == null ? "" : json["historyPastAtopy"],
        historyPastAllergicRhinitis: json["historyPastAllergicRhinitis"] == null ? "" : json["historyPastAllergicRhinitis"],
      );

  Map<String, dynamic> toJson() => {
        "historyBirthdayWeight": historyBirthdayWeight,
        "historyBirthdayPreterm": historyBirthdayPreterm,
        "historyFamilySyndrome": historyFamilySyndrome,
        "historyFamilyKidneyDisease": historyFamilyKidneyDisease,
        "historyPastAsthma": historyPastAsthma,
        "historyPastAtopy": historyPastAtopy,
        "historyPastAllergicRhinitis": historyPastAllergicRhinitis,
      };
}

class RelapseCountForAYear {
  int relapse0;
  int relapse1;
  int relapse2;
  int relapse3;

  RelapseCountForAYear({
    this.relapse0,
    this.relapse1,
    this.relapse2,
    this.relapse3,
  });

  factory RelapseCountForAYear.fromJson(Map<String, dynamic> json) {
    RelapseCountForAYear relapse = RelapseCountForAYear(
      relapse0: json["relapse0"] == null ? null : json["relapse0"],
      relapse1: json["relapse1"] == null ? null : json["relapse1"],
      relapse2: json["relapse2"] == null ? null : json["relapse2"],
      relapse3: json["relapse3"] == null ? null : json["relapse3"],
    );
    return relapse;
  }
  Map<String, dynamic> toJson() => {
        "relapse0": relapse0,
        "relapse1": relapse1,
        "relapse2": relapse2,
        "relapse3": relapse3,
      };
}
