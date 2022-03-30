import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData iconData;
  final String hint;
  final String errorText;
  bool isObscure = true;
  Function function;
  CustomTextField({
    Key key,
    this.textEditingController,
    this.iconData,
    this.hint,
    this.isObscure,
    this.function,
    this.errorText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    //todo: change colors
    return Container(
      //todo: change maybe width?
      width: Platform.isAndroid || Platform.isIOS ? _width : _width * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        onChanged: function,
        controller: textEditingController,
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          errorText: errorText,
            border: InputBorder.none,
            prefixIcon: Icon(
              iconData,
              color: Colors.cyan,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hint),
      ),
    );
  }
}
