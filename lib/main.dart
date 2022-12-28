// import 'package:utsarjan/pages/allPatients.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:utsarjan/pages/doctorPage.dart';
import 'package:utsarjan/pages/patientPage.dart';
import 'package:utsarjan/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'l10n/l10n.dart';


//import './login.dart';
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging(); 
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

   final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

   final InitializationSettings initializationSettings = InitializationSettings(
       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

   await flutterLocalNotificationsPlugin.initialize(
     initializationSettings,
   /*//   onSelectNotification: (String payload) async {
    // if (payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // selectNotificationSubject.add(payload);
 // }*/
  );
  runApp(
    MyApp(),
  );
}

//  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message['data'] != null) {
//     final data = message['data'];
//     final title = data['title'];
//     final body = data['message'];
//     await _showNotificationWithDefaultSound(title, body);
//   }
//   return Future<void>.value();
// }
//   Future _showNotificationWithDefaultSound(String title, String message) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'channel_id', 'channel_name', 'channel_description',
//       importance: Importance.max, priority: Priority.high);
//   var platformChannelSpecifics = NotificationDetails(android:androidPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.show(
//     0,
//     'title',
//     'message',
//     platformChannelSpecifics,
//     payload: 'Default_Sound',
//   );
// }
//class MyApp extends StatelessWidget {
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> { 
  
   @override
  void initState() {
     _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'utsarjan_Id', 'channel_utsarjan', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
        showWhen: false);
const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(0, message['notification']['title'],  message['notification']['body'],platformChannelSpecifics);
      // _showItemDialog(message);
      },     
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//_navigateToItemDetail(message);
      },
      //  onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print("onMessage: $message");
      //  // _showItemDialog(message);
      // },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      //  _navigateToItemDetail(message);
      });
 
     super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Utsarjan',
        theme: ThemeData(
          backgroundColor: Colors.pink,
        ),
        home: HomePage(),
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/doctor': (BuildContext context) => DoctorPage(),
          '/patient': (BuildContext context) => PatientPage(),
          // '/allPatients': (BuildContext context) => AllPatients(),
        },
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
    );
  }
}
