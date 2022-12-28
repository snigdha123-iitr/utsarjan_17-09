// To parse this JSON data, do
//
//     final pieData = pieDataFromJson(jsonString);

import 'dart:convert';

StagesCategoryData stagesDataFromJson(String str) {
  if (str != null && json.decode(str) != null)
    return StagesCategoryData.fromJson(json.decode(str)["data"]);
  else
    return null;
}

String stagesDataToJson(StagesCategoryData data) => json.encode(data.toJson());

class StagesCategoryData {

  Ssns ssns;
  Ssns ssnsir;
  Ssns ssnslr;

  StagesCategoryData({
    this.ssns,
    this.ssnsir,
    this.ssnslr,
  });

  factory StagesCategoryData.fromJson(Map<String, dynamic> json) {
    return StagesCategoryData(
      ssns: json["SSNS"] == null ? null : Ssns.fromJson(json["SSNS"]),
      ssnsir:
      json["SSNSIR"] == null ? null : Ssns.fromJson(json["SSNSIR"]),
      ssnslr:
      json["SSNSLR"] == null ? null : Ssns.fromJson(json["SSNSLR"]),
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
  int previous;
  int current;

  Ssns({
    this.previous,
    this.current,
  });

  factory Ssns.fromJson(Map<String, dynamic> json) => Ssns(
    previous: json["previous"],
    current: json["current"],
  );

  Map<String, dynamic> toJson() => {
    "previous": previous,
    "current": current,
  };
}
