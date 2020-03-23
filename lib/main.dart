import 'package:flutter/material.dart';
import 'package:testapp/experiment.dart';
import 'package:testapp/instructions.dart';
import 'package:testapp/practises.dart';

import 'login_page.dart';
import 'notes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

