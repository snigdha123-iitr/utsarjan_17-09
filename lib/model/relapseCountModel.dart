// To parse this JSON data, do
//
//     final relapseCount = relapseCountFromJson(jsonString);

import 'dart:convert';

List<RelapseCount> relapseCountFromJson(String str) => List<RelapseCount>.from(json.decode(str)['data'].map((x) => RelapseCount.fromJson(x)));

String relapseCountToJson(List<RelapseCount> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RelapseCount {
    Relapse0CountClass relapse0Count;
    Relapse0CountClass relapse1Count;
    Relapse0CountClass relapse2Count;
    Relapse0CountClass relapse3Count;

    RelapseCount({
        this.relapse0Count,
        this.relapse1Count,
        this.relapse2Count,
        this.relapse3Count,
    });

    factory RelapseCount.fromJson(Map<String, dynamic> json) =>  RelapseCount(
        relapse0Count: json["relapse0Count"] == null ? null : Relapse0CountClass.fromJson(json["relapse0Count"]),
        relapse1Count: json["relapse1Count"] == null ? null : Relapse0CountClass.fromJson(json["relapse1Count"]),
        relapse2Count: json["relapse2Count"] == null ? null : Relapse0CountClass.fromJson(json["relapse2Count"]),
        relapse3Count: json["relapse3Count"] == null ? null : Relapse0CountClass.fromJson(json["relapse3Count"]),
    );

    Map<String, dynamic> toJson() => {
        "relapse0Count": relapse0Count == null ? null : relapse0Count.toJson(),
        "relapse1Count": relapse1Count == null ? null : relapse1Count.toJson(),
        "relapse2Count": relapse2Count == null ? null : relapse2Count.toJson(),
        "relapse3Count": relapse3Count == null ? null : relapse3Count.toJson(),
    };
}

class Relapse0CountClass {
    int ssns;
    int ssnsir;
    int ssnslr;

    Relapse0CountClass({
        this.ssns,
        this.ssnsir,
        this.ssnslr,
    });

    factory Relapse0CountClass.fromJson(Map<String, dynamic> json) => Relapse0CountClass(
        ssns: json["SSNS"],
        ssnsir: json["SSNSIR"],
        ssnslr: json["SSNSLR"],
    );

    Map<String, dynamic> toJson() => {
        "SSNS": ssns,
        "SSNSIR": ssnsir,
        "SSNSLR": ssnslr,
    };
}
