// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:utsarjan/model/notifyDataModel.dart';
import 'package:utsarjan/model/testNotificationModal.dart';
import 'package:utsarjan/services/globalData.dart';
import 'package:utsarjan/services/notificationServices.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestsPage extends StatefulWidget {
  final String patientId;

  TestsPage({this.patientId});

  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  File imageFile;
  final picker = ImagePicker();
  String patientId;
  List<Notifications> notificationsList;

  bool loading = false;

  void initState() {
    patientId = widget.patientId;
    getNotification();
    super.initState();
  }

  getNotification() {
    getTestNotifications(patientId, true).then((value) =>
    {
      print(notificationsListToJson(value)),
      setState(() {
        notificationsList = value;
      })
    });
  }

  Future takePhoto(context) async {
    var picture = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {
        print('error ======>>>>>');
      }
    });
    print(imageFile);
    Navigator.of(context).pop();
    _showReport(context);
  }

  Future takeLibrary(context) async {
    var picture = await picker.getImage(source: ImageSource.gallery,imageQuality: 40);
    setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
    _showReport(context);
  }

  void sendReport(setState) {
    setState(() {
      loading = true;
    });
    String patientId = widget.patientId;
    addTestReport(patientId, imageFile)
        .then((value) => {
          getNotification(), Navigator.of(context).pop(),
          showToast(AppLocalizations.of(context).sendReportSuccessfully),
          setState(() {
            loading = false;
          })
        });
  }

  void showToast(String message) {
    Toast.show(message, context, duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  Widget listItem(Notifications notifications) {
    return Container(
      //   height: 100.0,
      padding: EdgeInsets.all(10.0),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        DateFormat('hh:mma dd-MM-yyyy')
                            .format(notifications.date)
                            .toString() + "\n",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  notifications.photo != ''
                      ? GestureDetector(
                        onTap: (){
                          _showImage(context,notifications.photo);
                        },
                        child: Image.network(notifications.photo.contains("public")
                        ? serverIP + '/' + notifications.photo
                        : serverIP + '/public/' + notifications.photo),
                      )
                      : Text(notifications.notification != null ? notifications
                      .notification : ""),
                  /*(notifications.notification != null || notifications.photo !='')
                    ? Text(notifications.notification):
                    Image.network(serverIP+'/public/'+notifications.photo),*/
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: 200,
                      child: Center(child: imageFile == null ? Text("") : null
                        //  CachedNetworkImage(
                        //    imageUrl: "http://via.placeholder.com/350x150",
                        //    placeholder: (context, url) => new CircularProgressIndicator(),
                        //    errorWidget: (context, url, error) => new Icon(Icons.error),
                        //  ),
                      )),
                ]),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).reports),
        backgroundColor: Colors.red[200],
      ),
      floatingActionButton: FloatingActionButton(
        child:
        new Image.asset('images/add_button.png', width: 70.0, height: 70.0),
        backgroundColor: Colors.red[200],
        onPressed: () {
          _showDialog(context);
        },
      ),
      body: ListView.builder(
          itemCount: (notificationsList == null) ? 0 : notificationsList.length,
          itemBuilder: (BuildContext context, i) {
            return listItem(notificationsList[i]);
          }),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    // flutter defined function
    //selectImage(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(title: new Text(AppLocalizations.of(context).addPhoto), children: <Widget>[
          SizedBox(
            height: 10,
          ),
          /* SimpleDialogOption(
            child: const Text('Take Photo'),
            onPressed: () async {
              takePhoto(context);
              // Navigator.pop(context);
              // File imageFile =
              //     await ImagePicker.pickImage(source: ImageSource.camera);
              // setState(() {
              //   file = imageFile;
              // });
            },
          ),
          SizedBox(
            height: 10,
          ),*/
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context).chooseFromLibrary),
            onPressed: () async {
              takeLibrary(context);
              // Navigator.of(context).pop();
              // File imageFile =
              //     await ImagePicker.pickImage(source: ImageSource.gallery);
              // setState(() {
              //   file = imageFile;
              // });
            },
          ),
          SizedBox(
            height: 10,
          ),
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context).cancelSmaller),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]);
      },
    );
  }

  _showImage(BuildContext context, String image) {
    // flutter defined function
    //selectImage(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            child: Column(
                children: <Widget>[
                Expanded(
                  child: PhotoView(
                    imageProvider: NetworkImage(
                        image.contains("public")
                            ? serverIP + '/' + image
                            : serverIP + '/public/' + image
                    ),
                  ),
                ),
              /*OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.white,
                  child:  const Text('Close',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  borderSide: BorderSide(
                    color: Colors.red[200],
                  )),*/
            ]),
          );
        });
      },
    );
  }

  _showReport(BuildContext context) {
    // flutter defined function
    //selectImage(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            child: SimpleDialog(
                title: new Text(AppLocalizations.of(context).testReport), children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Image.file(
                imageFile,
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 10,
              ),
              OutlinedButton(
                  child: !loading
                      ? Text(AppLocalizations.of(context).send,
                      style: TextStyle(
                        fontSize: 20,
                      ))
                      : Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator())),
                  onPressed:(){
                    sendReport(setState);
                  },style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.red[200],)
              ),
              ),
            ]),
          );
        });
      },
    );
  }
}
