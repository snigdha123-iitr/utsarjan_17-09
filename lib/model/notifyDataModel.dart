// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

List<Notifications> notificationsListFromJson(String str) =>

//   if (str != null &&
//       json.decode(str) != null &&
//       json.decode(str)["data"] != null)
//     return new List<Notifications>.from(json
//         .decode(str)["data"]["patientNotifcation"]
//         .map((x) => Notifications.fromJson(x)));
//   else return [];
// }

    new List<Notifications>.from(
        json.decode(str)["data"].map((x) => Notifications.fromJson(x)));

String notificationsListToJson(List<Notifications> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  String notification;
  String patientId;
  String username;
  DateTime date;
  String patientName;
  String doctorName;
  String doctorId;
  String photo;
  String tests;
  DataModel patientDetail;
  DataModel doctorDetail;
  DataModel medicationDetail;

  Notifications({
    this.notification,
    this.patientId,
    this.username,
    this.date,
    this.patientName,
    this.doctorName,
    this.doctorId,
    this.photo,
    this.tests,
    this.patientDetail,
    this.doctorDetail,
    this.medicationDetail
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        notification: json["notification"],
        patientId: json["patientId"],
        username: json["username"],
        date: DateTime.parse(json["date"]),
        patientName: json["patientName"],
        doctorName: json["doctorName"],
        doctorId: json["doctorMobile"],
        photo: json['photo']!=null?json['photo']:'',
        tests: json['tests']!=null?json['tests']:'',
        patientDetail: json['patientDetail'] == null ? null : DataModel.fromJson(json['patientDetail'] as Map<String, dynamic>),
        doctorDetail: json['doctorDetail'] == null ? null : DataModel.fromJson(json['doctorDetail'] as Map<String, dynamic>),
        medicationDetail: json['medicationDetail'] == null ? null : DataModel.fromJson(json['medicationDetail'] as Map<String, dynamic>)
      );

  Map<String, dynamic> toJson() => {
        "notification": notification,
        "patientId":patientId,
        "username": username,
        "date": date.toString(),
        "patientName": patientName,
        "doctorName":doctorName,
        "doctorMobile":doctorId,
        'photo':photo,
        'tests':tests,
        'patientDetail':patientDetail,
        'doctorDetail':doctorDetail,
        'medicationDetail':medicationDetail
      };
}

class DataModel {

  String name;
  String uhid;
  String age;
  String gender;
  String mobile;
  String speciality;
  String hospital;

  String formulation;
  String brandName;
  String actualMedicine;
  String strength;
  int advisedDose;
  String numberOfTimes;
  int effectiveDailyDose;
  int howManyDays;
  String taken;
  String remarks;
  String formulationOther;
  String brandNameOther;
  String actualMedicineOther;
  String strengthOther;
  String advisedDoseOther;
  String numberOfTimesOther;
  String effectiveDailyDoseOther;
  String howManyDaysOther;
  String takenOther;
  String remarksOther;

  DataModel({
    this.name,
    this.uhid,
    this.age,
    this.gender,
    this.mobile,
    this.speciality,
    this.hospital,

    this.formulation,
    this.brandName,
    this.actualMedicine,
    this.strength,
    this.advisedDose,
    this.numberOfTimes,
    this.effectiveDailyDose,
    this.howManyDays,
    this.taken,
    this.remarks,
    this.formulationOther,
    this.brandNameOther,
    this.actualMedicineOther,
    this.strengthOther,
    this.advisedDoseOther,
    this.numberOfTimesOther,
    this.effectiveDailyDoseOther,
    this.howManyDaysOther,
    this.takenOther,
    this.remarksOther,

  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    name: json["name"],
    uhid: json["uhid"],
    age: json["age"],
    gender: json["gender"],
    mobile: json["mobile"],
    speciality: json["speciality"],
    hospital: json["hospital"],

    formulation: json["formulation"],
    brandName: json["brandName"],
    actualMedicine: json["actualMedicine"],
    strength: json["strength"],
    advisedDose: json["advisedDose"],
    numberOfTimes: json["numberOfTimes"],
    effectiveDailyDose: json["effectiveDailyDose"],
    howManyDays: json["howManyDays"],
    taken: json["taken"],
    remarks: json["remarks"],
    formulationOther: json["formulationOther"],
    brandNameOther: json["brandNameOther"],
    actualMedicineOther: json["actualMedicineOther"],
    strengthOther: json["strengthOther"],
    advisedDoseOther: json["advisedDoseOther"],
    numberOfTimesOther: json["numberOfTimesOther"],
    effectiveDailyDoseOther: json["effectiveDailyDoseOther"],
    howManyDaysOther: json["howManyDaysOther"],
    takenOther: json["takenOther"],
    remarksOther: json["remarksOther"],

  );

  Map<String, dynamic> toJson() => {

    "name": name,
    "uhid": uhid,
    "age": age,
    "gender": gender,
    "mobile": mobile,
    "speciality": speciality,
    "hospital": hospital,

    "formulation": formulation,
    "brandName": brandName,
    "actualMedicine": actualMedicine,
    "strength": strength,
    "advisedDose": advisedDose,
    "numberOfTimes": numberOfTimes,
    "effectiveDailyDose": effectiveDailyDose,
    "howManyDays": howManyDays,
    "taken": taken,
    "remarks": remarks,
    "formulationOther": formulationOther,
    "brandNameOther": brandNameOther,
    "actualMedicineOther": actualMedicineOther,
    "strengthOther": strengthOther,
    "advisedDoseOther": advisedDoseOther,
    "numberOfTimesOther": numberOfTimesOther,
    "effectiveDailyDoseOther": effectiveDailyDoseOther,
    "howManyDaysOther": howManyDaysOther,
    "takenOther": takenOther,
    "remarksOther": remarksOther,

  };
}
