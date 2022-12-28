// To parse this JSON data, do
//
//     final patientsOfDoctor = patientsOfDoctorFromJson(jsonString);

import 'dart:convert';

//import 'dart:io';
// List<Patients> patientsListFromJson(String str) => new List<Patients>.from(
//     json.decode(str)["data"].map((x) => Patients.fromJson(x)));

// String patientsListToJson(List<Patients> data) =>
//     json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));
   
   
    List<Patients> patientsFromJson(String str) => List<Patients>.from(json.decode(str)['data'].map((x) => Patients.fromJson(x)));

String patientsToJson(List<Patients> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Patients patientsFromJson(String str) => Patients.fromJson(json.decode(str)['data']);

// String patientsToJson(Patients data) => json.encode(data.toJson());

class Patients {
    String patientId;
    String name;
    String dob;
    int age;
    String uhid;
    String address;
    String password;
    String email;
    String doctorMobile;
    String doctorName;
    bool status;
    String message;
    String optionalid;
    String category;
    String stage;
    String username;
    int currentage;
    int relapse;
    List<PatientsData> patientData;



    Patients({
        this.patientId,
        this.name,
        this.dob,
        this.age,
        this.uhid,
        this.address,
        this.password,
        this.email,
        this.doctorMobile,
        this.doctorName,
        this.status,
        this.message,
        this.optionalid,
        this.category,
        this.stage,
        this.username,
        this.currentage,
        this.relapse,
        this.patientData,
    });

    factory Patients.fromJson(Map<String, dynamic> json) { 
       Patients patients=new Patients(
        patientId: json["_id"],
        name: json["name"],
        dob: json["dob"],
        age: json["age"],
        uhid: json["uhid"],
        address: json["address"],
        password: json["password"],
        email: json["email"],
        doctorMobile: json["doctorMobile"],
        doctorName: json["doctorName"],
        status: json["status"],
        message: json["message"],
        optionalid: json["optionalid"],
        category: json["category"],
        stage: json["stage"],
        username: json["username"],
        currentage: json["currentage"],
        relapse: json["relapse"],
        patientData: List<PatientsData>.from(json["patientData"].map((x) => PatientsData.fromJson(x))),
    );
     return patients;
    }



    Map<String, dynamic> toJson() => {
        "_id": patientId,
        "name": name,
        "dob": dob,
        "age": age,
        "uhid": uhid,
        "address": address,
        "password": password,
        "email": email,
        "doctorMobile": doctorMobile,
        "doctorName": doctorName,
        "status": status,
        "message": message,
        "optionalid": optionalid,
        "category": category,
        "stage": stage,
        "username": username,
        "currentage": currentage,
        "relapse": relapse,
        "patientData": List<dynamic>.from(patientData.map((x) => x.toJson())),
    };
}

class PatientsData {
    String patientId;
    String patientName;
    DateTime date;
    int urine;
    int medicineDosage;
    bool infectionStatus;
    String extraComments;
    //File photo;
    int relapse;

    PatientsData({
        this.patientId,
        this.patientName,
        this.date,
        this.urine,
        this.medicineDosage,
        this.infectionStatus,
        this.extraComments,
       // this.photo,
        this.relapse,
    });

    factory PatientsData.fromJson(Map<String, dynamic> json) {
       PatientsData patientsData=new PatientsData(
        patientId: json["patientId"],
        patientName: json["patientName"],
        date: DateTime.parse(json["date"]),
        urine: json["urine"],
        medicineDosage: int.parse(json["medicineDosage"]),
        infectionStatus: json["infectionStatus"],
        extraComments: json["extraComments"],
       // photo: json["photo"],
        relapse: json["relapse"],
    );
    return patientsData;
    }

    Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "patientName": patientName,
        "date": date.toString(),
        "urine": urine,
        "medicineDosage": medicineDosage,
        "infectionStatus": infectionStatus,
        "extraComments": extraComments,
        //"photo": photo,
        "relapse": relapse,
    };
}
