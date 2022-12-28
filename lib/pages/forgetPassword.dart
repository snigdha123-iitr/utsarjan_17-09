import 'package:flutter/services.dart';
import 'package:utsarjan/model/loginModel.dart';
import 'package:utsarjan/model/otpModel.dart';
import 'package:utsarjan/pages/UstarjanPage.dart';
import 'package:utsarjan/services/loginServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctorRegistration.dart';
import 'patientRegistration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  final String title;
  ForgetPassword({Key key, this.title}) : super(key: key);

  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username = "";
  String password = "";
  String email = "";
  String pincode = '';
  String patientName;
  bool _obscureText = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  void genrateOtp() {
    if (username == '' || username == null) {
      showSnakBar(_scaffoldKey, AppLocalizations.of(context).userNameIsRequired);
    } else if (email == '' || email == null) {
      showSnakBar(_scaffoldKey, AppLocalizations.of(context).emailIsRequired);
    } else {
      Otp otp = new Otp();
      otp.username = username;
      otp.email = email.trim();
      setState(() {
        loading = true;
      });
      sendOtp(otp).then((otp) => {
            print(otpToJson(otp)),
            if (otp.status==true)
              {
                setState(() {
                  loading = false;
                }),
                _generateOtp("OTP", context),
                showSnakBar(_scaffoldKey, otp.message)
              }
            else
              {
                setState(() {
                  loading = false;
                }),
                showSnakBar(_scaffoldKey, otp.message)
              }
          });
    }
  }

  void _verifyOtp() {
    Otp otp = new Otp();
    otp.pincode = pincode;
    otp.password = password;
    otp.username = username;
    updatePassword(otp).then((data) => {
          if (data.status)
            {
              Navigator.pop(context),
              showSnakBar(_scaffoldKey, AppLocalizations.of(context).passwordUpdateSuccessfully)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset : true,
      backgroundColor: Colors.red[200],
      body: Center(
        child: loading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : Padding(
              padding: EdgeInsets.symmetric( horizontal:20 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Text(
                      AppLocalizations.of(context).forgot,
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),                  
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      cursorColor: Colors.red,
                      onChanged: (value) {
                        username = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border:  new UnderlineInputBorder(
                            borderSide: BorderSide(color:Colors.white)),
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,)),
                        //icon: Text("+91-"),
                        icon: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.white,
                        ),
                        hintText: AppLocalizations.of(context).userName,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      cursorColor: Colors.red,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        border:  new UnderlineInputBorder(
                            borderSide: BorderSide(color:Colors.white)),
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(color:Colors.white)),
                        //icon: Text("+91-"),
                        icon: Icon(
                          Icons.mobile_screen_share,
                         color: Colors.white,
                        ),
                        hintText: AppLocalizations.of(context).registeredEmail,
                      //  hintStyle: TextStyle(color: Colors.white,)
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
                              side: BorderSide(color: Colors.white)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).generate,
                                style: TextStyle(
                                  color: Colors.white,
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
                          onPressed: genrateOtp),
                    ),
                    
                    Text(
                      AppLocalizations.of(context).otpSent,
                      style: TextStyle(fontSize: 12,color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                  ]),
            )
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
                  password = value;
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
                  pincode = value;
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

  void showSnakBar(scaffoldKey, msg) {  
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(msg),
      backgroundColor: Colors.red,
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
