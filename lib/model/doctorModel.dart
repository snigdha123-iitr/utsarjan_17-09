import 'dart:convert';

List<Doctor> doctorListFromJson(String str) {
  List<Doctor> doctors;
  if (str != null &&
      json.decode(str) != null &&
      json.decode(str)['data'] != null)
    doctors = new List<Doctor>.from(
        json.decode(str)["data"].map((x) => Doctor.fromJson(x)));
  return doctors;
}

String doctorListToJson(List<Doctor> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

Doctor doctorFromJsonStatus(String str) => Doctor.fromJson(json.decode(str));

Doctor doctorFromJson(String str) {
  if (str != null && json.decode(str) != null)
    return Doctor.fromJson(json.decode(str)["data"]);
  else
    return null;
}

String doctorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
  String name;
  String fcmToken;
  String mobile;
  String password;
  String speciality;
  String email;
  String hospital;
  bool status;
  String message;

  Doctor({
    this.name,
    this.fcmToken,
    this.mobile,
    this.password,
    this.speciality,
    this.email,
    this.hospital,
    this.status,
    this.message,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    Doctor doctor;
    if (json != null)
      doctor = new Doctor(
        name: json["name"],
        fcmToken:json['fcmToken'],
        mobile: json["mobile"],
        password: json["password"],
        speciality: json["speciality"],
        email: json["email"],
        hospital: json["hospital"],
        message: json["message"],
        status: json["status"],
      );
    return doctor;
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        'fcmToken':fcmToken,
        "mobile": mobile,
        "password": password,
        "speciality": speciality,
        "email": email,
        "hospital": hospital,
        "message": message,
        "status": status,
      };
}
