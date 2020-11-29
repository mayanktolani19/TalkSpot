import 'package:flutter/material.dart';
import 'package:talk_spot/helper/helperfunctions.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userMap = {
        "name": usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };
      helperFunctions.saveUserEmail(emailTextEditingController.text);
      helperFunctions.saveUserName(usernameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userMap, false);
        helperFunctions.saveLoggedIn(true);
        print(val);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromRGBO(0, 0, 10, 10),
                    Color.fromRGBO(13, 35, 97, 80),
                  ])),
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 25),
                    Text(
                      'Register on TalkSpot!',
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: usernameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration(
                                  'User Name',
                                  Icon(
                                    Icons.supervised_user_circle,
                                    color: Colors.white,
                                  )),
                              validator: (val) {
                                return val.isEmpty
                                    ? "Please provide a UserName."
                                    : val.length < 3
                                        ? "UserName is too short."
                                        : null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: emailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration('Email',
                                  Icon(Icons.email, color: Colors.white)),
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please provide a valid email.";
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration(
                                  'Password',
                                  Icon(Icons.lock_outline,
                                      color: Colors.white)),
                              validator: (val) {
                                return val.isEmpty
                                    ? "Please provide a Password."
                                    : val.length < 6
                                        ? "Password is too short."
                                        : null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Sign Up",
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
//            SizedBox(height: 15),
//            Container(
//              alignment: Alignment.center,
//              width: MediaQuery.of(context).size.width,
//              padding: EdgeInsets.symmetric(vertical: 20),
//              child: Text(
//                "Sign In with Google",
//                style: TextStyle(fontSize: 17, color: Colors.black),
//              ),
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(30), color: Colors.white),
//            ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "SignIn Now",
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
    );
  }
}
