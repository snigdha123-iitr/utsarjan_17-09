// To parse this JSON data, do
//
//     final details = detailsFromJson(jsonString);

import 'dart:convert';

Details detailsFromJson(String str) => Details.fromJson(json.decode(str)["data"]);

String detailsToJson(Details data) => json.encode(data.toJson());

class Details {
    String username;
    bool authenticate;
    AuthenticateData authenticateData;

    Details({
        this.username,
        this.authenticate,
        this.authenticateData,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        username: json["username"],
        authenticate: json["authenticate"],
        authenticateData: AuthenticateData.fromJson(json["authenticateData"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "authenticate": authenticate,
        "authenticateData": authenticateData.toJson(),
    };
}

class AuthenticateData {
    bool historyOfHighBloodPressurePriorToNephrosis;
    bool havingAMotherOrSisterWhoHadNephrosis;
    bool aHistoryOfObesity;
    bool aHistoryOfNephrosis;
    bool historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis;

    AuthenticateData({
        this.historyOfHighBloodPressurePriorToNephrosis,
        this.havingAMotherOrSisterWhoHadNephrosis,
        this.aHistoryOfObesity,
        this.aHistoryOfNephrosis,
        this.historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis,
    });

    factory AuthenticateData.fromJson(Map<String, dynamic> json) {
      print("iiiiiiiiiiiiiiiiiiiiiii");
print(json["historyOfHighBloodPressurePriorToNephrosis"]);
     AuthenticateData authentic= AuthenticateData(
        historyOfHighBloodPressurePriorToNephrosis: json["historyOfHighBloodPressurePriorToNephrosis"]==null?null:json["historyOfHighBloodPressurePriorToNephrosis"],
        havingAMotherOrSisterWhoHadNephrosis: json["havingAMotherOrSisterWhoHadNephrosis"],
        aHistoryOfObesity: json["aHistoryOfObesity"],
        aHistoryOfNephrosis: json["aHistoryOfNephrosis"],
        historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis: json["historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis"],
    );
    return authentic;
    }
    Map<String, dynamic> toJson() => {
        "historyOfHighBloodPressurePriorToNephrosis": historyOfHighBloodPressurePriorToNephrosis,
        "havingAMotherOrSisterWhoHadNephrosis": havingAMotherOrSisterWhoHadNephrosis,
        "aHistoryOfObesity": aHistoryOfObesity,
        "aHistoryOfNephrosis": aHistoryOfNephrosis,
        "historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis": historyOfDiabetesKidneyDiseaselupusRheumatoidArthritis,
    };
}
