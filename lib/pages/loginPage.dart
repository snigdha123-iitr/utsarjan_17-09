import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  final String title;
  Login({Key key, this.title}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextStyle style = TextStyle(fontFamily: 'Lato', fontSize: 20.0);
  String email = "";
  String password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: AppLocalizations.of(context).mobileNumber,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)
              )),
              onChanged: (value){
                   
              },
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText:  AppLocalizations.of(context).password,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              onChanged: (value) {

              },
    );

    // @override
    // void dispose() {
    //   // Clean up the controller when the widget is disposed.
    //   emailController.dispose();
    //   passwordController.dispose();
    //   super.dispose();
    // }

    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "images/patient.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 25.0),
                emailField,
                SizedBox(
                  height: 25.0,
                ),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                SeparateWidget(emailController, passwordController),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SeparateWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SeparateWidget(this.emailController, this.passwordController);

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/HomePage');
            String msg = AppLocalizations.of(context).pleaseEnter;
            if (emailController.text == "") {
              msg = msg + AppLocalizations.of(context).username;
            } else if (passwordController.text == "") {
              msg += " "+ AppLocalizations.of(context).password;
            } else if (emailController.text == "admin" &&
                passwordController.text == "admin")
              msg = AppLocalizations.of(context).welcomeUser;
            else
              msg = AppLocalizations.of(context).invalidUsernamePassword;
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(msg),
              duration: Duration(seconds: 3),
            ),
            );
            Container(
              alignment: Alignment(1.0, 0.0),
              padding: EdgeInsets.only(top: 10.0, left: 20.0),
              child: FlatButton(
                child: Text(
                  AppLocalizations.of(context).forgotPasswordQ,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
               ),
                onPressed: () {},
          ));
          },
          child: Text(AppLocalizations.of(context).login,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
        ));
  }
}
