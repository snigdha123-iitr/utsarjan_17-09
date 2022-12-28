import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/charts/charts.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/pages/patientDetails.dart';
import 'package:utsarjan/services/patientSevices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPatients extends StatefulWidget {
  @override
  _AllPatientsState createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Patient> patientsList;
  List<Patient> tempPatientsList;
  String username;
  String patientId;
  String doctorMobile;
  SharedPreferences preferences;

  @override
  void initState() {
    _IsSearching = false;
    SharedPreferences.getInstance().then((instance) {
      setState(() {
        appBarTitle = new Text(AppLocalizations.of(context).allPatients);
        username = instance.getString('username');
        preferences = instance;
        print(username);
        allPatients(username).then((patientsData) {
          setState(() {
            patientsList = patientsData;
            tempPatientsList = patientsList;
          });
        });
      });
    });
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AllPatients()));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  // static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  Widget listItem(Patient patient) {
    String dob = DateFormat.yMd().format(DateTime.parse(patient.dob));
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientDetails(patient: patient)));
        },
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                   Flexible(child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(
                              AppLocalizations.of(context).patientName+": ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          Flexible(child:Text("${patient.name}",
                                style: TextStyle(fontSize: 16),softWrap: true, ))
                          ]),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).dateOfBirth+": ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${dob}", style: TextStyle(fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).gender+": ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${patient.gender}",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).uhid+": ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${patient.uhid}",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).previousCategory+": ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${patient.previousCategory}",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: 10,
                              ),
                              // Text(
                              //   "Stage: ",
                              //   style: TextStyle(
                              //       fontSize: 16, fontWeight: FontWeight.bold),
                              // ),
                              // Text("${patient.previousStage}",
                              //     style: TextStyle(fontSize: 16))
                            ],
                          ),
                          if (patient.currentCategory != null)
                            SizedBox(
                              height: 2,
                            ),
                          if (patient.currentCategory != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context).onsetCategory+": ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${patient.currentCategory}",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // Row(
                                //   children: <Widget>[
                                //     Text(
                                //       "Stage: ",
                                //       style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     Text("${patient.currentStage}",
                                //         style: TextStyle(fontSize: 16))
                                //   ],
                                // )
                              ],
                            ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).mobile+": ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("${patient.username}",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ]),),
                    Image.asset('images/right-arrow.png',
                        width: 30.0, height: 30.0),
                  ],
                ))));
  }

  Widget appBarTitle;
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  _AllPatientsState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          tempPatientsList = patientsList;
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          tempPatientsList=[];
          for(int i=0;i<patientsList.length;i++){
            if(patientsList[i].name.toLowerCase().contains(_searchText.toLowerCase())){
              tempPatientsList.add(patientsList[i]);
            }
          }
        });
      }
    });
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle = new Text(AppLocalizations.of(context).allPatients);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset : false,
        appBar: new AppBar(
          title: appBarTitle,
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.red[200],

          actions: <Widget>[
            new IconButton(icon: actionIcon, onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    autofocus: true,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).search,
                        hintStyle: new TextStyle(fontSize: 20,color: Colors.white)
                    ),
                  );
                  _handleSearchStart();
                }
                else {
                  _handleSearchEnd();
                }
              });
            },),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                    child: InkWell(
                  child: Row(children: <Widget>[
                    new Image.asset('images/refresh.png',
                        width: 40.0, height: 40.0),
                    Text("  "+ AppLocalizations.of(context).refresh),
                  ]),
                  onTap: () {
                    setState(() {
                      _onRefresh();
                      _onLoading();
                    });
                    // Navigator.of(context)
                    //     .popUntil((route) => route.isFirst);
                    // Navigator.of(context)
                    //     .pushReplacementNamed('/allPatients');
                  },
                )),
                PopupMenuItem(
                  child: InkWell(
                    child: Row(children: <Widget>[
                      new Image.asset('images/logout.png',
                          width: 40.0, height: 40.0),
                      SizedBox(
                        height: 10,
                      ),
                      Text("  "+ AppLocalizations.of(context).logout),
                    ]),
                    onTap: () {
                      SharedPreferences.getInstance().then((onValue) {
                        onValue.clear();
                      });

                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: (patientsList == null)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: (tempPatientsList == null) ? 0 : tempPatientsList.length,
                itemBuilder: (BuildContext context, i) {
                  // print("@@@@@@@@@@@@@@@@@@@@");
                  // print(patientsList.length);
                  return listItem(tempPatientsList[i]);
                }),
      ),
    ]);
  }
}
// void showSnakBar(scaffoldKey, msg) {
//   print(msg);
//   var snackBar = SnackBar(
//     content: Text(msg),
//     backgroundColor: Colors.red,
//   );

//   scaffoldKey.currentState..showSnackBar(snackBar);
// }

// return Container(
//   height: 150.0,
//   padding: EdgeInsets.all(10.0),
//   child: Card(
//       child: Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text("Data:")]),
//   )),
// );
class RelapseDosage {
  final DateTime date;
  final int relapse;
  final Color color;
  RelapseDosage(this.date, this.relapse, this.color);
}

class MedicineDosageData {
  final DateTime date;
  final int dosage;
  final Color color;
  MedicineDosageData(this.date, this.dosage, this.color);
}
// class PatientsOfDoctor {
//   final int dayOfYear;
//   final int relapseData;
//   final String shape;

//   PatientsOfDoctor(this.dayOfYear, this.relapseData, this.shape);
// }
