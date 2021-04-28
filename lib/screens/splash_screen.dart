import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/services/database.dart';
import 'package:talk_spot/services/user_provider.dart';

class SplashScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  void initState() {
    super.initState();
    getLoggedInStatus();
  }

  getLoggedInStatus() {
    Timer(const Duration(milliseconds: 1000), () async {
      FirebaseAuth auth = FirebaseAuth.instance;
      var val = auth.currentUser;
      GoogleSignIn googleSignIn = GoogleSignIn();
      bool google = await googleSignIn.isSignedIn();
      print(google);
      if (val != null) {
        await databaseMethods.getUserByUid(auth.currentUser.uid).then((val) {
          Provider.of<UserProvider>(context, listen: false)
              .updateName(val["name"]);
          Provider.of<UserProvider>(context, listen: false)
              .updateEmail(val["email"]);
          Provider.of<UserProvider>(context, listen: false)
              .updateUid(auth.currentUser.uid);
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ));
      } else {
        Navigator.of(context).pushReplacementNamed(
          '/signIn',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/splash-icon.png',
            height: 80,
            width: 80,
          ),
          Text(
            'TalkSpot',
            style: TextStyle(color: Color(0xffFF6B51), fontSize: 32),
          )
        ],
      ),
    ));
  }
}
