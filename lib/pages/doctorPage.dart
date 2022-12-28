//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utsarjan/model/doctorDataModel.dart';

//import 'package:utsarjan/model/doctorDataModel.dart';
import 'package:utsarjan/model/doctorModel.dart';
import 'package:utsarjan/model/getCategoryStagesModel.dart';
import 'package:utsarjan/model/getPieDataModel.dart';
import 'package:utsarjan/model/loginModel.dart';
import 'package:utsarjan/model/relapseCountModel.dart';
import 'package:utsarjan/model/stagesCountModel.dart';
import 'package:utsarjan/pages/allNotificationsPage.dart';
import 'package:utsarjan/pages/allPatients.dart';
import 'package:utsarjan/pages/patientRegistration.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utsarjan/services/loginServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'addDoctor.dart';

class DoctorPage extends StatefulWidget {
  void callFunction(
    stages,
    previousStage,
    currentStage,
  ) {}

  @override
  _DoctorPageState createState() => new _DoctorPageState();
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final int y;
}

class _DoctorPageState extends State<DoctorPage> {
  // final List<ChartData> chartData1 = [
  //   ChartData(1, 5),
  //   ChartData(2, 3),
  //   ChartData(3, 4),
  //   ChartData(4, 2),
  //   ChartData(5, 0),
  //   ChartData(6, 2),
  //   ChartData(7, 4),
  //   ChartData(8, 1)
  // ];
  // final List<ChartData> chartData2 = [
  //   ChartData(1, 0),
  //   ChartData(2, 1),
  //   ChartData(3, 4),
  //   ChartData(4, 2),
  //   ChartData(5, 3),
  //   ChartData(6, 2),
  //   ChartData(7, 2),
  //   ChartData(8, 1)
  // ];

  bool val = false;
  String mobile;
  Doctor doctor;
  String doctorMobile;
  String username;
  List<DoctorData> doctorsDataList;
  List<RelapseCount> relapseCount;
  List<BarData> stages;
  PieData pieData;
  StagesCategoryData stagesCategoryData;
  String patientName;
  bool isloading;
  double bmi = 0;
  bool status = true;
  int keepDummyData = 0;
  bool isStagesDataAvailable = false;
  bool isPieDataAvailable = false;

  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  int ssnsPrevCat = 0, ssnsCurCat = 0;
  int ssnsIRPrevCat = 0, ssnsIRCurCat = 0;
  int ssnsLRPrevCat = 0, ssnsLRCurCat = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
      mobile = instance.getString('mobile');
      username = instance.getString('username');
      setState(() {
        doctorDetails(mobile).then((doctorData) {
          setState(() {
            doctor = doctorData;
            // print(doctorToJson(doctor));
            // print(doctor.name);
            // print(doctor.hospital);
            // print(doctor.speciality);
            // print(doctor.email);
          });
        });
        //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        //   relapse().then((relapseData) {
        //     print("***************************");
        //     setState(() {
        //       relapseCount = relapseData;
        //     });
        //     print(relapseCount);

        //     print("(((((((((((((((((((((((((((");
        //     print(relapseCountToJson(relapseData));
        //     print(relapseCount[0].relapse0Count.ssns);
        //   });
      });
      categoryStages(mobile).then((stagesData) {
        setState(() {
          stagesCategoryData = stagesData;

          ssnsPrevCat = stagesCategoryData.ssns.previous;
          ssnsCurCat = stagesCategoryData.ssns.current;

          ssnsIRPrevCat = stagesCategoryData.ssnsir.previous;
          ssnsIRCurCat = stagesCategoryData.ssnsir.current;

          ssnsLRPrevCat = stagesCategoryData.ssnslr.previous;
          ssnsLRCurCat = stagesCategoryData.ssnslr.current;

          print("AA_S -- " +
              ssnsPrevCat.toString() +
              " -- " +
              ssnsCurCat.toString());

          //stages = stageData;
          //isStagesDataAvailable = checkStagesData();
        });
        // print(stages);
        // print(barDataToJson(stageData));
      });

      getPieData(mobile).then((patientData) {
        setState(() {
          pieData = patientData;
          // isPieDataAvailable = checkPieData();
        });
        // print(pieData);
        // print(
        //     "##############################################5555555555555555555");
        // print(pieDataToJson(patientData));
      });
    });
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DoctorPage()));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  bool checkStagesData() {
    return hasDataInStages(stages[0].ssns.stage0) ||
        hasDataInStages(stages[0].ssns.stage1) ||
        hasDataInStages(stages[0].ssns.stage2) ||
        hasDataInStages(stages[0].ssns.stage3) ||
        hasDataInStages(stages[0].ssnsir.stage4) ||
        hasDataInStages(stages[0].ssnsir.stage5) ||
        hasDataInStages(stages[0].ssnsir.stage6) ||
        hasDataInStages(stages[0].ssnsir.stage7) ||
        hasDataInStages(stages[0].ssnsir.stage8) ||
        hasDataInStages(stages[0].ssnsir.stage9) ||
        hasDataInStages(stages[0].ssnsir.stage10) ||
        hasDataInStages(stages[0].ssnslr.stage4) ||
        hasDataInStages(stages[0].ssnslr.stage5) ||
        hasDataInStages(stages[0].ssnslr.stage6) ||
        hasDataInStages(stages[0].ssnslr.stage7) ||
        hasDataInStages(stages[0].ssnslr.stage8) ||
        hasDataInStages(stages[0].ssnslr.stage9) ||
        hasDataInStages(stages[0].ssnslr.stage10);
  }

  bool hasDataInStages(val) {
    return val.previousStage != 0 || val.currentStage != 0;
  }

  @override
  Widget build(BuildContext context) {
    var noofpatientsData,
        noofpatientsData1,
        noofpatientsData2,
        noofpatientsData3,
        noofpatientsData4,
        noofpatientsData5,
        noofpatientsData6,
        stages0,
        stages1,
        stages2,
        stages3,
        stages4,
        stages5,
        stages6,
        chart,
        series;

    // List<BarData> stages = <BarData>[];

    if (isStagesDataAvailable) {
      noofpatientsData = [
        new StagesData('SSNS', stages[0].ssns.stage0.previousStage),
        new StagesData('SRNS-IR', stages[0].ssnsir.stage4.previousStage),
        new StagesData('SRNS-LR', stages[0].ssnslr.stage4.previousStage),
      ];
    } else {
      noofpatientsData = [
        new StagesData('SSNS', 200),
        new StagesData('SRNS-IR', 100),
        new StagesData('SRNS-LR', 100),
      ];
    }

    noofpatientsData1 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage1.previousStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage5.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage5.previousStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 100),
          ];

    noofpatientsData2 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage2.previousStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage6.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage6.previousStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 120),
          ];

    noofpatientsData3 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage3.previousStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage7.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage7.previousStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 140),
          ];
    noofpatientsData4 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage8.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage8.previousStage),
          ]
        : [
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 10),
          ];
    noofpatientsData5 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage9.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage9.previousStage),
          ]
        : [
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 10),
          ];
    noofpatientsData6 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage10.previousStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage10.previousStage),
          ]
        : [
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 100),
          ];
    stages0 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage0.currentStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage4.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage4.currentStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 10),
          ];

    stages1 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage1.currentStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage5.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage5.currentStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 10),
          ];

    stages2 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage2.currentStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage6.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage6.currentStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 30),
          ];

    stages3 = (isStagesDataAvailable)
        ? [
            new StagesData('SSNS', stages[0].ssns.stage3.currentStage),
            new StagesData('SRNS-IR', stages[0].ssnsir.stage7.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage7.currentStage),
          ]
        : [
            new StagesData('SSNS', 100),
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 50),
          ];
    stages4 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage8.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage8.currentStage),
          ]
        : [
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 150),
          ];
    stages5 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage9.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage9.currentStage),
          ]
        : [
            new StagesData('SRNS-IR', 50),
            new StagesData('SRNS-LR', 100),
          ];
    stages6 = (isStagesDataAvailable)
        ? [
            new StagesData('SRNS-IR', stages[0].ssnsir.stage10.currentStage),
            new StagesData('SRNS-LR', stages[0].ssnslr.stage10.currentStage),
          ]
        : [
            new StagesData('SRNS-IR', 100),
            new StagesData('SRNS-LR', 100),
          ];
    series = [
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData,
        labelAccessorFn: (StagesData data, _) =>
            '${data.category}${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData1,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      //..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData2,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData3,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData4,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData5,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'patients',
        seriesCategory: 'patients',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: noofpatientsData6,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),

      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages0,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages1,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages2,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages3,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages4,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages5,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
      charts.Series<StagesData, String>(
        id: 'stage',
        seriesCategory: 'stage',
        domainFn: (StagesData data, _) => data.category,
        measureFn: (StagesData data, _) => data.patientsData,
        data: stages6,
        labelAccessorFn: (StagesData data, _) =>
            '${data.patientsData.toString()}',
      ),
    ];

    chart = charts.BarChart(
      _createSampleData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      rtlSpec: charts.RTLSpec(axisDirection: charts.AxisDirection.normal),
      animationDuration: Duration(seconds: 5),
      /*defaultRenderer: new charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.groupedStacked,
      ),*/
      behaviors: [
        new charts.SlidingViewport(),
        new charts.PanAndZoomBehavior(),
      ],
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.outside,
      ),
      domainAxis: new charts.OrdinalAxisSpec(),
    );

/////////////////////////////////////////////////////////////////////////////////////////////
    var pieChart, piechart, seriesPieData;

    if (pieData != null &&
        (pieData.bmiBelowSDPatients != 0 ||
            pieData.heightBelowSDPatients != 0 ||
            pieData.weightBelowSDPatients != 0 ||
            pieData.highSystolicBpPatients != 0 ||
            pieData.highDiastolicPatients != 0)) {
      pieChart = [
        CategoryOfPatients(
            AppLocalizations.of(context).stuntedGrowth, pieData.heightBelowSDPatients, Colors.yellow),
        CategoryOfPatients(AppLocalizations.of(context).bmi, pieData.bmiBelowSDPatients, Colors.grey),
        CategoryOfPatients(
            AppLocalizations.of(context).highSysBp, pieData.highSystolicBpPatients, Colors.blue),
        CategoryOfPatients(
            AppLocalizations.of(context).highDysBp, pieData.highDiastolicPatients, Colors.green),
        CategoryOfPatients(AppLocalizations.of(context).weight, pieData.weightBelowSDPatients, Colors.red),
      ];
    } else {
      pieChart = [
        new CategoryOfPatients(AppLocalizations.of(context).stuntedGrowth, 25, Colors.yellow),
        new CategoryOfPatients(AppLocalizations.of(context).bmi, 100, Colors.grey),
        new CategoryOfPatients(AppLocalizations.of(context).highSysBp, 10, Colors.blue),
        new CategoryOfPatients(AppLocalizations.of(context).highDysBp, 40, Colors.green),
        new CategoryOfPatients(AppLocalizations.of(context).weight, 50, Colors.red),
      ];
    }
    seriesPieData = [
      charts.Series(
        domainFn: (CategoryOfPatients data, _) => data.category,
        measureFn: (CategoryOfPatients data, _) => data.patient,
        colorFn: (CategoryOfPatients data, _) => data.color,
        id: "category",
        data: pieChart,
        labelAccessorFn: (CategoryOfPatients data, _) =>
            '${(data.category)}:${(data.patient)}',
      ),
    ];

    piechart = charts.PieChart(
      seriesPieData,
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: new EdgeInsets.only(right: 2.0, bottom: 4.0),
        ),
      ],
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 50,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7),
            labelPosition: charts.ArcLabelPosition.outside,
          )
        ],
      ),
      animate: true,
      animationDuration: Duration(seconds: 2),
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).doctor),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red[200],
          actions: <Widget>[
            // Icon(Icons.arrow_drop_down_circle),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                    child: InkWell(
                  child: Row(children: <Widget>[
                    new Image.asset('images/refresh.png',
                        width: 40.0, height: 40.0),

                    //Icon(Icons.refresh),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context).refresh),
                    ),
                  ]),
                  onTap: () {
                    _onRefresh();
                    _onLoading();

                    // Navigator.of(context).pop();
                  },
                )),
                // PopupMenuItem(
                //   child: Text("ANC Assist"),
                // ),
                PopupMenuItem(
                    child: InkWell(
                  child: Row(children: <Widget>[
                    new Image.asset('images/patient_register.png',
                        width: 40.0, height: 40.0),

                    //Icon(Icons.person),
                    Text("  "+AppLocalizations.of(context).registerPatient),
                  ]),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PatientRegistration()));
                  },
                )),
                PopupMenuItem(
                  child: InkWell(
                      child: Row(children: <Widget>[
                        new Image.asset('images/logout.png',
                            width: 40.0, height: 40.0),

                        //new Image.asset('images/logout.png'),

                        //Icon(Icons.exit_to_app),
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context).logout),
                        ),
                      ]),
                      onTap: () {
                        Login login = new Login();
                        login.username = username;
                        logoutUser(login).then((login) {
                          if (login.status) {
                            SharedPreferences.getInstance().then((onValue) {
                              onValue.clear();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home', (Route<dynamic> route) => false);
                            });
                          }
                        });
                      }),
                ),
              ],
            ),
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          child: (doctor == null ||
                  pieData == null ||
                  stagesCategoryData == null)
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    // (doctorId == "5d70f59a9a56f30004578d1c")
                    //     ? Center(
                    // CircularProgressIndicator(),
                    //       )
                    //     :
                    Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          elevation: 4,
                          // child: Material(
                          //     elevation: 5,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10)),
                          //     child: Container(
                          //         decoration: new BoxDecoration(

                          //             //: new Border.all(color: Colors.lightBlueAccent, width: 3),
                          //             borderRadius: BorderRadius.circular(10),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                   blurRadius: 40.0,
                          //                   color: Colors.transparent)
                          //             ]),
                          //         child: Padding(
                          //           padding: const EdgeInsets.only(
                          //               top: 10, left: 20, right: 20, bottom: 10),
                          // child: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: <Widget>[
                          //     new Image.asset('images/correct.png',
                          //         width: 30.0, height: 30.0),
                          child: Row(
                            children: <Widget>[
                              new Image.asset('images/dcrprofile.png',
                                  width: 80.0, height: 80.0),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Text(AppLocalizations.of(context).name+":              "),
                                      Flexible(
                                          child: Text((doctor != null &&
                                                  doctor.name != null)
                                              ? doctor.name
                                              : "")),
                                      if (doctor.status == true)
                                        new Image.asset('images/correct.png',
                                            width: 30.0, height: 30.0),
                                    ]),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Text(AppLocalizations.of(context).hospital+":          "),
                                        Flexible(
                                            child: Text((doctor != null &&
                                                    doctor.hospital != null)
                                                ? doctor.hospital
                                                : ""))
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Text("Speciality :        "),
                                    //     Text((doctor != null &&
                                    //             doctor.speciality != null)
                                    //         ? doctor.speciality
                                    //         : "")
                                    //   ],
                                    // ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                            child:
                                                Text(AppLocalizations.of(context).email+":               ")),
                                        Flexible(
                                          child: InkWell(
                                              child: Text(
                                                (doctor != null &&
                                                        doctor.email != null)
                                                    ? doctor.email
                                                    : "",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.pink),
                                              ),
                                              onTap: () => launch(
                                                  "mailto: usha@gmail.com")),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlinedButton(
                              child: Text(
                                AppLocalizations.of(context).notifications,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AllNotificationsPage(
                                              username: doctorMobile,
                                              isTestNotification: false)),
                                );
                              },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red[200],)
                            ),),
                          Visibility(
                            visible: false,
                            child: OutlinedButton(
                                child: Text(
                                  AppLocalizations.of(context).tests,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AllNotificationsPage(
                                                username: doctorMobile,
                                                isTestNotification: true)),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(color: Colors.red[200],)
                                ),),
                          ),
                          OutlinedButton(
                              child: Text(
                                AppLocalizations.of(context).allPatients,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AllPatients()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.red[200],)
                              ),),
                        ]),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          /*if (!isStagesDataAvailable)
                            Center(
                              child: Text(
                                '* Dummy Data for educational purpose',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),*/
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "  "+AppLocalizations.of(context).xAxis+
                                  ": " + AppLocalizations.of(context).categoryStages +
                                  " | "+ AppLocalizations.of(context).yAxis+
                                  ": "+ AppLocalizations.of(context).noOfPatients),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Text("data"),
                              // SizedBox(
                              //   height: 300,
                              //   width: 400,
                              //   child: barchart,
                              // ),
                            ],
                          ),
                          // (isStagesDataAvailable)
                          SizedBox(
                            height: 200,
                            width: 400,
                            child: chart,
                          ),
                          // : SizedBox(
                          //     height: 300,
                          //     width: 400,
                          //     child: chart1,
                          //   ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.insert_chart,
                                      color: Colors.lightBlue,
                                    )),
                                Text(AppLocalizations.of(context).previousStages,
                                    style: TextStyle(fontSize: 15)),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.insert_chart,
                                      color: Colors.red,
                                    )),
                                Text(AppLocalizations.of(context).stagesAtOnset,
                                    style: TextStyle(fontSize: 15)),
                              ]),
                          SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                AppLocalizations.of(context).numOfPatientsInCategory),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 235,
                                    // width: 200,
                                    child: piechart,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }

  List<charts.Series<StagesData, String>> _createSampleData() {
    final previousData = [
      new StagesData('SSNS', ssnsPrevCat),
      new StagesData('SRNS-IR', ssnsIRPrevCat),
      new StagesData('SRNS-LR', ssnsLRPrevCat),
    ];

    final currentData = [
      new StagesData('SSNS', ssnsCurCat),
      new StagesData('SRNS-IR', ssnsIRCurCat),
      new StagesData('SRNS-LR', ssnsLRCurCat),
    ];

    return [
      new charts.Series<StagesData, String>(
        id: 'Previous',
        domainFn: (StagesData stage, _) => stage.category,
        measureFn: (StagesData stage, _) => stage.patientsData,
        data: previousData,
        labelAccessorFn: (StagesData stage, _) =>
            "" /*stage.patientsData.toString()*/,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      new charts.Series<StagesData, String>(
        id: 'Current',
        domainFn: (StagesData stage, _) => stage.category,
        measureFn: (StagesData stage, _) => stage.patientsData,
        data: currentData,
        labelAccessorFn: (StagesData stage, _) =>
            "" /*stage.patientsData.toString()*/,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

//////////////////////////////////////////////////////////////////////
class StagesData {
  final String category;
  final int patientsData;

  StagesData(this.category, this.patientsData);
// : this.color = charts.Color(
//       r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
/////////////////////////////////////////////////////////////////////////////

class PatientsOfDoctor {
  final String relapses;
  final int patients;
  final charts.Color color;

  PatientsOfDoctor(this.relapses, this.patients, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class CategoryOfPatients {
  final String category;
  final int patient;

  //final Color color;
  final charts.Color color;

  //Color colorval;
  //Task(this.day, this.sold, this. color)

  CategoryOfPatients(this.category, this.patient, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Newtask {
  final String day;
  final int sold;
  final charts.Color color;

  Newtask(this.day, this.sold, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
