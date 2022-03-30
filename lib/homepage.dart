import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icar/profilePage.dart';
import 'package:icar/searchCar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'authentication/appAuthentication.dart';
import 'functions.dart';
import 'globalVariables.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String userNumber;
  String carPrice;
  String carModel;
  String carColor;
  String description;
  String urlImage;
  String carLocation;
  QuerySnapshot cars;

  carMethods carObject = new carMethods();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    this.carLocation =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  Future<bool> showDialogForAddingData() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Post a new ad",
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
                  onPressed: () async {
                    Position position = await _determinePosition();
                    GetAddressFromLatLong(position);
                  },
                  child: Text('Current location')),
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
                  "Add",
                ),
                onPressed: () {
                  Map<String, dynamic> carData = {
                    'userName': this.userName,
                    'uId': userId,
                    'userNumber': this.userNumber,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                    'imgPro': userImageUrl,
                    'time': DateTime.now(),
                  };
                  carObject.addData(carData).then((value) {
                    print("Data added successfully.");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
            ],
          );
        });
  }

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

  getMyData() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;

    carObject.getData().then((results) {
      setState(() {
        cars = results;
      });
    });

    getMyData();
  }

  //todo: change icons, colors, paddings
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool centertitle = true;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        width = width;
      } else {
        width = width * 0.5;
      }
    } catch (e) {
      width = width;
    }
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        centertitle = false;
      } else {
        centertitle = true;
      }
    } catch (e) {
      centertitle = true;
    }

    // todo: change the listing of the cars
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
                                      if (cars.docs[i].data()['uId'] ==
                                          userId) {
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
                                  child:
                                      Text(cars.docs[i].data()['userNumber']),
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (_) => Homepage());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Route route = MaterialPageRoute(
                    builder: (_) => ProfilePage(
                          sellerId: userId,
                        ));
                Navigator.pushReplacement(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.person, color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => SearchCar());
                Navigator.pushReplacement(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                auth.signOut().then((_) {
                  Route route =
                      MaterialPageRoute(builder: (_) => AppAuthentication());
                  Navigator.pushReplacement(context, route);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.login_outlined, color: Colors.white),
              ))
        ],
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.black54, Colors.teal],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(("Home page")),
        centerTitle: centertitle,
      ),
      body: Center(
          child: Container(
        width: width,
        child: showCarsList(),
      )),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add post',
        child: Icon(Icons.add),
        onPressed: () {
          showDialogForAddingData();
        },
      ),
    );
  }
}
