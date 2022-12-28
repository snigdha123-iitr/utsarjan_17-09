import 'package:http/http.dart' as http;
import 'package:utsarjan/model/testNotificationModal.dart';
import 'dart:io';
import './globalData.dart';
import 'package:utsarjan/model/notifyDataModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

Future addNotifyByDoctor(Notifications notify) async {
  try {
    String url = "$serverIP/users/doctor/sendNotification";  
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: notificationsToJson(notify));   
  } catch (e) {
    print("Unable to addNotifications" + e.toString());
    throw e;
  }
}

Future addTestReport(String patientId, File imageFile) async {
  try {
        Uri url = Uri.parse("$serverIP/users/patient/addTestImage");
        var request = new http.MultipartRequest("POST", url); 
        request.fields['patientId'] = patientId;
        request.fields['date'] = DateTime.now().toString();
    if (imageFile != null) {
      //http.MultipartFile file = await http.MultipartFile.fromPath('photo', imageFile.path, contentType:  MediaType('image', 'png'));
      final extension = p.extension(imageFile.path);
      print("AA_S Extension -- " + extension.substring(1));
      http.MultipartFile file = await http.MultipartFile.fromPath('photo', imageFile.path,
          contentType:  MediaType('image', extension.substring(1)));
      request.files.add(file);
    }   
      await request.send().then((response) async {
      if (response.statusCode == 200) //status = true;
      print(response.statusCode);
      print(response.statusCode);
    });
  } catch (e) {
    print("Unable to addNotifications" + e.toString());
    throw e;
  }
}


Future sendTestNotificationsByDoctor(TestNotification notify) async {
  try {
    String url = "$serverIP/users/doctor/sendTestNotification"; 
    print(notify); 
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: testNotificationsToJson(notify)); 
          
  } catch (e) {
    print("Unable to addNotifications" + e.toString());
    throw e;
  }
}

Future getAllNotifications(String patientId) async {
   List<Notifications> notificationsList;
  try {
//print("notifiction Services All notication patient id" + patientId);
    String url = '$serverIP/users/patient/getPatientNotification?patientId=' + patientId;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('"notifiction Services All notication"'+response.body);
    //return notificationsListFromJson(response.body);
    notificationsList = notificationsListFromJson(response.body);
  } catch (e) {
    print("Error Occured in allNotificationsListforpatient " + e.toString());
  }
  return notificationsList;
}
Future getNotifications(String doctorMobile) async {
   List<Notifications> notificationsList;
  try {
  // print("notifiction Services get notication"+doctorMobile);
    String url ='$serverIP/users/doctor/getDoctorPostedNotification?doctorMobile=' + doctorMobile;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  //  print("notifiction Services All notication"+response.body);
    //return notificationsListFromJson(response.body);
    notificationsList = notificationsListFromJson(response.body);
  } catch (e) {
    print("Error Occured in notificationsListfordoctor " + e.toString());
  }
  return notificationsList;
}

Future getTestNotifications(String patientId,bool isPatient) async {
   List<Notifications> notificationsList;
  try {
  // print("notifiction Services get notication"+doctorMobile);
    String url =isPatient? '$serverIP/users/patient/getTestNotifications?patientId=' + patientId :'$serverIP/users/patient/getTestNotifications?doctorMobile=' + patientId;
     
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  //  print("notifiction Services All notication"+response.body);
    //return notificationsListFromJson(response.body);
    notificationsList = notificationsListFromJson(response.body);
  } catch (e) {
    print("Error Occured in notificationsListfordoctor " + e.toString());
  }
  return notificationsList;
}

// Future getTestNotifications(String patientId) async {
//    List<Notifications> notificationsList;
//   try {
//     String url = '$serverIP/users/patient/getTestNotifications?patientId=' + patientId;
//     //print("notifiction Services All notication patient id" + patientId + url);
//     var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//   //print('"notifiction Services All notication"'+response.body);
//     //return notificationsListFromJson(response.body);
//      notificationsList = notificationsListFromJson(response.body);
//    // return notificationsList;
//   } catch (e) {
//     print("Error Occured in allNotificationsListforpatient " + e.toString());
//   }
//   return notificationsList;
// }