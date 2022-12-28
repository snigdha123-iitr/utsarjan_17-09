import 'dart:convert';
import 'dart:core';

List<PatientHistory> patientHistoryDataFromJson(String str) =>
    new List<PatientHistory>.from(
        json.decode(str)["data"].map((x) => PatientHistory.fromJson(x)));

String patientHistoryDataToJson(List<PatientHistory> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

PatientHistory patientDataFromJson(String str) =>
    PatientHistory.fromJson(json.decode(str));

String patientDataToJson(PatientHistory data) => json.encode(data.toJson());

class PatientHistory {
  String day;
  String patientId;
  dynamic urineProtein;
  dynamic medicineDosage;
  dynamic systolicBP;
  dynamic diastolicBP;
  dynamic bodyHeight;
  dynamic bodyWeight;
  DateTime date;
  double bmi;
  dynamic urineProteinStatus;
  dynamic patientDataFireStatus;
  dynamic doctorDataFireStatus;
  dynamic bodyHeightStatus;
  dynamic bodyWeightStatus;
  dynamic systolicBPStatus;
  dynamic diastolicBPStatus;
  dynamic bmiStatus;
  String comments;
  String category;
  String weightGraphColor;
  String heightGraphColor;
  String bmiGraphColor;
  String systolicBPGraphColor;
  String diastolicBPGraphColor;

  PatientHistory(
      {this.day,
      this.patientId,
      this.urineProtein,
      this.medicineDosage,
      this.diastolicBP,
      this.systolicBP,
      this.bodyHeight,
      this.bodyWeight,
      this.comments,
      this.date,
      this.bmi,
      this.urineProteinStatus,
      this.patientDataFireStatus,
      this.doctorDataFireStatus,
      this.bodyWeightStatus,
      this.bodyHeightStatus,
      this.systolicBPStatus,
      this.diastolicBPStatus,
      this.bmiStatus,
      this.category,
        this.bmiGraphColor,
        this.heightGraphColor,
        this.weightGraphColor,
        this.systolicBPGraphColor,
        this.diastolicBPGraphColor});

  factory PatientHistory.fromJson(Map<dynamic, dynamic> json) {
    PatientHistory patientData = new PatientHistory(
      patientId: json["patientId"],
      date: DateTime.parse(json["date"]),
      day: json['day'],
      urineProtein: json["urineProtein"] != null ? json["urineProtein"] : null,
      medicineDosage:
          json["medicineDosage"] != null ? json["medicineDosage"] : null,
      systolicBP: json["systolicBP"] != null ? json["systolicBP"] : null,
      diastolicBP: json["diastolicBP"] != null ? json["diastolicBP"] : null,
      bodyHeight: json["bodyHeight"] != null ? json["bodyHeight"] : null,
      bodyWeight: json["bodyWeight"] != null ? json["bodyWeight"] : null,
      bmi: json["bmi"] != null ? json["bmi"].toDouble() : null,
      urineProteinStatus: json['urineProteinStatus'],
      patientDataFireStatus: json['patientDataFireStatus'],
      doctorDataFireStatus: json['doctorDataFireStatus'],
      bodyWeightStatus: json['bodyWeightStatus'],
      bodyHeightStatus: json['bodyHeightStatus'],
      systolicBPStatus: json['systolicBPStatus'],
      diastolicBPStatus: json['diastolicBPStatus'],
      bmiStatus: json['bmiStatus'],
      comments: json["comments"] != null ? json["comments"] : '',
        category: json['category'] ,
        weightGraphColor: json['weightGraphColor'] ,
        heightGraphColor: json['heightGraphColor'] ,
        bmiGraphColor: json['bmiGraphColor']  ,
        systolicBPGraphColor: json['systolicBPGraphColor'],
        diastolicBPGraphColor: json['diastolicBPGraphColor'],
    );
    return patientData;
  }
  Map<dynamic, dynamic> toJson() => {
        'patientId': patientId,
        'date': date.toString(),
        "day": day,
        'urineProtine': urineProtein,
        'medicineDosage': medicineDosage,
        'systolicBP': systolicBP,
        'diastolicBP': diastolicBP,
        'bodyHeight': bodyHeight,
        'bodyWeight': bodyWeight,
        'bmi': bmi,
        'urineProteinStatus': urineProteinStatus,
        'patientDataFireStatus': patientDataFireStatus,
        'doctorDataFireStatus': doctorDataFireStatus,
        'bodyHeightStatus': bodyHeightStatus,
        'bodyWeightStatus': bodyWeightStatus,
        'systolicBPStatus': systolicBPStatus,
        'diastolicBPStatus': diastolicBPStatus,
        'bmiStatus': bmiStatus,
        'comments': comments,
        'category': category,
    "weightGraphColor": weightGraphColor,
    "heightGraphColor": heightGraphColor,
    "bmiGraphColor": bmiGraphColor,
    "systolicBPGraphColor": systolicBPGraphColor,
    "diastolicBPGraphColor": diastolicBPGraphColor,
      };
}
