import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/screens/signin.dart';
import 'package:talk_spot/services/auth.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:talk_spot/widgets/widget.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
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
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) async {
        if (val) {
          await databaseMethods.uploadUserInfo(
              userMap, false, auth.currentUser.uid);
          Provider.of<UserProvider>(context, listen: false)
              .updateEmail(emailTextEditingController.text);
          Provider.of<UserProvider>(context, listen: false)
              .updateName(usernameTextEditingController.text);
          Provider.of<UserProvider>(context, listen: false)
              .updateUid(auth.currentUser.uid);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              alignment: Alignment.center,
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
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Image.asset('assets/images/splash-icon.png',
                          height: 64, width: 64),
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
                              decoration: textFieldInputDecoration(
                                  'Email',
                                  Icon(
                                    Icons.email,
                                  )),
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
                                  Icon(
                                    Icons.lock_outline,
                                  )),
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
                    SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {
                            await signMeUp();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Sign Up",
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
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/signIn');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "SignIn Now",
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
    );
  }
}
