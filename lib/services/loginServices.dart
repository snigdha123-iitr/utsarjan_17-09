import 'dart:async' show Future;
import 'package:utsarjan/model/loginModel.dart';
import 'package:utsarjan/model/otpModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import './globalData.dart';

Future loginUser(Login login) async {
  try {
    String url = '$serverIP/users/login';
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: loginToJson(login));
    print("AA_S" + response.body);
    return loginFromJson(response.body);
  } catch (e) {
    print("Unable to login " + e.toString());
    throw e;
  }
}

Future sendOtp(Otp otp) async {
  try {
    String url = '$serverIP/users/sendOtp';
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: otpToJson(otp));  
    return otpFromJson(response.body);
  } catch (e) {
    print("Unable to login " + e.toString());
    throw e;
  }
}


Future updatePassword(Otp otp) async {
  try {
    String url = '$serverIP/users/updatePassword';
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: otpToJson(otp));  
    return otpFromJson(response.body);
  } catch (e) {
    print("Unable to login " + e.toString());
    throw e;
  }
}

Future logoutUser(Login login) async {
  print("AA_S -- Server " + serverIP);
  try {
    String url = '$serverIP/users/logout';
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: loginToJson(login));
    print("AA_S" + response.body);
    return loginFromJson(response.body);
  } catch (e) {
    print("Unable to login " + e.toString());
    throw e;
  }
}