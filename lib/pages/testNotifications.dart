import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:utsarjan/model/testNotificationModal.dart';
import 'package:utsarjan/services/notificationServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestNotifications extends StatefulWidget {

  final String patientId;

  const TestNotifications({this.patientId});

  @override
  _TestNotificationsState createState() => _TestNotificationsState();
}

class _TestNotificationsState extends State<TestNotifications> {
  TestNotification notify;

  bool weight = false;
  bool height = false;
  bool bp = false;

  bool cbc = false;
  bool kft = false;
  bool lft = false;
  bool cholestrol = false;
  bool albumin = false;
  bool creatinine = false;
  bool sodium = false;
  bool bloodSugar = false;
  bool hemoglobin = false;
  bool immunoglobulin = false;
  bool tacrolimusTroughLevel = false;
  bool cyclosporineTroughLevel = false;
  bool cd19Percentage = false;
  bool hiv = false;
  bool antiHB = false;

  bool urineRoutine = false;
  bool spotUrineRoutine = false;
  bool urineAndCreatinine = false;

  bool forCataract = false;
  bool intraocularPressure = false;

  String additionalTest = "";
  String comment = "";

  bool loading = false;

  void _handleSendPress() {

    setState(() {
      loading = true;
    });

    final data = new TestNotification(

      weight: weight,
      height: height,
      bp: bp,

      cbc: cbc,
      kft: kft,
      lft: lft,
      cholestrol: cholestrol,
      creatinine: creatinine,
      albumin: albumin,
      sodium: sodium,
      bloodSugar: bloodSugar,
      hemoglobin: hemoglobin,
      immunoglobulin: immunoglobulin,
      tacrolimusTroughLevel: tacrolimusTroughLevel,
      cyclosporineTroughLevel: cyclosporineTroughLevel,
      cd19Percentage: cd19Percentage,
      hiv: hiv,
      antiHB: antiHB,

      urineRoutine: urineRoutine,
      urineAndCreatinine: urineAndCreatinine,
      spotUrineRoutine: spotUrineRoutine,

      forCataract: forCataract,
      intraocularPressure: intraocularPressure,

      additionalTest:additionalTest,
      comment:comment,

      patientId: widget.patientId,
      date: DateTime.now(),
    );
    print(cbc);
    print(data.date);
    // notify.cbc = cbc;
    // notify.kft = kft;
    // notify.lft = lft;
    // notify.cholestrol = cholestrol;
    // notify.creatinine = creatinine;
    // notify.albumin = albumin;
    // notify.sodium = sodium;

    // notify.urineRoutine=urineRoutine;
    // notify.urineAndCreatinine=urineAndCreatinine;
    // notify.spotUrineRoutine=spotUrineRoutine;

    // notify.forCataract=forCataract;
    // notify.intraocularPressure=intraocularPressure;

    sendTestNotificationsByDoctor(data).then((resp) => {
          setState(() {
            weight = false;
            height = false;
            bp = false;

            cbc = false;
            kft = false;
            lft = false;
            cholestrol = false;
            creatinine = false;
            albumin = false;
            sodium = false;
            bloodSugar = false;
            hemoglobin = false;
            immunoglobulin = false;
            tacrolimusTroughLevel = false;
            cyclosporineTroughLevel = false;
            cd19Percentage = false;
            hiv = false;
            antiHB = false;

            urineRoutine = false;
            urineAndCreatinine = false;
            spotUrineRoutine = false;

            forCataract = false;
            intraocularPressure = false;

            additionalTest = "";
            comment = "";

            setState(() {
              loading = false;
            });

            showToast(AppLocalizations.of(context).sendClinicalTestSuccessfully);

          })
        });
  }

  void showToast(String message) {
    Toast.show(message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).clinicalTest),
        backgroundColor: Colors.red[200],
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: new Image.asset('images/add_button.png',
      //         width: 70.0, height: 70.0),
      //     backgroundColor: Colors.red[200],
      //     onPressed: () {
      //      //  _addAdvice('', context);
      //     },
      //   ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).examinationUpper,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height:30,
                    child: Row(

                        //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red[200],
                            value: weight,
                            onChanged: (bool val) {
                              setState(() {
                                weight = val;
                                //  notify.cbc=val;
                                //details.authentication = val;
                              });
                            },
                          ),
                          Text("Weight"),
                        ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: height,
                        onChanged: (bool val) {
                          setState(() {
                            height = val;
                            //   notify.kft = val;
                          });
                        },
                      ),
                      Text("Height")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: bp,
                        onChanged: (bool val) {
                          setState(() {
                            bp = val;
                            //  notify.lft = val;
                          });
                        },
                      ),
                      Text("Blood pressure")
                    ]),
                  ),
                ]),
          ),
          Card(
            elevation: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).eyeExaminationUpper,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height:30,
                    child: Row(

                        //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red[200],
                            value: forCataract,
                            onChanged: (bool val) {
                              setState(() {
                                forCataract = val;
                                // notify.forCataract = val;
                                //details.authentication = val;
                              });
                            },
                          ),
                          Text("For cataract"),
                        ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: intraocularPressure,
                        onChanged: (bool val) {
                          setState(() {
                            intraocularPressure = val;
                            // notify.intraocularPressure = val;
                          });
                        },
                      ),
                      Text("Intraocular pressure")
                    ]),
                  ),
                ]),
          ),
          Card(
            elevation: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).bloodTestsUpper,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height:30,
                    child: Row(

                        //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red[200],
                            value: cbc,
                            onChanged: (bool val) {
                              setState(() {
                                cbc = val;
                                //  notify.cbc=val;
                                //details.authentication = val;
                              });
                            },
                          ),
                          Text("Complete blood counts (CBC)"),
                        ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: kft,
                        onChanged: (bool val) {
                          setState(() {
                            kft = val;
                            //   notify.kft = val;
                          });
                        },
                      ),
                      Text("Kidney function tests (KFT)")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: creatinine,
                        onChanged: (bool val) {
                          setState(() {
                            creatinine = val;
                            // notify.creatinine = val;
                          });
                        },
                      ),
                      Text("Urea and creatinine")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: sodium,
                        onChanged: (bool val) {
                          setState(() {
                            sodium = val;
                            //  notify.sodium = val;
                          });
                        },
                      ),
                      Text("Sodium and potassium")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: lft,
                        onChanged: (bool val) {
                          setState(() {
                            lft = val;
                            //  notify.lft = val;
                          });
                        },
                      ),
                      Text("Liver function tests (LFT)")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: albumin,
                        onChanged: (bool val) {
                          setState(() {
                            albumin = val;
                            // notify.albumin = val;
                          });
                        },
                      ),
                      Text("Serum albumin")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: cholestrol,
                        onChanged: (bool val) {
                          setState(() {
                            cholestrol = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Total cholesterol")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: bloodSugar,
                        onChanged: (bool val) {
                          setState(() {
                            bloodSugar = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Random blood sugar")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: hemoglobin,
                        onChanged: (bool val) {
                          setState(() {
                            hemoglobin = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Glycosylated hemoglobin (HbA1c)")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: immunoglobulin,
                        onChanged: (bool val) {
                          setState(() {
                            immunoglobulin = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Total immunoglobulin G (IgG)")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: tacrolimusTroughLevel,
                        onChanged: (bool val) {
                          setState(() {
                            tacrolimusTroughLevel = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Tacrolimus Trough Level")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: cyclosporineTroughLevel,
                        onChanged: (bool val) {
                          setState(() {
                            cyclosporineTroughLevel = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Cyclosporine Trough Level")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: cd19Percentage,
                        onChanged: (bool val) {
                          setState(() {
                            cd19Percentage = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("CD19 percentage and count, by flow cytometry")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: hiv,
                        onChanged: (bool val) {
                          setState(() {
                            hiv = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("HIV, anti-HIV and HBs antigen")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: antiHB,
                        onChanged: (bool val) {
                          setState(() {
                            antiHB = val;
                            //  notify.cholestrol = val;
                          });
                        },
                      ),
                      Text("Anti-HBs antibodies")
                    ]),
                  ),
                ]),
          ),
          Card(
            elevation: 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context).urineTestsUpper,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height:30,
                    child: Row(

                        //mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red[200],
                            value: urineRoutine,
                            onChanged: (bool val) {
                              setState(() {
                                urineRoutine = val;
                                //  notify.urineRoutine = val;
                                //details.authentication = val;
                              });
                            },
                          ),
                          Text("Urine routine microscopy"),
                        ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: spotUrineRoutine,
                        onChanged: (bool val) {
                          setState(() {
                            spotUrineRoutine = val;
                            // notify.spotUrineRoutine = val;
                          });
                        },
                      ),
                      Text("Spot urine protein to creatinine ratio")
                    ]),
                  ),
                  Container(
                    height:30,
                    child: Row(children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red[200],
                        value: urineAndCreatinine,
                        onChanged: (bool val) {
                          setState(() {
                            urineAndCreatinine = val;
                            //  notify.urineAndCreatinine = val;
                          });
                        },
                      ),
                      Text("24-hour urine protein and creatinine")
                    ]),
                  ),
                ]),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context).additionalTestsUpper,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 10),
                  child: TextField(
                    cursorColor: Colors.red,
                    controller: TextEditingController(text: additionalTest),
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[200])),
                        hintText: AppLocalizations.of(context).enterNameAdditionalTest),
                    style: TextStyle(fontSize: 17),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      additionalTest = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context).commentUpper,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 10),
                  child: TextField(
                    cursorColor: Colors.red,
                    controller: TextEditingController(text: additionalTest),
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[200])),
                        hintText: AppLocalizations.of(context).enterComment),
                    style: TextStyle(fontSize: 17),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      comment = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.all(30),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red[200],)
                ),
                child: !loading
                    ? Text( AppLocalizations.of(context).send,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ):Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator())),
                onPressed: _handleSendPress,
            ),
          ),
        ],
      ),
    );
  }
}
