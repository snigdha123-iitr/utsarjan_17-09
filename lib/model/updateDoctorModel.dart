// To parse this JSON data, do
//
//     final updateDoctorData = updateDoctorDataFromJson(jsonString);

import 'dart:convert';

UpdateDoctorData updateDoctorDataFromJson(String str) =>
    UpdateDoctorData.fromJson(json.decode(str));

String updateDoctorDataToJson(UpdateDoctorData data) =>
    json.encode(data.toJson());

class UpdateDoctorData {
  String patientId;
  String doctorMobile;
  String doctorName;
  String doctorHospital;

  UpdateDoctorData({
    this.patientId,
    this.doctorMobile,
    this.doctorName,
    this.doctorHospital,
  });

  factory UpdateDoctorData.fromJson(Map<String, dynamic> json) =>
      UpdateDoctorData(
        patientId: json["patientId"],
        doctorMobile: json["doctorMobile"],
        doctorName: json["doctorName"],
        doctorHospital: json["doctorHospital"],
      );

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "doctorMobile": doctorMobile,
        "doctorName": doctorName,
        "doctorHospital": doctorHospital,
      };
}
