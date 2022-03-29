import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icar/authentication/appAuthentication.dart';

class StartPage extends StatefulWidget {
  const StartPage({key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  startTimer() {
    Timer(Duration(seconds: 3), () async {
      Route route =
          MaterialPageRoute(builder: (context) => AppAuthentication());
      Navigator.pushReplacement(context, route);
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
                Image.asset('images/logo.png'),
                SizedBox(
                  height: 20.0,
                ),
                Text("Ride in and enjoy",
                    style: TextStyle(
                        fontSize: 60.0,
                        color: Colors.white,
                        fontFamily: "Lobster"))
              ],
            ))));
  }
}
