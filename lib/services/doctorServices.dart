import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:utsarjan/model/doctorDataModel.dart';
import 'package:utsarjan/model/getCategoryStagesModel.dart';
import 'package:utsarjan/model/getPieDataModel.dart';
import 'package:utsarjan/model/notifyDataModel.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/model/relapseCountModel.dart';
import 'package:utsarjan/model/stagesCountModel.dart';
import 'dart:async';
import 'dart:io';
import '../model/doctorModel.dart';
import './globalData.dart';

Future addDoctor(Doctor doctor) async {
  try {
    String url ='$serverIP/users/doctor/addDoctor';  
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: doctorToJson(doctor));
    return doctorFromJsonStatus(response.body);
  } catch (e) {
    print("Unable to addDoctor " + e.toString());
    throw e;
  }
}

// Future sendNotificationToPatient(Notifications notifications) async {
//   try {
//     String url ='$serverIP/users/doctor/notifyPatient';  
//     var response = await http.post(Uri.encodeFull(url),
//         headers: {
//           HttpHeaders.contentTypeHeader: 'application/json',
//         },
//         body: notificationsToJson(notifications));
//     return notificationsFromJson(response.body);
//   } catch (e) {
//     print("Unable to addDoctor " + e.toString());
//     throw e;
//   }
// }
Future doctorDetails(String mobile) async {
  try {   
   // print(mobile);
    String url ='$serverIP/users/doctor/getDoctorDetails?mobile='+mobile; 
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
   // print(''+response.body);  
    return doctorFromJson(response.body);
  } catch (e) {
    print("Error Occured in doctorDetails " + e.toString());
  }
}

Future addPatientDataByDoctor(DoctorData doctorData, File imageFile) async {
  bool status = false;
  try {
    Uri url = Uri.parse("$serverIP/users/doctor/addPatientDataByDoctor");

    var request = new http.MultipartRequest("POST", url); 
    request.fields['patientId'] = doctorData.patientId;
    request.fields['systolicBP'] = doctorData.systolicBP.toString();
    request.fields['diastolicBP'] = doctorData.diastolicBP.toString();
    request.fields['bodyWeight'] = doctorData.bodyWeight.toString();
    request.fields['bodyHeight'] = doctorData.bodyHeight.toString();
    request.fields['bmi'] = doctorData.bmi.toString();
    request.fields['patientName'] = doctorData.patientName.toString();
    request.fields['date'] = doctorData.date.toString();
    request.fields['category'] = doctorData.category.toString();
    request.fields['stage'] = doctorData.stage.toString();
    request.fields['age'] = doctorData.age.toString();
    request.fields['gender'] = doctorData.gender.toString();
    request.fields['comments'] = doctorData.comments;
    if (imageFile != null) {
      MultipartFile file = await http.MultipartFile.fromPath(
          'photo', imageFile.path,
          contentType: new MediaType('image', 'png'));
      request.files.add(file);
    }
    await request.send().then((response) async {
      if (response.statusCode == 200) status = true;
      print(response.statusCode);
      print(response);
    });

    return status;
  } catch (e) {
    print("Unable to addPatientDataByDoctor" + e.toString());
  }
}

// upload(File imageFile) async {
//   var stream =
//       new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   var length = await imageFile.length();
//   var uploadURL =
//       // "https://utsarjan-backend.herokuapp.com/users/doctor/addPatientDataByDoctor";
//       "http://192.168.0.1:2676/users/doctor/addPatientDataByDoctor";
//   var uri = Uri.parse(uploadURL);

//   var request = new http.MultipartRequest("POST", uri);
//   var multipartFile = new http.MultipartFile('file', stream, length,
//       filename: basename(imageFile.path));
//   //contentType: new MediaType('image', 'png'));

//   request.files.add(multipartFile);
//   var response = await request.send();
//   print(response.statusCode);
//   response.stream.transform(utf8.decoder).listen((value) {
//     print("333333333333");
//     print(value);
//   });
// }

Future relapse() async {
  try {
    String url = '$serverIP/users/patient/getRelapse';
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('relapse backend resp'+response.body); 
    return relapseCountFromJson(response.body);
  } catch (e) {
    print("Error Occured in relapse " + e.toString());
  }
}

Future category(String doctorMobile) async {
  try {
    String url ='$serverIP/users/patient/getPatientsBasedOnCategory?doctorMobile=' + doctorMobile;
    print('category doctor mob '+doctorMobile);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('category backend resp'+response.body);  
    //print(barDataFromJson(response.body));
    return barDataFromJson(response.body);
  } catch (e) {
    print("Error Occured in stages " + e.toString());
  }
}

Future categoryStages(String doctorMobile) async {
  try {
    String url ='$serverIP/users/patient/getCategoryCounts?doctorMobile=' + doctorMobile;
    print('category doctor mob '+doctorMobile);
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('category backend resp'+response.body);
    //print(barDataFromJson(response.body));
    return stagesDataFromJson(response.body);
  } catch (e) {
    print("Error Occured in stages " + e.toString());
  }
}

Future getPieData(String doctorMobile) async {
  PieData pieData;
  try {     
    String url = '$serverIP/users/doctor/getDonutGraph?doctorMobile=' + doctorMobile;
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('gget pie backend resp'+response.body);   
    return pieDataFromJson(response.body);
    //pieDataList = pieDataFromJson(response.body);
  } catch (e) {
    print("Error Occured in pieData " + e.toString());
  }
  return pieData;
}

Future changePatientDetails(Patient patient) async {
  try {
    String url = '$serverIP/users/patient/updatePatientAuthentication';
    var response = await http.post(Uri.encodeFull(url),
        headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(patient));
  } catch (e) {
    print("Unable to patientDetailsAunthentication" + e.toString());
    throw e;
  }
}

Future getDetailsOfPatient(String username) async {
  try {   
    print(username);   
    String url = '$serverIP/users/patient/getPatientAuthenticData?username=' + username;
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});  
    return patientFromJson(response.body);
  } catch (e) {
    print("Error Occured in details " + e.toString());
  }
}

Future getPatientDataByDoctor(String username) async {
  try {     
    String url = '$serverIP/users/doctor/getPatientDataByDoctor?username=' + username;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});   
    return doctorDataListFromJson(response.body);
  } catch (e) {
    print("Error Occured in details " + e.toString());
  }
}
