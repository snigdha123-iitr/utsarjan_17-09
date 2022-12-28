// To parse this JSON data, do
//
//     final PatientData = PatientDataFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

List<PatientData> patientDataListFromJson(String str) =>
    new List<PatientData>.from(       
        json.decode(str)["data"].map((x) => PatientData.fromJson(x)));

String patientDataListToJson(List<PatientData> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

PatientData patientDataFromJson(String str) =>
    PatientData.fromJson(json.decode(str));

String patientDataToJson(PatientData data) => json.encode(data.toJson());

class PatientData {
  String patientId;
  String patientName;
  DateTime date;
  String day;
  int urineProtein;
  double medicineDosage;
  bool infectionStatus;
  String comments;
  //File photo;
  String sos;

  String formulation;
  String brandName;
  String strength;
  String advisedDose;
  String numberOfTime;
  String dailyDose;

  PatientData({
    this.patientId,
    this.patientName,
    this.date,
    this.day,
    this.urineProtein,
    this.medicineDosage,
    this.infectionStatus,
    this.comments,
    //this.photo,
    this.sos,
    this.formulation,
    this.brandName,
    this.strength,
    this.advisedDose,
    this.numberOfTime,
    this.dailyDose,
  });

  factory PatientData.fromJson(Map<dynamic, dynamic> json) {   
     
    PatientData patientData = new PatientData(
      patientId: json["patientId"],
      patientName: json['patientName'],
      date: DateTime.parse(json["date"]),
      day:json["day"],
      urineProtein: json["urineProtein"],
      medicineDosage: json["medicineDosage"] != null ? json["medicineDosage"] == "NaN" ? null : double.parse(json["medicineDosage"]) : null,
      infectionStatus: json["infectionStatus"] != null ? json["infectionStatus"] : false,
      comments: json["comments"],
      //photo: json["photo"],
      sos: json["sos"],
      formulation: json["formulation"],
      brandName: json["brandName"],
      strength: json["strength"],
      advisedDose: json["advisedDose"],
      numberOfTime: json["numberOfTime"],
      dailyDose: json["dailyDose"],
    );
    return patientData;
  }
  Map<dynamic, dynamic> toJson() => {
        "patientId": patientId,
        "patientName": patientName,
        "date": date.toString(),
        'day': day,
        "urine": urineProtein,
        "medicineDosage": medicineDosage,
        "infectionStatus": infectionStatus,
        "comments": comments,
        //"photo": photo,
        "sos": sos,
        "formulation": formulation,
        "brandName": brandName,
        "strength": strength,
        "advisedDose": advisedDose,
        "numberOfTime": numberOfTime,
        "dailyDose": dailyDose,
      };
}
