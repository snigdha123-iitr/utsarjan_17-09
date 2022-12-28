// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
  RelapseCountForAYear relapseCountForAYear;
  bool status;
  bool historyOfHighBloodPressurePriorToNephrosis;
  bool havingAMotherOrSisterWhoHadNephrosis;
  bool aHistoryOfObesity;
  bool aHistoryOfNephrosis;
  bool historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis;
  String id;
  String name;
  String username;
  String address;
  String age;
  String email;
  String doctorMobile;
  String doctorName;
  DateTime dob;
  String category;
  String stage;
  String currentStage;
  int relapse;
  String doctorHospital;
  String gender;

  String monthsOnSet;

  TestModel({
    this.relapseCountForAYear,
    this.status,
    this.historyOfHighBloodPressurePriorToNephrosis,
    this.havingAMotherOrSisterWhoHadNephrosis,
    this.aHistoryOfObesity,
    this.aHistoryOfNephrosis,
    this.historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis,
    this.id,
    this.name,
    this.username,
    this.address,
    this.age,
    this.email,
    this.doctorMobile,
    this.doctorName,
    this.dob,
    this.category,
    this.stage,
    this.currentStage,
    this.relapse,
    this.doctorHospital,
    this.gender,
    this.monthsOnSet,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        relapseCountForAYear:
            RelapseCountForAYear.fromJson(json["relapseCountForAYear"]),
        status: json["status"],
        historyOfHighBloodPressurePriorToNephrosis:
            json["historyOfHighBloodPressurePriorToNephrosis"],
        havingAMotherOrSisterWhoHadNephrosis:
            json["havingAMotherOrSisterWhoHadNephrosis"],
        aHistoryOfObesity: json["aHistoryOfObesity"],
        aHistoryOfNephrosis: json["aHistoryOfNephrosis"],
        historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis:
            json["historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis"],
        id: json["_id"],
        name: json["name"],
        username: json["username"],
        address: json["address"],
        age: json["age"],
        email: json["email"],
        doctorMobile: json["doctorMobile"],
        doctorName: json["doctorName"],
        dob: DateTime.parse(json["dob"]),
        category: json["category"],
        stage: json["stage"],
        currentStage: json["currentStage"],
        relapse: json["relapse"],
        doctorHospital: json["doctorHospital"],
        gender: json["gender"],
        monthsOnSet: json["monthsOnSet"],
      );

  Map<String, dynamic> toJson() => {
        "relapseCountForAYear": relapseCountForAYear.toJson(),
        "status": status,
        "historyOfHighBloodPressurePriorToNephrosis":
            historyOfHighBloodPressurePriorToNephrosis,
        "havingAMotherOrSisterWhoHadNephrosis":
            havingAMotherOrSisterWhoHadNephrosis,
        "aHistoryOfObesity": aHistoryOfObesity,
        "aHistoryOfNephrosis": aHistoryOfNephrosis,
        "historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis":
            historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis,
        "_id": id,
        "name": name,
        "username": username,
        "address": address,
        "age": age,
        "email": email,
        "doctorMobile": doctorMobile,
        "doctorName": doctorName,
        "dob": dob.toIso8601String(),
        "category": category,
        "stage": stage,
        "currentStage": currentStage,
        "relapse": relapse,
        "doctorHospital": doctorHospital,
        "gender": gender,
        "monthsOnSet": monthsOnSet,
      };
}

class PatientData {
  String id;
  DateTime date;
  int relapse;
  String medicineDosage;
  String extraComments;

  PatientData({
    this.id,
    this.date,
    this.relapse,
    this.medicineDosage,
    this.extraComments,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
        id: json["_id"],
        date: DateTime.parse(json["date"]),
        relapse: json["relapse"],
        medicineDosage: json["medicineDosage"],
        extraComments: json["extraComments"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date": date.toIso8601String(),
        "relapse": relapse,
        "medicineDosage": medicineDosage,
        "extraComments": extraComments,
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

  factory RelapseCountForAYear.fromJson(Map<String, dynamic> json) =>
      RelapseCountForAYear(
        relapse0: json["relapse0"],
        relapse1: json["relapse1"],
        relapse2: json["relapse2"],
        relapse3: json["relapse3"],
      );

  Map<String, dynamic> toJson() => {
        "relapse0": relapse0,
        "relapse1": relapse1,
        "relapse2": relapse2,
        "relapse3": relapse3,
      };
}
