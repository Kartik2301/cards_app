import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class webview extends StatefulWidget{
  webviewState createState() => webviewState();
}

class webviewState extends State<webview>{
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
     return Scaffold(
       appBar: AppBar(
         title: Text('Attachments'),
         centerTitle: true,
       ),
       body: WebView(
         initialUrl: args.toString(),
         onWebViewCreated: (WebViewController webViewController) {
           _controller.complete(webViewController);
         },
       ),
     );
  }
}