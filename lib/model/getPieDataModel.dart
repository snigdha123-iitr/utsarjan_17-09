// To parse this JSON data, do
//
//     final pieData = pieDataFromJson(jsonString);

import 'dart:convert';

PieData pieDataFromJson(String str) {
  if (str != null && json.decode(str) != null)
    return PieData.fromJson(json.decode(str)["data"]);
  else
    return null;
}

String pieDataToJson(PieData data) => json.encode(data.toJson());

class PieData {
  int bmiBelowSDPatients;
  int heightBelowSDPatients;
  int weightBelowSDPatients;
  int highSystolicBpPatients;
  int highDiastolicPatients;
  //String username;

  PieData({
    this.bmiBelowSDPatients,
    this.heightBelowSDPatients,
    this.weightBelowSDPatients,
    this.highSystolicBpPatients,
    this.highDiastolicPatients,
  });

  factory PieData.fromJson(Map<String, dynamic> json) => PieData(
        bmiBelowSDPatients: json["BMIBelowSDPatients"] == null
            ? null
            : json["BMIBelowSDPatients"],
        heightBelowSDPatients: json["heightBelowSDPatients"] == null
            ? null
            : json["heightBelowSDPatients"],
        weightBelowSDPatients: json["weightBelowSDPatients"] == null
            ? null
            : json["weightBelowSDPatients"],
        highSystolicBpPatients: json["highSystolicBpPatients"] == null
            ? null
            : json["highSystolicBpPatients"],
        highDiastolicPatients: json["highDiastolicPatients"] == null
            ? null
            : json["highDiastolicPatients"],
      );

  Map<String, dynamic> toJson() => {
        "BMIBelowSDPatients": bmiBelowSDPatients,
        "heightBelowSDPatients": heightBelowSDPatients,
        "weightBelowSDPatients": weightBelowSDPatients,
        "highSystolicBpPatients": highSystolicBpPatients,
        "highDiastolicPatients": highDiastolicPatients,

        //"username":username,
      };
}
