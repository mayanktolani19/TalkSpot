import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'TalkSpot',
      style: TextStyle(fontSize: 22),
    ),
    backgroundColor: Color.fromRGBO(13, 35, 197, 80),
  );
}

InputDecoration textFieldInputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    icon: icon,
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    labelText: hintText,
    labelStyle: TextStyle(color: Colors.white54),
//    enabledBorder: UnderlineInputBorder(
//      borderSide: BorderSide(color: Colors.white),
//    ),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}
