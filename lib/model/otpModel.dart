import 'dart:convert';

Otp otpFromJson(String str) => Otp.fromJson(json.decode(str));

String otpToJson(Otp data) => json.encode(data.toJson());

class Otp {
  String username;
  String email;
  String pincode;
  bool status;
  String data;
  String message;
  String password;

  Otp(
      {this.username,
      this.email,
      this.pincode,
      this.message,
      this.status,
      this.data,
      this.password
      });

  factory Otp.fromJson(Map<String, dynamic> json) => new Otp(
      username: json["username"],
      email: json["email"],
      pincode: json["pincode"],
      message: json["message"],
      data: json["data"],
      status: json["status"],
      password:json['password']
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "pincode": pincode,
        "password": password,
        "data": data,
        "status": status,
        "message": message,
      };
}
