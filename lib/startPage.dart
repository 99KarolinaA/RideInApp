import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:icar/authentication/appAuthentication.dart';
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
    return Material(
        child: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    // todo: change the colors
                    colors: [Colors.white, Colors.teal],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // todo: change the logo and the text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/logo.png'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Ride in and enjoy",
                    style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.white,
                        fontFamily: "Lobster"))
              ],
            ))));
  }
}
