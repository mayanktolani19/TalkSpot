import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      if (val != null) {
        await databaseMethods.getCurrentUser().then((val) {
          Provider.of<UserProvider>(context, listen: false)
              .updateName(val["name"]);

          Provider.of<UserProvider>(context, listen: false)
              .updateEmail(val["email"]);
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
    return Container(child: Text('hi'));
  }
}
