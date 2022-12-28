import 'dart:convert';
import 'dart:io';

List<DoctorData> doctorDataListFromJson(String str) { 
  try {
    if (str != null && json.decode(str) != null && json.decode(str)["data"] != null) {         
      return new List<DoctorData>.from(json.decode(str)['data'].map((x) => DoctorData.fromJson(x)));
    } else
      return [];
  } catch (e) {   
    print(e);
  }
  return [];
}

String doctorDataListToJson(List<DoctorData> data) => json.encode(
  new List<dynamic>.from(data.map((x) => x.toJson()))
  );

DoctorData doctorDataFromJson(String str) => DoctorData.fromJson(json.decode(str)["data"]);

String doctorDataToJson(DoctorData data) => json.encode(data.toJson());

class DoctorData {
  String patientId;
  DateTime date;
  String day;
  int systolicBP;
  int diastolicBP;
  int relapse;
  double bodyWeight;
  double bodyHeight;
  double bmi;
  String category;
  String stage;
  String comments;
  File photo;
  String patientName;
  int medicineDosage;
  String age;
  String gender;
  double calculatedHeightSD;
  double calculatedWeightSD;
  double calculatedBMI;
  String monthsOnSet;
  String weightGraphColor;
  String heightGraphColor;
  String bmiGraphColor;
  String systolicBPGraphColor;
  String diastolicBPGraphColor;

  DoctorData({
    this.patientId,
    this.patientName,
    this.date,
    this.day,
    this.relapse,
    this.systolicBP,
    this.diastolicBP,
    this.bodyWeight,
    this.bodyHeight,
    this.bmi,
    this.category,
    this.stage,
    this.comments,
    this.photo,
    this.medicineDosage,
    this.age,
    this.gender,
    this.calculatedHeightSD,
    this.calculatedWeightSD,
    this.calculatedBMI,
    this.monthsOnSet,
    this.bmiGraphColor,
    this.heightGraphColor,
    this.weightGraphColor,
    this.systolicBPGraphColor,
    this.diastolicBPGraphColor
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    DoctorData doctorData;
    try {
      doctorData = new DoctorData(
        patientId: json["patientId"],
        patientName: json["patientName"],
        relapse: json["relapse"],
        date: json["date"] != null
            ? DateTime.parse(json["date"])
            : DateTime.now(),
        day: json["day"] ,
        systolicBP: json["systolicBP"]!=null? json["systolicBP"]:null,
        diastolicBP: json["diastolicBP"]!=null? json["diastolicBP"]:null,
        bodyWeight:
            json["bodyWeight"] != null ? json["bodyWeight"].toDouble() : null,
        bodyHeight:
            json["bodyHeight"] != null ? json["bodyHeight"].toDouble() : null,
        bmi: json["bmi"] != null ? json["bmi"].toDouble() : null,
        category: json["category"],
        stage: json["stage"],
        comments: json["comments"],
        medicineDosage: json["medicineDosage"],
        age: json["age"],
        gender: json['gender'],
        monthsOnSet: json['monthsOnSet'],
        calculatedHeightSD: json['calculatedHeightSD'] != null
            ? json["calculatedHeightSD"].toDouble()
            : 0,
        calculatedWeightSD: json['calculatedWeightSD'] != null
            ? json["calculatedWeightSD"].toDouble()
            : 0,
        calculatedBMI: json['calculatedBMI'] != null
            ? json["calculatedBMI"].toDouble()
            : 0,
        weightGraphColor: json['weightGraphColor'] ,
        heightGraphColor: json['heightGraphColor'] ,
        bmiGraphColor: json['bmiGraphColor']  ,
        systolicBPGraphColor: json['systolicBPGraphColor'],
        diastolicBPGraphColor: json['diastolicBPGraphColor']
        // bpCheck: BpCheck.fromJson(json["bpCheck"]),
        // photo: json["photo"],
      );
    } catch (e) {
      // print("typecast error");
      print(e);
    }   
    return doctorData;
  }

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "patientName": patientName,
        "relapse": relapse,
        "date": date.toString(),
        "day": day,
        "systolicBP": systolicBP,
        "diastolicBP": diastolicBP,
        "bodyWeight": bodyWeight,
        "bodyHeight": bodyHeight,
        "bmi": bmi,
        "category": category,
        "stage": stage,
        "comments": comments,
        // "photo": photo,
        "medicineDosage": medicineDosage,
        "age": age,
        "gender": gender,
        "calculatedWeightSD": calculatedWeightSD,
        "calculatedHeightSD": calculatedHeightSD,
        "calculatedBMI": calculatedBMI,
        " monthsOnSet": monthsOnSet,
        "weightGraphColor": weightGraphColor,
        "heightGraphColor": heightGraphColor,
        "bmiGraphColor": bmiGraphColor,
        "systolicBPGraphColor": systolicBPGraphColor,
        "diastolicBPGraphColor": diastolicBPGraphColor
        // "bpCheck": bpCheck.toJson(),
      };
}

// class BpCheck {
//   int systolicBP;
//   int diastolicBP;

//   BpCheck({
//     this.systolicBP,
//     this.diastolicBP,
//   });

//   factory BpCheck.fromJson(Map<String, dynamic> json) {
//     print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
//     print(json["systolicBP"]);
//     print(json["diastolicBP"]);
//     BpCheck bpCheck;
//     try {
//       if (json != null)
//         bpCheck = new BpCheck(
//           systolicBP: json["systolicBP"],
//           diastolicBP: json["diastolicBP"],
//         );
//     } catch (e) {
//       print("typecast error");
//       print(e);
//     }
//     print("12adsjghjffsdsdhga");
//     return bpCheck;
//   }
//   Map<String, dynamic> toJson() => {
//         "systolicBP": systolicBP,
//         "diastolicBP": diastolicBP,
//       };
// }
