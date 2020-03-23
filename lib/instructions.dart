import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testapp/webview.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class instructions extends StatefulWidget {
  instructionState createState() => instructionState();
}

class instructionState extends State<instructions> {
  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    launchURL() async {
      const url = 'https://www.cdc.gov/coronavirus/2019-ncov/if-you-are-sick/steps-when-sick.html';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100],
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            width: c_width,
            child: new Column(
              children: <Widget>[
                new Text(
                    "Steps to help prevent the spread of COVID-19 if you are sick",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left),
                SizedBox(
                  height: 20.0,
                ),
                new Text(
                    "Follow the steps below:  If you are sick with COVID-19 or think you might have it, follow the steps below to help protect other people in your home and community.",
                    textAlign: TextAlign.left),
                SizedBox(
                  height: 20.0,
                ),
                new Text(
                  "1. Stay home except to get medical care",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'images/rest.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Stay home: People who are mildly ill with COVID-19 are able to recover at home. Do not leave, except to get medical care. Do not visit public areas.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            'Stay in touch with your doctor. Call before you get medical care. Be sure to get care if you feel worse or you think it is an emergency.',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Avoid public transportation: Avoid using public transportation, ride-sharing, or taxis.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
                new Text(
                  "2. Separate yourself from other people in your home, this is known as home isolation",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'images/dnw.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Stay away from others: As much as possible, you should stay in a specific “sick room” and away from other people in your home. Use a separate bathroom, if available.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Limit contact with pets & animals: You should restrict contact with pets and other animals, just like you would around other people.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
                new Text(
                  "3. Wear a facemask if you are sick",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'images/mask.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'If you are sick: You should wear a facemask when you are around other people and before you enter a healthcare provider’s office.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            'If you are caring for others: If the person who is sick is not able to wear a facemask (for example, because it causes trouble breathing), then people who live in the home should stay in a different room. When caregivers enter the room of the sick person, they should wear a facemask. Visitors, other than caregivers, are not recommended.',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                new Text(
                  "4. Clean your hands often",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'images/wash.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Wash hands: Wash your hands often with soap and water for at least 20 seconds. This is especially important after blowing your nose, coughing, or sneezing; going to the bathroom; and before eating or preparing food.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Hand sanitizer: If soap and water are not available, use an alcohol-based hand sanitizer with at least 60% alcohol, covering all surfaces of your hands and rubbing them together until they feel dry.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Soap and water: Soap and water are the best option, especially if hands are visibly dirty.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Avoid touching: Avoid touching your eyes, nose, and mouth with unwashed hands.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                new Text(
                  "5. Monitor your symptoms",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'images/ft.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Seek medical attention, but call first: Seek medical care right away if your illness is worsening (for example, if you have difficulty breathing).',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Wear a facemask: If possible, put on a facemask before you enter the building. If you can’t put on a facemask, try to keep a safe distance from other people (at least 6 feet away). This will help protect the people in the office or waiting room.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.fiber_manual_record,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                              'Follow care instructions from your healthcare provider and local health department: Your local health authorities will give instructions on checking your symptoms and reporting information.',
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 48,
                  child: RaisedButton(
                    child: Text(
                      'More Details',
                    ),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => webview()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
