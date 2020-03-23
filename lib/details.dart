import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:testapp/webview.dart';

import 'objects.dart';

class details extends StatefulWidget {
  detailsState createState() => detailsState();
}

class detailsState extends State<details> {

  FirebaseDatabase mFirebaseDatabase;
  DatabaseReference mMessagesDatabaseReference;
  TextEditingController link = new TextEditingController();


  List<String> list = new List<String>();
  File _image;
  String website = "abc";
  String _uploadedFileURL = "https://tourhalt.com/images/no_image.jpg";

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    Fluttertoast.showToast(
        msg: "File succesfully selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future uploadFile() async {
    Fluttertoast.showToast(
        msg: "please wait for a few seconds",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: Colors.green[700],
        textColor: Colors.white,
        fontSize: 16.0
    );
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      print(fileURL);
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  @override
  void initState() {
    getData();
  }

  void getData(){
    mFirebaseDatabase = FirebaseDatabase.instance;
    mMessagesDatabaseReference = mFirebaseDatabase.reference().child("card_details");
    mMessagesDatabaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;
      for(var element in KEYS){
         if((element.toString() == list[0] + 'key' + list[1]) && DATA[element]['uid'] == User.uid) {
           setState(() {
             _uploadedFileURL = DATA[element]['url'];
             website = DATA[element]['weblink'];
           });

           break;
         }
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    list = args.split('saplit');
    print(list[0] + ' ' + list[1]);
    print(args);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              if(_uploadedFileURL.length == 0){
                 _uploadedFileURL = "https://tourhalt.com/images/no_image.jpg";
              }
              if(website.length == 0){
                 website = "abc";
              }
              mFirebaseDatabase = FirebaseDatabase.instance;
              mMessagesDatabaseReference = mFirebaseDatabase.reference().child("card_details");
              mMessagesDatabaseReference
                  .child(list[0]+'key'+list[1])
                  .set({
                'card_name': list[1],
                'list_name': list[0],
                'url' : _uploadedFileURL,
                'weblink': website,
                'uid' : User.uid,
              });
              Fluttertoast.showToast(
                  msg: "Data Updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.green[400],
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.orangeAccent[100],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'List name' + ' :- ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          list[1],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent[700],
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Card name' + ' :- ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          list[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.orangeAccent[700]
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    list[2],
                    style: TextStyle(
                      fontFamily: 'GentiumBookBasic',
                      fontSize: 20,
                    ),

                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.lightBlue[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                          child: Text("Add a link attachment"),
                        onTap: (){
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
                                            "Add attachment link",
                                            style:
                                            TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8.0,right: 8.0, top: 8.0),
                                          child: TextField(
                                            decoration: InputDecoration(hintText: "Enter the link"),
                                            controller: link,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: RaisedButton(
                                          onPressed: () {
                                            website = link.text.toString();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Add Link"),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }
                          );
                        },
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      IconButton(
                        icon: Icon(Icons.open_in_browser,
                        ),
                        tooltip: 'Open in browser',
                        onPressed: () {
                          if (website.length != 0 && (website != 'abc' )){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => webview(),
                                  settings: RouteSettings(
                                    arguments: website,
                                  ),
                                )
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "No link attachment provided",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Selected Image',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),

                SizedBox(
                  height: 12.0,
                ),
                _image == null
                    ? RaisedButton(
                        child: Text('Choose File'),
                        onPressed: chooseFile,
                        color: Colors.cyan,
                      )
                    : Container(),
                SizedBox(
                  height: 12.0,
                ),
                _image != null
                    ? Container(
                   child: RaisedButton(
                      child: Text('Upload File'),
                      onPressed: uploadFile,
                      color: Colors.green,
                    ),
                )
                    : Container(),
                SizedBox(
                  height: 12.0,
                ),
                Text('Image uploaded for this card',),
                SizedBox(
                  height: 12.0,
                ),
                _uploadedFileURL != null
                    ? Image.network(
                        _uploadedFileURL,
                        height: 150,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final String cardname;
  final String listname;

  ScreenArguments(this.cardname, this.listname);
}
