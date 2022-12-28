import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:utsarjan/model/adviceDataModal.dart';
import 'package:utsarjan/model/patientModel.dart';
import 'package:utsarjan/services/adviceServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdviceComplaintPage extends StatefulWidget {
  final Patient currentPatient;
  const AdviceComplaintPage({this.currentPatient});

  @override
  _AdviceComplaintPageState createState() => _AdviceComplaintPageState();
}

class _AdviceComplaintPageState extends State<AdviceComplaintPage> {

  TextEditingController _adviceFieldController = TextEditingController();

  final dateFormat = DateFormat("dd-MM-yyyy");
  List<Advice> adviceList;
  Patient currentPatient;
  String patientId;
  String advice;

  @override
  void initState() {
    currentPatient = widget.currentPatient;
    patientId = currentPatient.username;  
    getAdvice();
    super.initState();
  }

  void getAdvice() {
    getAllAdvices(patientId).then((advice) {
      print(adviceListToJson(advice));
      setState(() {       
        if (advice != null) adviceList = advice;
      });     
    });
  }

  void addAdvice(String adviceText) {
    final data = new Advice(
      username: currentPatient.username,
      patientId:patientId,
      advice: adviceText,
      date: DateTime.now()  
    );
    print(adviceToJson(data));
    addAdviceByDoctor(data).then((advice) {

      getAdvice();
    });
  }

  void _deleteAdvice(String adviseId) {
    print(adviseId);
    deleteAdvice(adviseId).then((respone) {
      print(respone + " -- ");
      List<String> res = respone.split("-");
      if(res[0]=="success"){
        getAdvice();
      }else{
        showToast(res[1]);
      }
      getAdvice();
    });
  }

  void showToast(String message) {

    Toast.show(message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM,backgroundColor: Colors.red,
        textColor: Colors.white);

    /*Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );*/
  }
 
  Widget listItem(BuildContext context, index, Advice advice) {
    return Card(
        child: MaterialButton(
            onLongPress: () {
            //  _addMedicine(medicineData, index, context);
            },
            onPressed: () {
           //   Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical:5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              (adviceList[index].date != null)
                                  ?DateFormat('dd-MM-yyyy hh:mma').format(adviceList[index].date.toLocal())
                                  : "",
                              style: TextStyle(fontSize: 14, color: Colors.black45),
                            ),
                            InkWell(
                               onTap: (){
                                 _deleteAdvice(adviceList[index].id);
                               },
                               child: Container(
                                 height: 25,
                                 width: 25,
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: Colors.red[200],
                                 ),
                                 child: Icon(Icons.delete,
                                 color: Colors.white,size: 15,),
                               ),
                             ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: Text(
                          (adviceList[index].advice != null)
                              ? adviceList[index].advice
                              : "",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).adviceComplaint),
          backgroundColor: Colors.red[200],
        ),
        floatingActionButton: FloatingActionButton(
          child: new Image.asset('images/add_button.png',
              width: 70.0, height: 70.0),
          backgroundColor: Colors.red[200],
          onPressed: () {
             _addAdvice('', context);
          },
        ),
        body: ListView.builder(
            itemCount: (adviceList == null) ? 0 : adviceList.length,
            itemBuilder: (BuildContext context, i) {
              return listItem(context, i, adviceList[i]);
            }),
      )
    ]);
  }

  void _addAdvice( index, context) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              // contentPadding: const EdgeInsets.all(16.0),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,                
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[                 

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[                
                           SizedBox(height: 10,),
                        ]),                         
                    TextField(
                      cursorColor: Colors.red,
                      controller: _adviceFieldController,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[200])),
                          hintText: AppLocalizations.of(context).enterAdvice),
                      style: TextStyle(fontSize: 18),
                      onChanged: (value) {
                          advice = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: OutlinedButton(
                        child:  Text(
                          AppLocalizations.of(context).addAdvice,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                        onPressed: () {
                          String adviceText = _adviceFieldController.text;
                          _adviceFieldController.text = "";
                          Navigator.of(context).pop();
                          addAdvice(adviceText);
                        },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.red[200],)
                          ),
                      ),
                    ),
                  ]),
            );
          }));
        });
  }
}
