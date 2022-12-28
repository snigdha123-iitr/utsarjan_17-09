import 'dart:convert';

List<Notifications> notificationsListFromJson(String str) =>
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

  Notifications({
    this.notification,
    this.patientId,
    this.username,
    this.date,
    this.patientName,
    this.doctorName,
    this.doctorId,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        notification: json["notification"],
        patientId: json["patientId"],
        username: json["username"],
        date: DateTime.parse(json["date"]),
        patientName: json["patientName"],
        doctorName: json["doctorName"],
        doctorId: json["doctorMobile"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification,
        "patientId":patientId,
        "username": username,
        "date": date.toString(),
        "patientName": patientName,
        "doctorName":doctorName,
        "doctorMobile":doctorId,
      };
}
