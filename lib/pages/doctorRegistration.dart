import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsarjan/model/doctorModel.dart';
import 'package:utsarjan/services/doctorServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorRegistration extends StatefulWidget {
  DoctorRegistration({Key key, this.title,this.fcmToken}) : super(key: key);
  final String title;
  final String fcmToken;

  @override
  _DoctorRegistrationState createState() => new _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {
  String username = "";
  String password = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  String name = "";
  bool validName = false;
  bool validmobileNumber = false;
  TextEditingController nameTextController;
  TextEditingController mobileNoTextController;
  List<Doctor> doctorsList;
  Doctor doctor = new Doctor();
  String mobile;
  bool validEmail=false;
  bool validFormat=false;
  bool validHospital=false;
  bool validPassword=false;
  bool isLoading=false;

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    nameTextController = TextEditingController();
    mobileNoTextController = TextEditingController();  
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    mobileNoTextController.dispose();
    super.dispose();
  }

  void onRegister () { 
     Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
 bool isValidFormat= doctor.email!=null&&(regex.hasMatch(doctor.email.trim())); 
print(doctor.email);
                      if(nameTextController.text.isEmpty){
                        setState((){
                          validName=true;
                        });
                      } else if(mobileNoTextController.text.isEmpty){
                          setState(() {
                            validmobileNumber=true;
                          });
                      }  
                        else if(doctor.password==null||doctor.password==''){
                          setState(() {
                            validPassword=true;
                          });
                      } 
                      else if(doctor.email==null||doctor.email==''){
                          setState(() {
                            validEmail=true;
                          });
                      }                       
                       else if(!isValidFormat){
                          setState(() {
                            validFormat=true;
                          });
                        //  showSnakBar(_scaffoldKey, 'Invalid Email Format');
                      } else if(doctor.hospital==null||doctor.hospital==''){
                          setState(() {
                            validFormat=true;
                          });
                        //  showSnakBar(_scaffoldKey, 'Hospital is requried');
                      }
                       else{
                          print(doctorToJson(doctor));
                             setState(() {
                            loading=true;
                          });
                         doctor.email=doctor.email.trim();
                         doctor.password=doctor.password.trim();
                         doctor.fcmToken = widget.fcmToken;
                        addDoctor(doctor).then((doctor) { 
                            setState(() {
                            loading=false;
                          });                        
                          if (doctor.status) {
                            setState(() {
                              isLoading=true;
                              SharedPreferences.getInstance().then((instance) {
                                instance.setString('mobile', username);
                                instance.setString('username', username);
                              }).then((onValue) {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/doctor', (Route<dynamic> route) => false);
                              });
                            });
                          } else 
                          setState(() {
                            isLoading=false;
                          });
                            showSnakBar(
                                _scaffoldKey, doctor.message);
                        });
                   }
                      }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).doctorRegistration),
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.red[200],
        ),
        body: new SafeArea(
          top: false,
          bottom: false,        
          child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                SizedBox(height: 20),
                new TextField(
                    cursorColor: Colors.red,
                    controller: nameTextController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red[200])),
                      hintText: AppLocalizations.of(context).name,
                      errorText: validName ? AppLocalizations.of(context).nameIsRequired  : null,
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    onChanged: (value) {
                      setState(() {
                        nameTextController.text.isEmpty
                            ? validName = true
                            : validName = false;
                        name = value;
                      });
                      doctor.name = value;
                    }),
             
                SizedBox(height: 20),
                new TextField(
                  cursorColor: Colors.red,
                  controller: mobileNoTextController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[200])),
                    icon: Text("+91 -"),                   
                    hintText: AppLocalizations.of(context).mobile,
                    errorText: validmobileNumber ? AppLocalizations.of(context).mobileNumberIsRequired : null,
                  ),                
                  onChanged: (String val) {
                    setState(() {
                         mobileNoTextController.text.isEmpty
                            ? validmobileNumber = true
                            : validmobileNumber = false;
                      doctor.mobile = val;
                      username = val;
                    });
                    
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 20),

                new TextField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[200])),
                    hintText: AppLocalizations.of(context).password,
                    errorText: validPassword?AppLocalizations.of(context).passwordIsRequired:null
                  ),
                  obscureText :true,
                  onChanged: (val) => doctor.password = (val).trim(),
                ),           
                SizedBox(height: 20),
                new TextField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[200])),
                    hintText: AppLocalizations.of(context).email,
                    errorText: validEmail?AppLocalizations.of(context).emailIsRequired:validFormat?AppLocalizations.of(context).invalidEmailFormat:null
                  ),
                  onChanged: (val) => {
                    setState((){
                      validEmail=false;
                      validFormat=false;
                      doctor.email = val;
                    })
                  
                    },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                new TextField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[200])),
                    hintText: AppLocalizations.of(context).hospital,
                    errorText: validHospital?AppLocalizations.of(context).hospitalIsRequired:null
                  ),
                  onChanged: (val) =>  setState((){
                      validHospital=false;                    
                     doctor.hospital = val;
                    }) ,
                  keyboardType: TextInputType.text,
                ),
                new Container(
                  padding:
                      const EdgeInsets.only(left: 30.0, top: 50.0, right: 30.0),
                  child:isLoading?  Center(
                      child: CircularProgressIndicator(),
                    ): new OutlinedButton(
                      child: Text(AppLocalizations.of(context).register,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      
                      onPressed: onRegister,
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red[200],)
                    ),
                  ),
                ),
              ]),
        ));
  }
}

void showSnakBar(scaffoldKey, msg) {
  print(msg);
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Colors.red,
  );

  scaffoldKey.currentState..showSnackBar(snackBar);
}
