import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/widgets/colors.dart';
import 'package:talk_spot/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool userFound = true;
  bool tap = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  QuerySnapshot snapshotUserInfo;
  TextEditingController emailTextEditingController =
      new TextEditingController();

  forgotPassword() async {
    if (formKey.currentState.validate()) {
      await databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        try {
          print(snapshotUserInfo.docs[0]["name"]);
          setState(() {
            userFound = true;
          });
          authMethods.resetPass(emailTextEditingController.text);
        } catch (e) {
          setState(() {
            userFound = false;
          });
        }
        setState(() {
          tap = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TalkSpot',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 35),
            alignment: Alignment.center,
            child: Text(
              'Forgot your Password?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: TextFormField(
                validator: (val) {
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)
                      ? null
                      : "Please provide a valid email.";
                },
                style: simpleTextFieldStyle(),
                controller: emailTextEditingController,
                decoration: textFieldInputDecoration('Email', null),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 35, left: 14, right: 14),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  await forgotPassword();
                  !userFound && tap
                      ? showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: mainColor,
                              title: Text(
                                'Email not found!',
                                style: simpleTextFieldStyle(),
                              ),
                              content: Text(
                                'Please check your email and try again.',
                                style: simpleTextFieldStyle(),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          })
                      : tap
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: mainColor,
                                  title: Text(
                                    'Email sent successfully!',
                                    style: simpleTextFieldStyle(),
                                  ),
                                  content: Text(
                                    'Login to your mail and follow the link to reset password',
                                    style: simpleTextFieldStyle(),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              })
                          : Container();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Send Password Reset Email",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                style: buttonStyle),
          ),
        ],
      )),
    );
  }
}
