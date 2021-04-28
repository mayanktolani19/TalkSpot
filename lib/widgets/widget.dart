import 'package:flutter/material.dart';

import 'colors.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'TalkSpot',
      style: TextStyle(fontSize: 22),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    icon: icon,
    border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(35))),
    labelText: hintText,
//    enabledBorder: UnderlineInputBorder(
//      borderSide: BorderSide(color: Colors.white),
//    ),
  );
}

ButtonStyle buttonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(mainColor),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

TextStyle simpleTextFieldStyle() {
  return TextStyle(fontSize: 16);
}
