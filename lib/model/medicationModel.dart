// To parse this JSON data, do
//
//     final medicineData = medicineDataFromJson(jsonString);

import 'dart:convert';

List<MedicineData> medicineListFromJson(String str) => new List<MedicineData>.from(
    json.decode(str)["data"].map((x) => MedicineData.fromJson(x)));

String medicineListToJson(List<MedicineData> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));
MedicineData medicineFromJsonStatus(String str) => MedicineData.fromJson(json.decode(str));

MedicineData medicineDataFromJson(String str) => MedicineData.fromJson(json.decode(str));

String medicineDataToJson(MedicineData data) => json.encode(data.toJson());

class MedicineData {
    String medicineName;
    String fromDate;
    String toDate;
    String sos;
    bool sosDisplay;
    String patientId;
    String medicineForm;
    String medicineType;
    int medicineDosage;
    // String bid;
    // String tid;
    String extraComments;
    int index;
    String id;

    MedicineData({
        this.medicineName,
        this.fromDate,
        this.toDate,
        this.sos,
        this.sosDisplay,
        this.medicineForm,
        this.medicineType,
        // this.bid,
        // this.tid,
        this.medicineDosage,
        this.extraComments,
        this.patientId,
        this.index,
        this.id
    });

    factory MedicineData.fromJson(Map<String, dynamic> json) => MedicineData(
        medicineName: json["medicineName"],
        fromDate:json["fromDate"],//!="null"? DateTime.parse(json["fromDate"]):null,
        toDate: json["toDate"],//!="null"?DateTime.parse(json["toDate"]):null,
        sos: json["sos"],
        sosDisplay: json['sosDisplay'],
        medicineForm:json['medicineForm'],
        medicineType:json['medicineType'],
        medicineDosage:json['medicineDosage'],
        // od: json["od"],
        // bid: json["bid"],
        // tid: json["tid"],
        extraComments: json["extraComments"],
        patientId: json["patientId"],
        index : json['index'],
        id:json['id']
    );

    Map<String, dynamic> toJson() => {
        "medicineName": medicineName,
        "fromDate": fromDate.toString(),
        "toDate": toDate.toString(),
        "sos": sos,
        'sosDisplay':sosDisplay,
        'medicineForm':medicineForm,
        'medicineType':medicineType,
        'medicineDosage':medicineDosage,
        // "od": od,
        // "bid": bid,
        // "tid": tid,
        "extraComments": extraComments,
        "patientId": patientId,
        'index':index,
        'id':id,
    };
}
