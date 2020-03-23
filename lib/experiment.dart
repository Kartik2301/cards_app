import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:testapp/archives.dart';
import 'package:testapp/details.dart';
import 'package:testapp/instructions.dart';
import 'package:testapp/objects.dart';
import 'package:testapp/sign_in.dart';

import 'login_page.dart';

class experiment extends StatefulWidget {
  @override
  experimentState createState() => experimentState();
}

class experimentState extends State<experiment> {
  String _userName, _uid;
  FirebaseDatabase mFirebaseDatabase;
  String _photoUrl;
  DatabaseReference mMessagesDatabaseReference;
  List<String> cards = ["Hey, there"];
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<List<String>> members = new List<List<String>>();
  List<List<String>> childres = new List<List<String>>();
  List<List<String>> working_upon = new List<List<String>>();
  List<List<String>> descriptions = new List<List<String>>();
  String _date = "Pick a due date";
  String _time = "Not set";
  @override
  void initState() {
    super.initState();
    mFirebaseDatabase = FirebaseDatabase.instance;
    print(User.uid);
    ///
    members = [
      ["Steve"],
      ["Andrews", "Rick"],
    ];
    childres = [
      ["hh"],
    ];
    working_upon = [
      ["Robert"],
    ];
    descriptions = [
      ["The defalut list"],
    ];
    inputData();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cards App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_upward,
              color: Colors.lightGreen[400],
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => archives()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings_power,
              color: Colors.red[800],
            ),
            tooltip: 'Log Out',
            onPressed: () {
              signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }), ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue[800],
      body: _buildBody(),
    );
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    _userName = user.displayName;
    _photoUrl = user.photoUrl;
    _uid = user.uid;
  }

  TextEditingController _cardTextController = TextEditingController();
  TextEditingController _members = TextEditingController();
  TextEditingController _taskTextController = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _whoseworking = TextEditingController();

  _showAddCard() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add Card",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Card Title"),
                    controller: _cardTextController,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        _date = date.toString();
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Name of members"),
                      controller: _members,
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
//                      DateTime date1 = DateTime.parse("2020-03-22 00:00:00.000");
//                      DateTime date2 = DateTime.now();
//                      int diffDays = date1.difference(date2).inDays;
//                      bool isSame = (diffDays == 0 && date1.day == date2.day);
//                      print(isSame);
                      Navigator.of(context).pop();
                      _addCard(_cardTextController.text.trim(),
                          _members.text.toString(), _date.toString());
                    },
                    child: Text("Add Card"),
                    color: Colors.lightGreenAccent[700],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        });
  }

  _addCard(String text, String mem, String due_date) {
    if (_members.text.toString().length == 0) {
      mem = "unasigned";
    }
    if (due_date.length == 0) {
      due_date = "Not provided";
    }

    mFirebaseDatabase = FirebaseDatabase.instance;
    mMessagesDatabaseReference = mFirebaseDatabase.reference().child("list");
    mMessagesDatabaseReference.child(text).set({
      'title': text,
      'due_date': due_date,
      'members': mem,
      'uid' : User.uid,
    });
    cards.add(text);
    childres.add([]);
    _cardTextController.text = "";
    setState(() {});
  }

  _addCard2(String text, List<String> rows11) {
    cards.add(text);
    childres.add(rows11);
    _cardTextController.text = "";
    setState(() {});
  }

  void getData() {
    mMessagesDatabaseReference =
        mFirebaseDatabase.reference().child("list");
    mMessagesDatabaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      int i;
      int count = 0;

      for (var element in KEYS) {
        if(DATA[element]['uid'].toString() == User.uid){
          print(element);
          if (DATA[element]['cards'] == null) {
            _addCard2(element, []);
            working_upon.add([]);
            descriptions.add([]);
            continue;
          }

          List<String> rows = new List<String>();
          List<String> rows1 = new List<String>();
          List<String> rows2 = new List<String>();

          for (var keys in DATA[element]['cards'].keys) {
            String name = DATA[element]['cards'][keys]['name'];
            String working_upon1 = DATA[element]['cards'][keys]['working_upon'];
            String desc = DATA[element]['cards'][keys]['descriptions'];
            print(name);
            rows.add(name);
            rows1.add(working_upon1);
            rows2.add(desc);
          }

          cards.add(element);
          childres.add(rows);
          working_upon.add(rows1);
          descriptions.add(rows2);
          setState(() {});
          count++;
        }

      }
    });
  }

  _showAddCardTask(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Text(
                      "Add task card",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Add name of card"),
                      controller: _taskTextController,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Description"),
                      controller: _description,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Working upon"),
                      controller: _whoseworking,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addCardTask(index, _taskTextController.text.trim(),
                          _description.text.trim(), _whoseworking.text.trim());
                    },
                    child: Text("Add Task"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _addCardTask(int index, String text, String desc, String working_upon1) {
    String t = cards[index];
    mMessagesDatabaseReference =
        mFirebaseDatabase.reference().child("list/" + t + "/cards/");
    mMessagesDatabaseReference.child(t + 'key' + text).set({
      'name': text,
      'descriptions': desc,
      'working_upon': working_upon1,
    });
    childres[index].add(text);
    descriptions[index].add(desc);
    working_upon[index].add(working_upon1);
    _taskTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = childres[index][oldIndex];
    childres[index][oldIndex] = childres[index][newIndex];
    childres[index][newIndex] = oldValue;
    print("right here");
    setState(() {});
  }

  _buildBody() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == cards.length)
          return _buildAddCardWidget(context);
        else
          return _buildCard(context, index);
      },
    );
  }

  Widget _buildAddCardWidget(context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            _showAddCard();
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 2)
              ],
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text("Add Card"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCardTaskWidget(context, index) {
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
        color: Colors.green,
      ),
      child: InkWell(
        onTap: () {
          _showAddCardTask(index);
        },
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
              ),
              SizedBox(
                width: 16.0,
              ),
              Text("Add Card Task"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              color: Colors.blue[200],
            ),
            margin: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cards[index],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      index != 0
                          ? IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {
                                String t = cards[index];
                                mFirebaseDatabase = FirebaseDatabase.instance;
                                mMessagesDatabaseReference = mFirebaseDatabase
                                    .reference()
                                    .child("list/" + t + "/");
                                mMessagesDatabaseReference
                                    .once()
                                    .then((DataSnapshot snapshot) {
//                                  var KEYS = snapshot.value.keys;
                                  var DATA = snapshot.value;
                                  String title = DATA['title'];
                                  String formated_date;
                                  String due_date = DATA['due_date'];
                                  if (due_date == "Not provided") {
                                    formated_date = "date not provied";
                                  } else {
                                    DateTime date1 = DateTime.parse(due_date);
                                    formated_date =
                                        (new DateFormat("dd-MM-yyyy")
                                                .format(date1))
                                            .toString();
                                  }
                                  String members = DATA['members'];
                                  print(title +
                                      " " +
                                      formated_date +
                                      " " +
                                      members);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
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
                                          ),
                                          child: AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "List name: " + title,
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Due date :- " +
                                                        formated_date,
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  "List of members :-",
                                                  style: TextStyle(
                                                      fontSize: 16.0,

                                                      fontWeight:
                                                          FontWeight.bold,
                                                    color: Colors.orangeAccent[300],
                                                  ),
                                                  textAlign: TextAlign.left,

                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    members,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30.0,
                                                ),
                                                Center(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      mMessagesDatabaseReference = mFirebaseDatabase
                                                          .reference()
                                                          .child("list/" + t + "/");
                                                      mMessagesDatabaseReference
                                                          .remove()
                                                          .then((_) {
                                                        print("Delete successful");
                                                        setState(() {
                                                          childres.removeAt(index);
                                                          cards.removeAt(index);
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                });
                              },
                            )
                          : Container(),
                      index != 0
                          ? _buildAddCardTaskWidget(context, index)
                          : Container()
                    ],
                  ),
                ),
                index != 0
                    ? SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.32,
                          child: DragAndDropList<String>(
                            childres[index],
                            itemBuilder: (BuildContext context, item) {
                              return _buildCardTask(
                                  index, childres[index].indexOf(item));
                            },

                            canBeDraggedTo: (one, two) => true,
                            dragElevation: 8.0,
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 25.0),
                              child: _userName != null
                                  ? Text(
                                      _userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GentiumBookBasic',
                                          fontSize: 30.0,
                                          color: Colors.purple),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'GentiumBookBasic',
                                          fontSize: 30.0,
                                          color: Colors.purple),
                                    ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: _photoUrl != null
                                    ? Container(
                                        child: Image.network(
                                          _photoUrl,
                                        ),
                                      )
                                    : Container())
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                print(data);
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                if (data['from'] == index) {
                  return;
                }
                print(cards[index]);
                mMessagesDatabaseReference = mFirebaseDatabase
                    .reference()
                    .child("list/" + cards[data['from']] + "/cards/");
                mMessagesDatabaseReference
                    .child(
                    cards[data['from']] +
                    'key' +
                    data['string'])
                    .remove()
                    .then((_) {
                  print("Delete successful");
                });

                mMessagesDatabaseReference =
                    mFirebaseDatabase.reference().child("list/" + cards[index] + "/cards/");
                mMessagesDatabaseReference.child(cards[index] + 'key' + data['string']).set({
                  'name': data['string'],
                  'descriptions': data['desc'],
                  'working_upon': data['working'],
                });


                childres[data['from']].remove(data['string']);
                childres[index].add(data['string']);
                descriptions[data['from']].remove(data['desc']);
                descriptions[index].add(data['desc']);
                working_upon[data['from']].remove(data['working']);
                working_upon[index].add(data['working']);

                print(data);
                setState(() {});
              },
              builder: (context, accept, reject) {
                print("--- > $accept");
                print(reject);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCardTask(int index, int innerIndex) {
    return Container(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AlertDialog(
                      title: Text('Details'),
                      content: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Being worked on by' +
                                '\n' +
                                working_upon[index][innerIndex].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Text(
                            descriptions[index][innerIndex],
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  String t = cards[index];
                                  mMessagesDatabaseReference = mFirebaseDatabase
                                      .reference()
                                      .child("list/" + t + "/cards/");
                                  mMessagesDatabaseReference
                                      .child(cards[index] +
                                          'key' +
                                          childres[index][innerIndex])
                                      .remove()
                                      .then((_) {
                                    print("Delete successful");
                                    setState(() {
                                      childres[index].removeAt(innerIndex);
                                      descriptions[index].removeAt(innerIndex);
                                      working_upon[index].removeAt(innerIndex);
                                    });
                                  });
                                },
                                tooltip: 'Delete the card',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.archive,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  String website = "abc";
                                  String _uploadedFileURL =
                                      "https://tourhalt.com/images/no_image.jpg";
                                  mMessagesDatabaseReference = mFirebaseDatabase
                                      .reference()
                                      .child("card_details");
                                  mMessagesDatabaseReference
                                      .once()
                                      .then((DataSnapshot snapshot) {
                                    var KEYS = snapshot.value.keys;
                                    var DATA = snapshot.value;
                                    for (var element in KEYS) {
                                      if (element.toString() ==
                                          cards[index] +
                                              'key' +
                                              childres[index][innerIndex]) {
                                        setState(() {
                                          _uploadedFileURL =
                                              DATA[element]['url'];
                                          website = DATA[element]['weblink'];
                                        });
                                        break;
                                      }
                                    }
                                  });
                                  mMessagesDatabaseReference = mFirebaseDatabase
                                      .reference()
                                      .child("archived_cards");
                                  mMessagesDatabaseReference.child(
                                      cards[index] +
                                          'key' +
                                          cards[index][innerIndex]);
                                  mMessagesDatabaseReference
                                      .child(cards[index] +
                                          'key' +
                                          childres[index][innerIndex])
                                      .set({
                                    'card_name': childres[index][innerIndex],
                                    'list_name': cards[index],
                                    'url': _uploadedFileURL,
                                    'weblink': website,
                                    'description': descriptions[index]
                                        [innerIndex],
                                    'uid' : User.uid,
                                  });

                                  setState(() {});
                                  String t = cards[index];
                                  mMessagesDatabaseReference = mFirebaseDatabase
                                      .reference()
                                      .child("list/" + t + "/cards/");
                                  mMessagesDatabaseReference
                                      .child(cards[index] +
                                          'key' +
                                          childres[index][innerIndex])
                                      .remove()
                                      .then((_) {
                                    print("Delete successful");
                                    setState(() {
                                      childres[index].removeAt(innerIndex);
                                      descriptions[index].removeAt(innerIndex);
                                      working_upon[index].removeAt(innerIndex);
                                    });
                                  });
                                },
                                tooltip: 'Archive the card',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => details(),
              settings: RouteSettings(
                arguments: cards[index] +
                    'saplit' +
                    childres[index][innerIndex] +
                    'saplit' +
                    descriptions[index][innerIndex],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 0),
                  color: Color.fromRGBO(127, 140, 141, 0.5),
                  spreadRadius: 1)
            ],
          ),
          width: 300.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Draggable<dynamic>(
            feedback: Material(
              elevation: 5.0,
              child: Container(
                width: 284.0,
                padding: const EdgeInsets.all(16.0),
                color: Colors.greenAccent,
                child: Text(childres[index][innerIndex]),
              ),
            ),
            childWhenDragging: Container(),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.orangeAccent[100],
              child: Center(child: Text(childres[index][innerIndex])),
            ),
            data: {"from": index, "string": childres[index][innerIndex], "desc" : descriptions[index][innerIndex], "working" : working_upon[index][innerIndex]},
          ),
        ),
      ),
    );
  }
}
