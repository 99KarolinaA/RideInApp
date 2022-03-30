import 'package:flutter/material.dart';
import 'package:icar/startPage.dart';
import '../Dialogs/errorDialog.dart';
import '../customWidgets/customTextField.dart';
import '../homePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../globalVariables.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController phoneConfirmController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // todo: change padding and image and iconData
    return new SingleChildScrollView(
        child:
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),

                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Form(
                        key: globalKey,
                        child: Column(
                          children: <Widget>[
                            Container(height: _height * 0.1,
                            child: CustomTextField(
                              iconData: Icons.person,
                              textEditingController: nameController,
                              hint: 'Name',
                              isObscure: false,
                            ),),
                        Container(height: _height * 0.1,
                        child: CustomTextField(
                          iconData: Icons.phone_android_rounded,
                          textEditingController: phoneConfirmController,
                          hint: 'Phone',
                          isObscure: false,
                        ),),
                        Container(height: _height * 0.1,
                          child: CustomTextField(
                            iconData: Icons.email,
                            textEditingController: emailController,
                            hint: 'Email',
                            isObscure: false,
                          ),),
                        Container(height: _height * 0.1,
                          child:  CustomTextField(
                            iconData: Icons.camera_alt_outlined,
                            textEditingController: imageController,
                            hint: 'Image Url',
                            isObscure: false,
                          ),),
                        Container(height: _height * 0.1,
                          child: CustomTextField(
                            iconData: Icons.lock,
                            textEditingController: passwordController,
                            hint: 'Password',
                            isObscure: true,
                          ),),
                        Container(height: _height * 0.1,
                          child: CustomTextField(
                            iconData: Icons.lock,
                            textEditingController: passwordConfirmController,
                            hint: 'Confirm passsword',
                            isObscure: true,
                          ),)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            _register();
                          },
                          child: Container(
                              padding: new EdgeInsets.all(15.0),
                              child: Text(
                                'Sign up',
                                style: TextStyle(color: Colors.white),
                              ),)

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                 ])));
  }

  void saveUserData(){
    Map<String, dynamic> userData={
      'userName': nameController.text.trim(),
      'uId': userId,
      'userNumber': phoneConfirmController.text.trim(),
      'imgPro': imageController.text.trim(),
      'time': DateTime.now(),
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);

  }

  void _register() async {
    User currentUser;

    await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
      userId = currentUser.uid;
      userEmail = currentUser.email;
      getUserName = nameController.text.trim();

      saveUserData();
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorDialog(
              errorMessage: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      Route route = MaterialPageRoute(builder: (context) => StartPage());
      Navigator.pushReplacement(context, route);
    }
  }
}
