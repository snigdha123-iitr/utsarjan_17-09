// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String username;
  String name;
  //String mobile;
  String password;
  bool status;
  String data;
  String message;
  String fcmToken;
  // String mobileNumber;

  Login(
      {this.username,
      this.password,
      this.message,
      this.status,
      this.data,
      this.name,
      this.fcmToken,
      // this.mobileNumber,
      //this.mobile
      });

  factory Login.fromJson(Map<String, dynamic> json) => new Login(
      username: json["username"],
      name: json["name"],
      //mobile: json["mobile"],
      password: json["password"],
      message: json["message"],
      data: json["data"],
      status: json["status"],
      fcmToken: json['fcmToken']
      // mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        //"mobile": mobile,
        "password": password,
        "data": data,
        "status": status,
        "message": message,
        'fcmToken':fcmToken
        // "mobileNumber":mobileNumber,
      };
}
