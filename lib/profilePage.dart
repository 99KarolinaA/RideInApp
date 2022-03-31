import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icar/homepage.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'dart:io' show Platform;

import 'functions.dart';
import 'globalVariables.dart';

class ProfilePage extends StatefulWidget {
  String sellerId;

  ProfilePage({this.sellerId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String userNumber;
  String carPrice;
  String carModel;
  String carLocation;
  String carColor;
  String description;
  String urlImage;
  QuerySnapshot cars;

  carMethods carObject = GetIt.instance.get<carMethods>();

  Future<bool> showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Update the ad",
              style: TextStyle(
                  fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your name'),
                  onChanged: (value) {
                    this.userName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter your phone number'),
                  onChanged: (value) {
                    this.userNumber = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car price'),
                  onChanged: (value) {
                    this.carPrice = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car name'),
                  onChanged: (value) {
                    this.carModel = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car color'),
                  onChanged: (value) {
                    this.carColor = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car location'),
                  onChanged: (value) {
                    this.carLocation = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter car description'),
                  onChanged: (value) {
                    this.description = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter image URL'),
                  onChanged: (value) {
                    this.urlImage = value;
                  },
                ),
                SizedBox(height: 5.0),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context); //close the alert box
                },
              ),
              ElevatedButton(
                child: Text(
                  "Update now",
                ),
                onPressed: () {
                  Navigator.pop(context); //close the alert box
                  Map<String, dynamic> carData = {
                    'userName': this.userName,
                    'userNumber': this.userNumber,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                    'time': DateTime.now(),
                  };
                  carObject.updateData(selectedDoc, carData).then((value) {
                    print("Data updated successfully.");
                    Route route = MaterialPageRoute(
                        builder: (BuildContext c) => Homepage());
                    Navigator.push(context, route);
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () {
        Route newRoute = MaterialPageRoute(builder: (_) => Homepage());
        Navigator.pushReplacement(context, newRoute);
      },
      icon: Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
              adUserImageUrl,
            ),
            fit: BoxFit.fill),
      ),
    );
  }

  getResults() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('cars')
        .where("uId", isEqualTo: widget.sellerId)
        .get()
        .then((results) {
      setState(() {
        cars = results;
        adUserName = cars.docs[0].data()['userName'];
        adUserImageUrl = cars.docs[0].data()['imgPro'];
      });
    });
  }

  Widget showCarsList() {
    if (cars != null) {
      return ListView.builder(
        itemCount: cars.docs.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, i) {
          return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (_) => ProfilePage(
                                  sellerId: cars.docs[i].data()['uId'],
                                ));
                        Navigator.pushReplacement(context, route);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                cars.docs[i].data()['imgPro'],
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    title: GestureDetector(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => ProfilePage(
                                    sellerId: cars.docs[i].data()['uId'],
                                  ));
                          Navigator.pushReplacement(context, route);
                        },
                        child: Text(cars.docs[i].data()['userName'])),
                    subtitle: GestureDetector(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (_) => ProfilePage(
                                  sellerId: cars.docs[i].data()['uId'],
                                ));
                        Navigator.pushReplacement(context, route);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              cars.docs[i].data()['carLocation'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            Icons.location_pin,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    trailing: cars.docs[i].data()['uId'] == userId
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (cars.docs[i].data()['uId'] == userId) {
                                    showDialogForUpdateData(cars.docs[i].id);
                                  }
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onDoubleTap: () {
                                    if (cars.docs[i].data()['uId'] == userId) {
                                      carObject.deleteData(cars.docs[i].id);
                                      Route route = MaterialPageRoute(
                                          builder: (BuildContext c) =>
                                              Homepage());
                                      Navigator.push(context, route);
                                    }
                                  },
                                  child: Icon(Icons.delete_forever_sharp)),
                            ],
                          )
                        : Row(mainAxisSize: MainAxisSize.min, children: []),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                      cars.docs[i].data()['urlImage'],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '\$ ' + cars.docs[i].data()['carPrice'],
                      style: TextStyle(
                        fontFamily: "Bebas",
                        letterSpacing: 2.0,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_car),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(cars.docs[i].data()['carModel']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                //child: Text(cars.docs[i].data()['time'].toString()),
                                child: Text(tAgo.format(
                                    (cars.docs[i].data()['time']).toDate())),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.brush_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(cars.docs[i].data()['carColor']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone_android),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                //child: Text(cars.docs[i].data()['time'].toString()),
                                child: Text(cars.docs[i].data()['userNumber']),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      cars.docs[i].data()['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ));
        },
      );
    } else {
      return Text('Loading.....');
    }
  }

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _screenWidth = _screenWidth;
      } else {
        _screenWidth = _screenWidth * 0.5;
      }
    } catch (e) {
      _screenWidth = _screenWidth * 0.5;
    }
    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: Row(
          children: [
            _buildUserImage(),
            SizedBox(
              width: 10,
            ),
            Text(adUserName),
          ],
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.cyanAccent, Colors.cyan, Colors.indigo, Colors.deepPurple],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 0.2,0.7, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
          child: Container(
        width: _screenWidth,
        child: showCarsList(),
      )),
    );
  }
}
