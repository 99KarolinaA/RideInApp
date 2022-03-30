import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:icar/authentication/appAuthentication.dart';
import './customWidgets/gradientText.dart';
import 'package:icar/homepage.dart';
import 'dart:io' show Platform;

class StartPage extends StatefulWidget {
  const StartPage({key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser != null) {
        Route route = MaterialPageRoute(builder: (context) => Homepage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route =
            MaterialPageRoute(builder: (context) => AppAuthentication());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  //todo: below
  @override
  Widget build(BuildContext context) {
    double fontSize;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        fontSize = 20.0;
      } else {
        fontSize = 60.0;
      }
    } catch (e) {
      fontSize = 60.0;
    }
    return new Stack(
      children: <Widget>[
        // todo: change the logo and the text
        Positioned.fill(
          //
          child: Image(
            image: AssetImage('../../images/background_lights.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        Container(
            padding: new EdgeInsets.only(top: 100.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GradientText(
                  'Ride in and enjoy',
                  style: const TextStyle(
                    fontSize: 60,
                    fontFamily: "Lobster",
                  ),
                  gradient: LinearGradient(colors: [
                    Colors.cyanAccent,
                    Colors.cyan,
                    Colors.indigo,
                    Colors.deepPurple
                  ]),
                ),
              ],
            )))
      ],
    );
  }
}
