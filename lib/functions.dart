import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class carMethods {
  Future<bool> isLoggedIn() async {
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    await Firebase.initializeApp();
    if (isLoggedIn() != null) {
      FirebaseFirestore.instance
          .collection('cars')
          .add(carData)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection('cars')
        .orderBy("time", descending: true)
        .get();
  }

  updateData(selectedDoc, newValue) async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection('cars')
        .doc(selectedDoc)
        .update(newValue)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) async{
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('cars')
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
