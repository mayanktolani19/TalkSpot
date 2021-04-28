import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/screens/forgot_password.dart';
import 'package:talk_spot/screens/signup.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/colors.dart';
import 'package:talk_spot/widgets/widget.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
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
          await databaseMethods.getCurrentUser().then((val2) {
            Provider.of<UserProvider>(context, listen: false)
                .updateName(val2["name"]);
            Provider.of<UserProvider>(context, listen: false)
                .updateEmail(val2["email"]);
            Provider.of<UserProvider>(context, listen: false)
                .updateUid(auth.currentUser.uid);
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    User user = await authMethods.signInWithGoogle();
    print(user);
    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).updateEmail(user.email);
      Provider.of<UserProvider>(context, listen: false)
          .updateName(user.displayName);
      Provider.of<UserProvider>(context, listen: false).updateUid(user.uid);
      Map<String, dynamic> userMap = {
        "name": user.displayName,
        "email": user.email
      };
      await databaseMethods.uploadUserInfo(userMap, true, user.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Container(
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
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Image.asset(
                          'assets/images/splash-icon.png',
                          height: 64,
                          width: 64,
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
                                decoration: textFieldInputDecoration(
                                    'Email',
                                    Icon(
                                      Icons.email,
                                    )),
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
                                  Icon(
                                    Icons.lock_outline,
                                  )),
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
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              await signIn();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            style: buttonStyle),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              await signInWithGoogle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Sign In with Google",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            style: buttonStyle),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signUp');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                    fontSize: 17,
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
