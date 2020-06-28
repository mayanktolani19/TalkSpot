import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
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
          print(snapshotUserInfo.documents[0].data["name"]);
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'TalkSpot',
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Color.fromRGBO(13, 35, 197, 80),
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
                color: Colors.white,
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
          GestureDetector(
            onTap: () async {
              await forgotPassword();
              !userFound && tap
                  ? showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Colors.blue[900],
                        title: Text(
                          'Email not found!',
                          style: simpleTextFieldStyle(),
                        ),
                        content: Text(
                          'Please check your email and try again.',
                          style: simpleTextFieldStyle(),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      ),
                    )
                  : tap
                      ? showDialog(
                          context: context,
                          child: AlertDialog(
                            backgroundColor: Colors.blue[900],
                            title: Text(
                              'Email sent successfully!',
                              style: simpleTextFieldStyle(),
                            ),
                            content: Text(
                              'Login to your mail and follow the link to reset password',
                              style: simpleTextFieldStyle(),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          ),
                        )
                      : Container();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 40),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Send Password Reset Email",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(13, 15, 157, 90),
                        Color.fromRGBO(13, 35, 197, 80),
                      ])),
            ),
          ),
        ],
      )),
    );
  }
}
