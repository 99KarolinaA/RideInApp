import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icar/Dialogs/errorDialog.dart';
import 'package:icar/Dialogs/loadingDialog.dart';
import 'package:icar/homepage.dart';

import '../bloc.dart';
import '../customWidgets/customTextField.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bloc = Bloc();

  @override
  Widget build(BuildContext context) {
    // the screen width and height will be set according to the device screen (android, ios)
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return new SingleChildScrollView(
        child:
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 180.0)

                  ),
                ),
                Form(
                  key: globalKey,
                  child: Column(
                    children: <Widget>[
                      Container(height: _height * 0.1,
                      child: StreamBuilder<String>(
                        stream: bloc.email,
                        builder: (context, snapshot) => CustomTextField(
                          iconData: Icons.person,
                          textEditingController: emailController,
                          hint: 'Email',
                          isObscure: false,
                          function: bloc.emailChanged,
                          errorText: snapshot.error
                        ),
                      ),
                      ),
                      Container(
                        height: _height * 0.1,
                        child: StreamBuilder<String>(
                          stream: bloc.password,
                          builder: (context, snapshot) => CustomTextField(
                          iconData: Icons.lock,
                          textEditingController: passwordController,
                          hint: 'Password',
                          isObscure: true,
                          function: bloc.passwordChanged,
                          errorText: snapshot.error
                        )
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height:   10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Container(
                    child: StreamBuilder<bool>(
                      stream: bloc.submitCheck,
                      builder: (context, snapshot) => ElevatedButton(
                          onPressed: () {
                            /*emailController.text.isNotEmpty && passwordController.text.isNotEmpty
                                ? _login()
                                : showDialog(
                                context: context,
                                builder: (con){
                                  return ErrorDialog(
                                    errorMessage: 'Please write the required info.',
                                  );
                                });*/
                            snapshot.hasData? _login() : showDialog(
                                context: context,
                                builder: (con){
                                  return ErrorDialog(
                                    errorMessage: 'Please write the required info.',
                                  );
                                });
                          },
                          child: Container(
                            padding: new EdgeInsets.all(15.0),
                            child: Text(
                              'Log in',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                      ),
                    ),
                  )
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ));
  }

  void _login() async {
    showDialog(
        context: context,
        builder: (con) {
          return LoadingDialog(
            // changed
            message: 'Loading...',
          );
        });

    User currentUser;

    await _auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
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
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (context) => Homepage());
      Navigator.pushReplacement(context, route);
    } else {
      print("error");
    }
  }
}
