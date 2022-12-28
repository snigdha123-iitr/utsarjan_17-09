import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:utsarjan/model/doctorModel.dart';
import 'package:utsarjan/model/patientDataModel.dart';
import 'package:utsarjan/model/updateDoctorModel.dart';
import 'package:utsarjan/model/patientHistoryDataModel.dart';
import 'dart:async';
import 'dart:io';
import '../model/patientModel.dart';
import './globalData.dart' as globalData;

String baseUrl = globalData.serverIP;

Future addPatient(Patient patient) async {
  try {
    String url = "$baseUrl/users/patient/addPatient";     
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: patientToJson(patient));   
    return patientFromJsonStatus(response.body);
  } catch (e) {
    print("Unable to addPatient" + e.toString());
    throw e;
  }
}

Future patientDetails(String username) async {
  try {  
    String url = '$baseUrl/users/patient/getPatientDetails?username=' + username;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});  
    print('hello');
    print(patientFromJson(response.body));
    return patientFromJson(response.body);
  } catch (e) {
    print("Error Occured in patientDetails " + e.toString());
  }
}


Future addPatientDataByPatient(PatientData patientData, File imageFile) async {
  bool status = false;
  try {
    Uri url = Uri.parse("$baseUrl/users/patient/addPatientDataByPatient");        
    var request = new http.MultipartRequest("POST", url);   
    request.fields['patientId'] = patientData.patientId;
    request.fields['urineProtein'] = patientData.urineProtein.toString();
    //request.fields['medicineDosage'] = patientData.medicineDosage.toString();
    request.fields['infectionStatus'] = patientData.infectionStatus.toString();
    request.fields['comments'] = patientData.comments.toString();
    //request.fields['photo'] = patientData.photo.toString();
    request.fields['patientName'] = patientData.patientName.toString();
    request.fields['date'] = patientData.date.toString();
    request.fields['day'] = patientData.day.toString();
  
   if(imageFile != null) {  
     MultipartFile file = await http.MultipartFile.fromPath(
        'photo', imageFile.path,
        contentType: new MediaType('image', 'png'));
    request.files.add(file);
    }
    await request.send().then((response) async {
      if (response.statusCode == 201) status = true;
    //  print(response.statusCode);
    });    
    return status;
  } catch (e) {
    print("Unable to addPatientDataByDoctor" + e.toString());
  }
}

Future allPatients(String doctorMobile) async {
  try {
    // print(doctorMobile);  
    String url = '$baseUrl/users/patient/getPatientsOfDoctor?doctorMobile=' + doctorMobile;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});  
    //return patientsFromJson(response.body); 
    return patientListFromJson(response.body);
  } catch (e) {
    print("Error Occured in allPatientsList " + e.toString());
  }
}
// Future uploadImage(File file) async {
//   try {
//     var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
//     var length = await file.length();
//     print(length);

//     var url = Uri.parse("http://" + uri + "/api/books/uploadImage");
//     var request = new http.MultipartRequest("POST", url);
//     var multipartFile = new http.MultipartFile('file', stream, length,
//         filename: 'file', contentType: new MediaType('image', 'jpg'));

//     request.files.add(multipartFile);
//     var response = await request.send();
//     print(response.statusCode);
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   } catch (e) {
//     print("Failed to upload Image " + e.toString());
//   }
// }

Future patientData(String patientId) async {
  try {  
    String url ='$baseUrl/users/patient/getPatientData?patientId=' + patientId;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    return  patientDataListFromJson(response.body);
  } catch (e) {
    print("Error Occured in patientDataList SAGAR " + e.toString());
  }
}

Future allDoctors() async {
  try {
    String url = '$baseUrl/users/doctor/getAllDoctors';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    // print("all doctors "+response.body); 
    return doctorListFromJson(response.body);
  } catch (e) {
    print("Error Occured in allDoctorsList " + e.toString());
  }
}

Future changeDoctor(UpdateDoctorData updateDoctorData) async {
  try {   
    String url ="$baseUrl/users/doctor/updateDoctorDetails";
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: updateDoctorDataToJson(updateDoctorData));
    return updateDoctorDataFromJson(response.body);
  } catch (e) {
    print("Unable to changeDoctor" + e.toString());
    throw e;
  }
}

Future patientHistory(String patientId) async {
  String url;
  try {      
    url = '$baseUrl/users/patient/getPatientHistory?patientId=' + patientId;      
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"}); 
    List <PatientHistory> patientHistory ;   
    patientHistory= patientHistoryDataFromJson(response.body);    
    // print(patientHistoryDataToJson(patientHistory)) ;
    print("AA_S StatusCode -- " + response.statusCode.toString());
    if (patientHistory != null)  patientHistory.sort((a, b) => b.date.compareTo(a.date));  
    return patientHistory;
  } catch (e) {  
    print("Error Occured in patientHistoryList " + e.toString());
  }
}

Future patientHistoryThreeOrSixMonths(String patientId,String duration) async {
  String url;
  try {
    url = '$baseUrl/users/patient/getPatientHistoryCSV?patientId=' + patientId+'&duration='+duration;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    List <PatientHistory> patientHistory ;
    patientHistory= patientHistoryDataFromJson(response.body);
    // print(patientHistoryDataToJson(patientHistory)) ;
    if (patientHistory != null)  patientHistory.sort((a, b) => b.date.compareTo(a.date));
    return patientHistory;
  } catch (e) {
    print("Error Occured in patientHistoryList " + e.toString());
  }
}

Future deletePatientHistory(String patientId , DateTime date ) async {
  String url;
  try {      
    url = '$baseUrl/users/patient/deletePatientHistory?patientId=$patientId&date=$date';      
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"}); 
    List <PatientHistory> patientHistory ;
    print("AA_S" + response.body);
    patientHistory= patientHistoryDataFromJson(response.body);
    if (patientHistory != null)  patientHistory.sort((a, b) => b.date.compareTo(a.date));  
    return patientHistory;
  } catch (e) { 
    print("Error Occured in patientHistoryList " + e.toString());
  }
}