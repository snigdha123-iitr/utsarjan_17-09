import 'dart:convert';
import 'dart:io';

List<TestNotification> testNotificationsListFromJson(String str) =>
    new List<TestNotification>.from(       
        json.decode(str)["data"].map((x) => TestNotification.fromJson(x)));

String testNotificationsListToJson(List<TestNotification> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

TestNotification testNotificationsFromJson(String str) =>
    TestNotification.fromJson(json.decode(str));

String testNotificationsToJson(TestNotification data) => json.encode(data.toJson());

class TestNotification {
  String patientId;
  DateTime date;

  bool weight;
  bool height;
  bool bp;

  bool cbc;
  bool kft;
  bool lft;
  bool cholestrol;
  bool albumin;
  bool creatinine;
  bool sodium;
  bool bloodSugar;
  bool hemoglobin;
  bool immunoglobulin;
  bool tacrolimusTroughLevel;
  bool cyclosporineTroughLevel;
  bool cd19Percentage;
  bool hiv;
  bool antiHB;

  bool urineRoutine;
  bool spotUrineRoutine;
  bool urineAndCreatinine;

  bool forCataract;
  bool intraocularPressure;

  String additionalTest = "";
  String comment = "";

  TestNotification({
    this.patientId,
    this.date,

    this.weight,
    this.height,
    this.bp,

    this.forCataract,
    this.intraocularPressure,

    this.cbc,
    this.kft,
    this.creatinine,
    this.sodium,
    this.lft,
    this.albumin,
    this.cholestrol,
    this.bloodSugar,
    this.hemoglobin,
    this.immunoglobulin,
    this.tacrolimusTroughLevel,
    this.cyclosporineTroughLevel,
    this.cd19Percentage,
    this.hiv,
    this.antiHB,

    this.urineRoutine,
    this.spotUrineRoutine,
    this.urineAndCreatinine,

    this.additionalTest,
    this.comment

    // this.photo
  });

  // File photo;

  factory TestNotification.fromJson(Map<dynamic, dynamic> json) {   
     
    TestNotification testNotifications = new TestNotification(
      patientId: json["patientId"],     
      date: DateTime.parse(json["date"]),

      weight: json['weight'],
      height: json['height'],
      bp: json['bp'],

      cbc: json['cbc'],
      kft:json["kft"],
      lft: json["lft"],
      cholestrol: json["cholestrol"],
      sodium: json["sodium"],//  != null ? json["sodium"] : false,
      creatinine: json["creatinine"],     
      albumin: json["albumin"],

      bloodSugar: json["bloodSugar"],
      hemoglobin: json["hemoglobin"],
      immunoglobulin: json["immunoglobulin"],
      tacrolimusTroughLevel: json["tacrolimusTroughLevel"],
      cyclosporineTroughLevel: json["cyclosporineTroughLevel"],
      cd19Percentage: json["cd19Percentage"],
      hiv: json["hiv"],
      antiHB: json["antiHB"],

      urineRoutine: json["urineRoutine"],     
      urineAndCreatinine: json["urineAndCreatinine"],
      spotUrineRoutine: json["spotUrineRoutine"],

      forCataract: json["forCataract"],
      intraocularPressure: json["intraocularPressure"],

      additionalTest: json["additionalTest"],
      comment: json["comment"],

      // photo: json["photo"],     
    );
    return testNotifications;
  }
  Map<dynamic, dynamic> toJson() => {
        "patientId": patientId,     
        "date": date.toString(),

        "weight": weight,
        "height": height,
        "bp": bp,

        "cbc": cbc,
        'kft': kft,
        "lft": lft,
        "cholestrol": cholestrol,
        "creatinine": creatinine,
        "albumin": albumin,
        "sodium": sodium,

        "bloodSugar": bloodSugar,
        "hemoglobin": hemoglobin,
        "immunoglobulin": immunoglobulin,
        "tacrolimusTroughLevel": tacrolimusTroughLevel,
        "cyclosporineTroughLevel": cyclosporineTroughLevel,
        "cd19Percentage": cd19Percentage,
        "hiv": hiv,
        "antiHB": antiHB,

        "urineRoutine": urineRoutine,
        "urineAndCreatinine": urineAndCreatinine,
        "spotUrineRoutine": spotUrineRoutine,

        "forCataract": forCataract,
        "intraocularPressure": intraocularPressure,

        "additionalTest": additionalTest,
        "comment": comment,

        // "photo": photo,       
        
      };
}
