import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talk_spot/helper/helperfunctions.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/widgets/widget.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  HelperFunctions helperFunctions = new HelperFunctions();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      helperFunctions.saveUserEmail(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        helperFunctions
            .saveUserName(snapshotUserInfo.documents[0].data["name"]);
      });
      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          helperFunctions.saveLoggedIn(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  //helperFunctions.saveUserName(usernameTextEditingController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(13, 35, 197, 80),
          title: Text(
            'TalkSpot',
            style: TextStyle(fontSize: 22),
          )),
      body: !isLoading
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromRGBO(0, 0, 10, 10),
                    Color.fromRGBO(13, 35, 97, 80),
                  ])),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text(
                        'SignIn To TalkSpot!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Image.asset(
                          'assets/images/icons1.png',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 30),
                            Container(
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(35)),
//                        ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                validator: (val) {
                                  return val.isEmpty
                                      ? "Please provide a UserName."
                                      : val.length < 3
                                          ? "UserName is too short."
                                          : null;
                                },
                                style: simpleTextFieldStyle(),
                                controller: emailTextEditingController,
                                decoration: textFieldInputDecoration('Email'),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.isEmpty
                                    ? "Please provide a Password."
                                    : val.length < 6
                                        ? "Password is too short."
                                        : null;
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration('Password'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Forgot Password?",
                              style: simpleTextFieldStyle()),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Sign In",
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
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Sign In with Google",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            )
          : Container(child: CircularProgressIndicator()),
    );
  }
}