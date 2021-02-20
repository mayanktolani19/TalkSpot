import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/screens/forgot_password.dart';
import 'package:talk_spot/screens/signup.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/toast.dart';
import 'package:talk_spot/widgets/widget.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) async {
        if (val != null) {
          await databaseMethods.getCurrentUser().then((val) {
            Provider.of<UserProvider>(context, listen: false)
                .updateName(val["name"]);
            Provider.of<UserProvider>(context, listen: false)
                .updateEmail(val["email"]);
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            showToast('Invalid email or password', Colors.red);
            isLoading = false;
          });
        }
      });
    }
  }

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
                              margin: EdgeInsets.symmetric(vertical: 8),
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
                                decoration: textFieldInputDecoration('Email',
                                    Icon(Icons.email, color: Colors.white)),
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
                              decoration: textFieldInputDecoration(
                                  'Password',
                                  Icon(Icons.lock_outline,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
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
                      GestureDetector(
                        onTap: () async {
                          String em = await authMethods.signInWithGoogle();
                          print(em);
                          if (em != null) {
                            Provider.of<UserProvider>(context, listen: false)
                                .updateEmail(em);
                            setState(() {
                              isLoading = true;
                            });
                            String name = await authMethods.getUserName();
                            Provider.of<UserProvider>(context, listen: false)
                                .updateName(name);
                            Map<String, dynamic> userMap = {
                              "name": name,
                              "email": em
                            };
                            await databaseMethods.uploadUserInfo(userMap, true);
                            if (em != null && name != null)
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoom()));
                          }
                        },
                        child: Container(
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
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
          : Center(child: Container(child: CircularProgressIndicator())),
    );
  }
}
