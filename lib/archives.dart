import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/webview.dart';

import 'objects.dart';

class archives extends StatefulWidget{
  archiveState createState() => archiveState();
}

class archiveState extends State<archives>{
  List<archived_cards> list = new List<archived_cards>();
  FirebaseDatabase mFirebaseDatabase;
  DatabaseReference mMessagesDatabaseReference;

  @override
  void initState() {
    mFirebaseDatabase = FirebaseDatabase.instance;
    mMessagesDatabaseReference = mFirebaseDatabase.reference().child("archived_cards");
    getData();
  }

  void getData(){
    mMessagesDatabaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      for(var element in KEYS){
        if(DATA[element]['uid'].toString() == User.uid){
          String cardname = DATA[element]['card_name'];
          String listname = DATA[element]['list_name'];
          String description = DATA[element]['description'];
          String photo_url = DATA[element]['url'];
          String web_url = DATA[element]['weblink'];
          archived_cards arc = new archived_cards(cardname, listname, description, photo_url, web_url);
          print(arc.description);
          list.add(arc);
          setState(() {

          });
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    if(list.length > 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Archived cards'),
          centerTitle: true,
        ),
        backgroundColor: Colors.blue[800],
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 0),
                      color: Color.fromRGBO(127, 140, 141, 0.5),
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(
                  top: 20.0, left: 10.0, right: 10.0, bottom: 12.0),
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Card Name: ' + list[index].cardname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'list name: ' + list[index].listname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Image.network(list[index].photo_url,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          icon: Icon(Icons.open_in_browser
                            , color: Colors.lightBlue,
                            size: 75.0,),
                          onPressed: () {
                            if (list[index].web_url == "abc") {
                              Fluttertoast.showToast(
                                  msg: "No link attachment provided",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            } else {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => webview(),
                                settings: RouteSettings(
                                  arguments: list[index].web_url,
                                ),));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Text(
                    list[index].description,
                    style: TextStyle(
                        fontFamily: 'GentiumBookBasic',
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0
                    ),
                    textAlign: TextAlign.start,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: (){
                      mMessagesDatabaseReference = mFirebaseDatabase
                          .reference()
                          .child("archived_cards/"+list[index].listname + "key"+list[index].cardname);
                      mMessagesDatabaseReference
                          .remove()
                          .then((_) {
                        print("Delete successful");
                        setState(() {
                          list.removeAt(index);
                        });
                      });
                      Navigator.pop(context);
                    },
                    tooltip: 'Delete the card',
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('No archived cards',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.red,
                ),
                ),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    height: 48.0,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Go Back'
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class archived_cards {
  final String cardname;
  final String listname;
  final String description;
  final String photo_url;
  final String web_url;

  archived_cards(this.cardname, this.listname,this.description,this.photo_url,this.web_url);
}
