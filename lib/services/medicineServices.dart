import 'package:http/http.dart' as http;
import 'package:utsarjan/model/medicationModel.dart';
import 'dart:io';
import './globalData.dart';

Future addMedicineByDoctor(MedicineData medicine) async {
  try {
    String url = "$serverIP/users/doctor/addMedicine";   
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: medicineDataToJson(medicine));   
  } catch (e) {
    print("Unable to addMedicine" + e.toString());
    throw e;
  }
}
Future updateMedicineByDoctor(MedicineData medicine) async {
  try {
    String url = "$serverIP/users/doctor/updateMedicine";   
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: medicineDataToJson(medicine));   
  } catch (e) {
    print("Unable to addMedicine" + e.toString());
    throw e;
  }
}

Future deleteMedicineByDoctor(MedicineData medicine) async {
  try {
    String url = "$serverIP/users/doctor/deleteMedicine";   
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: medicineDataToJson(medicine));   
  } catch (e) {
    print("Unable to addMedicine" + e.toString());
    throw e;
  }
} 

Future<List<MedicineData>> getAllMedicines(String patientId) async {
  List<MedicineData> medicineListData;
  try {   
    String url = '$serverIP/users/doctor/getMedicineList?patientId=' + patientId;
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    medicineListData = medicineListFromJson(response.body);
  } catch (e) {
    print("Error Occured in allMedicinesList " + e.toString());
  }
  return medicineListData;
}
