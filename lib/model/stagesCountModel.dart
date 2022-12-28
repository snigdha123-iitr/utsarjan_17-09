// To parse this JSON data, do
//
//     final barData = barDataFromJson(jsonString);

import 'dart:convert';

List<BarData> barDataFromJson(String str) => List<BarData>.from(
    json.decode(str)['data'].map((x) => BarData.fromJson(x)));

String barDataToJson(List<BarData> data) {
  return (data != null)
      ? json.encode(List<dynamic>.from(data.map((x) {
          return (x == null) ? null : x.toJson();
        })))
      : null;
}

class BarData {
  Ssns ssns;
  SsnsirClass ssnsir;
  SsnsirClass ssnslr;

  BarData({
    this.ssns,
    this.ssnsir,
    this.ssnslr,
  });

    factory BarData.fromJson(Map<String, dynamic> json) {
      return BarData(
        ssns: json["SSNS"] == null ? null : Ssns.fromJson(json["SSNS"]),
        ssnsir:
            json["SSNSIR"] == null ? null : SsnsirClass.fromJson(json["SSNSIR"]),
        ssnslr:
            json["SSNSLR"] == null ? null : SsnsirClass.fromJson(json["SSNSLR"]),
      );
    }

    Map<String, dynamic> toJson() {
      print(ssns);
      print(ssnsir);
      print(ssnslr);
      return {
        "SSNS": ssns.toJson(),
        "SSNSIR": ssnsir.toJson(),
        "SSNSLR": ssnslr.toJson(),
      };
    }
}

class Ssns {
  Stage stage0;
  Stage stage1;
  Stage stage2;
  Stage stage3;

  Ssns({
    this.stage0,
    this.stage1,
    this.stage2,
    this.stage3,
  });

  factory Ssns.fromJson(Map<String, dynamic> json) {
    print("Test *************************************8");
    print(json["stage0"]);
    print(json["stage1"]);
    print(json["stage2"]);
    print(json["stage3"]);
    return Ssns(
      stage0: json["stage0"] == null ? null : Stage.fromJson(json["stage0"]),
      stage1: json["stage1"] == null ? null : Stage.fromJson(json["stage1"]),
      stage2: json["stage2"] == null ? null : Stage.fromJson(json["stage2"]),
      stage3: json["stage3"] == null ? null : Stage.fromJson(json["stage3"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "stage0": stage0.toJson(),
        "stage1": stage1.toJson(),
        "stage2": stage2.toJson(),
        "stage3": stage3.toJson(),
      };
}

class Stage {
  int previousStage;
  int currentStage;

  Stage({
    this.previousStage,
    this.currentStage,
  });

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        previousStage: json["previousStage"],
        currentStage: json["currentStage"],
      );

  Map<String, dynamic> toJson() => {
        "previousStage": previousStage,
        "currentStage": currentStage,
      };
}

class SsnsirClass {
  Stage stage4;
  Stage stage5;
  Stage stage6;
  Stage stage7;
  Stage stage8;
  Stage stage9;
  Stage stage10;

  SsnsirClass({
    this.stage4,
    this.stage5,
    this.stage6,
    this.stage7,
    this.stage8,
    this.stage9,
    this.stage10,
  });

  factory SsnsirClass.fromJson(Map<String, dynamic> json) => SsnsirClass(
        stage4: json["stage4"] == null ? null : Stage.fromJson(json["stage4"]),
        stage5: json["stage5"] == null ? null : Stage.fromJson(json["stage5"]),
        stage6: json["stage6"] == null ? null : Stage.fromJson(json["stage6"]),
        stage7: json["stage7"] == null ? null : Stage.fromJson(json["stage7"]),
        stage8: json["stage8"] == null ? null : Stage.fromJson(json["stage8"]),
        stage9: json["stage9"] == null ? null : Stage.fromJson(json["stage9"]),
        stage10:
            json["stage10"] == null ? null : Stage.fromJson(json["stage10"]),
      );

  Map<String, dynamic> toJson() => {
        "stage4": stage4.toJson(),
        "stage5": stage5.toJson(),
        "stage6": stage6.toJson(),
        "stage7": stage7.toJson(),
        "stage8": stage8.toJson(),
        "stage9": stage9.toJson(),
        "stage10": stage10.toJson(),
      };
}
