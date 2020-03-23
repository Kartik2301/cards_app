import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testapp/experiment.dart';
import 'package:testapp/objects.dart';
import 'package:testapp/second_page.dart';

import 'archives.dart';
import 'local_notications_helper.dart';
final FirebaseAuth auth = FirebaseAuth.instance;

class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  static String _uid;
  User _user;

  final notifications = FlutterLocalNotificationsPlugin();
  FirebaseDatabase mFirebaseDatabase;
  DatabaseReference mMessagesDatabaseReference;
  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('icons8');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    inputData();
  }

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    _uid = user.uid;
    print(_uid);
    User.uid = _uid;
    //_user.uid= user.uid;
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC1C1C1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  experiment(),
                    settings: RouteSettings(
                      arguments: _uid,
                    ),));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            color: Color.fromRGBO(127, 140, 141, 0.5),
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFFF3D250),
                    ),
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 1.0, bottom: 1.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text('Show the board')),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => archives()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 90.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            color: Color.fromRGBO(127, 140, 141, 0.5),
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF8BCBEE),
                    ),
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 1.0, bottom: 1.0),
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: Center(child: Text('View Archived cards')),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  onTap: () {
                    String message = "No Deadlines today";
                    String _add = "";
                    mFirebaseDatabase = FirebaseDatabase.instance;
                    mMessagesDatabaseReference =
                        mFirebaseDatabase.reference().child("list");
                    mMessagesDatabaseReference
                        .once()
                        .then((DataSnapshot snapshot) {
                      var KEYS = snapshot.value.keys;
                      var DATA = snapshot.value;

                      for (var element in KEYS) {
                        if(DATA[element]['uid'] == User.uid) {
                          print(element);
                          String date = DATA[element]['due_date'].toString();
                          DateTime date1 = DateTime.parse(date);
                          DateTime date2 = DateTime.now();
                          int diffDays = date1
                              .difference(date2)
                              .inDays;
                          if (diffDays == 0 && date1.day == date2.day) {
                            _add += element + ', ';
                          }
                        }

                      }
                      if(_add.length > 0){
                        message = _add.trim();
                        message = message.substring(0, message.length - 1);
                      }
                      showOngoingNotification(notifications,
                          title: 'Projects to Be Completed By today',
                          body: message.replaceAll(',', ', '));
                    });

                  },
                  child: Container(
                    width: double.infinity,
                    height: 90.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            color: Color.fromRGBO(127, 140, 141, 0.5),
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFFF48685),
                    ),
                    margin: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 1.0, bottom: 1.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text('Check Deadlines')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
