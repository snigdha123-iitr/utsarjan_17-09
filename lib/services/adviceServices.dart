import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:utsarjan/model/adviceDataModal.dart';
import 'package:utsarjan/model/medicationModel.dart';
import 'dart:io';
import './globalData.dart';

Future addAdviceByDoctor(Advice advice) async {
  try {
    String url = "$serverIP/users/doctor/addAdvice";   
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: adviceToJson(advice));   
  } catch (e) {
    print("Unable to addMedicine" + e.toString());
    throw e;
  }
}

Future<String> deleteAdvice(String adviseId) async {
  try {
    print(adviseId);
    String url = "$serverIP/users/doctor/deleteAdvice/"+adviseId;
    var response = await http.delete(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
        var json = jsonDecode(response.body);
        print(response.body.toString());
        if(json["status"]){
          return "success-" + json["message"].toString();
        }else{
          return "fail-" + json["message"].toString();
        }
  } catch (e) {
    print("Unable to deleteMedicine" + e.toString());
    throw e;
  }
}

Future<List<Advice>> getAllAdvices(String patientId) async {
  List<Advice> adviceListData;
  try {   
    String url = '$serverIP/users/doctor/getAdviceList?patientId=' + patientId;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    adviceListData = adviceListFromJson(response.body);
    return adviceListData;
  } catch (e) {
    print("Error Occured in allMedicinesList " + e.toString());
  }
  return adviceListData;
}
