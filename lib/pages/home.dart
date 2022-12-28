import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:utsarjan/model/loginModel.dart';
import 'package:utsarjan/model/otpModel.dart';
import 'package:utsarjan/pages/UstarjanPage.dart';
import 'package:utsarjan/pages/forgetPassword.dart';
//import 'package:utsarjan/pages/patient.dart';
import 'package:utsarjan/services/loginServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctorRegistration.dart';
import 'patientRegistration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();

  String username = "";
  String password = "";
  String email = "";
  String pincode = '';
  String fcmToken = '';
  String patientName;
  bool _obscureText = true;
  bool loaded = false;

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
  var  token= await _firebaseMessaging.getToken();
     fcmToken=token;
     print("AA_S -- FCM" + fcmToken);
     SharedPreferences.getInstance().then((instance) {
        instance.setString('token', token);
     });
   // return token;
   }

//   void configPush(){
//        _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
// //         const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //     AndroidNotificationDetails(
// //         'utsarjan_Id', 'channel_utsarjan', 'your channel description',
// //         importance: Importance.max,
// //         priority: Priority.high,
// //         showWhen: false);
// // const NotificationDetails platformChannelSpecifics =
// //     NotificationDetails(android: androidPlatformChannelSpecifics);
// //         await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body',platformChannelSpecifics);
//        // _showItemDialog(message);
//       },
//       // onBackgroundMessage: (Map<String, dynamic> message) async {
//       //   print("onMessage: $message");
//       //  // _showItemDialog(message);
//       // },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
// //_navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       //  _navigateToItemDetail(message);
//       });
//   } 

  @override
  void initState() {   
    SharedPreferences.getInstance().then((instance) async {
      Future.delayed(Duration(seconds: 2), () {       
        if(instance.getString('token')==null){
          sendAndRetrieveMessage();
        }else{
          fcmToken=instance.getString('token');
          print("AA_S -- FCM not null" + fcmToken);
        }
        if (instance.getString('username') != null) {
          if (instance.getString('type') == 'PATIENT')
           // Navigator.of(context).pushReplacementNamed('/patient');
               Navigator.of(context).pushNamedAndRemoveUntil('/patient', (Route<dynamic> route) => false);
          else if (instance.getString('type') == 'DOCTOR')
           // Navigator.of(context).pushReplacementNamed('/doctor');
               Navigator.of(context).pushNamedAndRemoveUntil('/doctor', (Route<dynamic> route) => false);
          else
            setState(() {
              loaded = true;
            });
        } else
          setState(() {
            loaded = true;
          });
      });
    });
    super.initState();
  }
void _verifyOtp () {
Otp otp = new Otp(); 
   otp.pincode=pincode;
   otp.password = password;
   otp.username =username;
   updatePassword(otp).then((data)=>{
     if(data.status){
       Navigator.pop(context),
       showSnakBar(_scaffoldKey, AppLocalizations.of(context).passwordUpdateSuccessfully)
     }
   });

}
  void showToast(String message) {

    Toast.show(message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,backgroundColor: Colors.red,
        textColor: Colors.white);

      /*Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,          
          gravity: ToastGravity.TOP,         
          backgroundColor: Colors.red,
          textColor: Colors.white
      );*/
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.red[200],
      body: Center(
        child: loaded == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'images/kidney_final.png',
                      width: 190.0,
                      height: 210.0,
                    ),
                    // CircularProgressIndicator(),
                  ],
                ),
              )
            : new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Image.asset(
                      'images/kidney_final.png',
                      width: 190.0,
                      height: 210.0,
                      fit: BoxFit.cover,
                    ),
                    new Text(
                      AppLocalizations.of(context).utsarjan,
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: new BoxDecoration(boxShadow: [
                        BoxShadow(blurRadius: 100.0, color: Colors.transparent)
                      ]),
                      height: 40,
                      width: 130,
                      child: new RaisedButton(
                        padding: const EdgeInsets.all(10.0),
                        textColor: Colors.black,
                        color: Colors.white,
                        child: new Text(AppLocalizations.of(context).signin),
                        onPressed: () {
                          print("In SIgnin");
                          _showDialog("Signin", context);
                        },

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Login()),
                        // );
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    new Text(
                      AppLocalizations.of(context).orRegisterAs,
                      style: TextStyle(color: Colors.white),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                        top: 25,
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(children: [
                          new Image.asset('images/patient.png',
                              width: 50.0, height: 50.0),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 40,
                            width: 130,
                            child: new RaisedButton(
                              textColor: Colors.black,
                              color: Colors.white,
                              child: new Text(
                                AppLocalizations.of(context).patient,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientRegistration(fcmToken:fcmToken)),
                                );
                              },
                            ),
                          ),
                        ]),
                        Column(children: [
                          new Image.asset('images/doctor.png',
                              width: 50.0, height: 50.0),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 40,
                            width: 130,
                            child: new RaisedButton(
                              padding: const EdgeInsets.all(10.0),
                              textColor: Colors.black,
                              color: Colors.white,
                              child: new Text(AppLocalizations.of(context).doctor),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorRegistration(fcmToken:fcmToken)),
                                );
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).developed+"\n"+AppLocalizations.of(context).andAIIMSNewDelhi,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,height: 1.5),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: Text(
                        AppLocalizations.of(context).fundedbyDBTGoIDisclaimer,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UstarjanPage()));
                      },
                    ),
                  ]),
      ),
    );
  }

  void _generateOtp(message, context) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) {
                  password=value;
                },
                decoration: InputDecoration(
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[200])),
                  //icon: Text("+91-"),
                  icon: Icon(
                    Icons.person,
                    color: Colors.red[200],
                  ),
                  hintText: AppLocalizations.of(context).enterNewPass,
                  //labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue),
                ),
              ),
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) {
                  pincode=value;
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[200])),
                  icon: Icon(
                    Icons.lock,
                    color: Colors.red[200],
                  ),
                  hintText: AppLocalizations.of(context).otp,
                ),

                //obscureText: false,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 60),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red[200],)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).send,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _verifyOtp,
                ),
              )
            ],
          ));
        });
  }

  void _forgotpassword(message, context) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            TextField(
              cursorColor: Colors.red,
              onChanged: (value) {
                username = value;
              },
              decoration: InputDecoration(
                focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200])),
                //icon: Text("+91-"),
                icon: Icon(
                  Icons.mobile_screen_share,
                  color: Colors.red[200],
                ),
                hintText: AppLocalizations.of(context).registeredNum,
              ),
            ),
            SizedBox(
              height: 20,
            ),
             TextField(
              cursorColor: Colors.red,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[200])),
                //icon: Text("+91-"),
                icon: Icon(
                  Icons.mobile_screen_share,
                  color: Colors.red[200],
                ),
                hintText: AppLocalizations.of(context).registeredEmail,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 30),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.red[200],)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).generate,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    //  Icon(Icons.send,color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Image.asset('images/send.png',
                          width: 20.0, height: 20.0),
                    ),
                  ],
                ),
                onPressed: () {
                     Otp otp = new Otp();
                      otp.username = username;
                      otp.email = email.trim();
                      sendOtp(otp).then((otp)=>{
                      print(otpToJson(otp)),
                      if(otp.status){
                         _generateOtp("OTP", context),
                           showSnakBar(_scaffoldKey, otp.message)
                      }else{
                        showSnakBar(_scaffoldKey, otp.message)
                      }
                      });
                     
                 // _generateOtp("OTP", context);
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '* OTP would be sent to the mobile on which application was initially installed with this linked mobile number due to the senstivity and privacy of your health records. Please contact compbioiitr@gmail.com for further process',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ]));
        });
  }

  void _showDialog(message, context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) {
                  if (this.mounted) {
                    setState(() => {username = value});
                  }
                },
                decoration: InputDecoration(
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[200])),
                  //icon: Text("+91-"),
                  icon: Icon(
                    Icons.person,
                    color: Colors.red[200],
                  ),
                  hintText: AppLocalizations.of(context).userName,

                  //labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue),
                ),
                keyboardType: TextInputType.number,
                 inputFormatters: [
                    new LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly,
                  ],
               // inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) {
                  if (this.mounted) {
                    setState(
                        () => {_obscureText = !_obscureText, password = value});
                  }
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  focusedBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[200])),
                  icon: Icon(
                    Icons.lock,
                    color: Colors.red[200],
                  ),
                  hintText: AppLocalizations.of(context).password,
                ),

                //obscureText: false,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        child: Text(
                          AppLocalizations.of(context).forgotPasswordQ,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.black),
                        ),
                        onTap: () {
                           Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPassword()),
                                );
                        //  _forgotpassword("Pasword", context);
                        }),
                  )),

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.red[200],)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).signin,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          //  Icon(Icons.send,color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: new Image.asset('images/send.png',
                                width: 20.0, height: 20.0),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Login login = new Login();
                        login.username = username;
                        login.password = password;
                        login.fcmToken= fcmToken;
                        loginUser(login).then((login) {
                          if (login.status) {
                            if (login.data == "DOCTOR")
                              setState(() {
                                SharedPreferences.getInstance().then((instance) {
                                  instance.setString('mobile', username);
                                  instance.setString('username', username);
                                  instance.setString('name', login.name);
                                  instance.setString('type', 'DOCTOR');
                                }).then((onValue) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/doctor');
                                });
                              });
                            else if (login.data == "PATIENT")
                              setState(() {
                                SharedPreferences.getInstance().then((instance) {
                                  instance.setString('username', username);
                                  //instance.setString('mobileNumber', username);

                                  instance.setString('name', login.name);
                                  instance.setString('type', 'PATIENT');
                                }).then((onValue) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/patient');
                                });
                              });
                          }
                          //  else if (username == null) {
                          //   Fluttertoast.showToast(msg: 'Enter Mobile number');
                          // }
                          else
                          //  showSnakBar(_scaffoldKey,login.message);
                            print(login.message + " -- ");
                            showToast(login.message);
                        });
                      },),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showSnakBar(scaffoldKey, msg) {
    print(msg);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(msg),
      backgroundColor: Colors.red,
    );

    scaffoldKey.currentState..showSnackBar(snackBar);
  }
}
