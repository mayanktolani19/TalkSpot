import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_spot/helper/authenticate.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';
import 'package:talk_spot/screens/signin.dart';

class SplashScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getLoggedInStatus();
  }

  getLoggedInStatus() {
    Timer(const Duration(milliseconds: 1000), () async {
      FirebaseAuth auth = FirebaseAuth.instance;
      var val = auth.currentUser;
      if (val != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ));
      } else {
        print("hi");
        Navigator.of(context).pushReplacementNamed(
          '/signIn',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('hi'));
  }
}
