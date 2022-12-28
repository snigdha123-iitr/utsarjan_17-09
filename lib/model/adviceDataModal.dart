import 'dart:convert';

List<Advice> adviceListFromJson(String str) => new List<Advice>.from(
    json.decode(str)["data"].map((x) => Advice.fromJson(x)));

String adviceListToJson(List<Advice> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

Advice adviceFromJson(String str) => Advice.fromJson(json.decode(str));

String adviceToJson(Advice data) => json.encode(data.toJson());

class Advice {
  String id;
  String advice;
  String patientId;
  String username;
  DateTime date;
  String patientName;
  String doctorName;
  String doctorId;

  Advice({
    this.id,
    this.advice,
    this.patientId,
    this.username,
    this.date,
    this.patientName,
    this.doctorName,
    this.doctorId,
  });

  factory Advice.fromJson(Map<String, dynamic> json) => Advice(
        id: json["id"],
        advice: json["advice"],
        patientId: json["patientId"],
        username: json["username"],
        date: DateTime.parse(json["date"]),
        patientName: json["patientName"],
        doctorName: json["doctorName"],
        doctorId: json["doctorMobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "advice": advice,
        "patientId": patientId,
        "username": username,
        "date": date.toString(),
        "patientName": patientName,
        "doctorName": doctorName,
        "doctorMobile": doctorId,
      };
}
