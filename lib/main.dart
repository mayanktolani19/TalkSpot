import 'package:flutter/material.dart';
import 'package:talk_spot/helper/authenticate.dart';
import 'package:talk_spot/helper/helperfunctions.dart';
import 'package:talk_spot/screens/chat_rooms_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    getLoggedInStatus();
    super.initState();
  }

  getLoggedInStatus() async {
    await HelperFunctions().getLoggedIn().then((val) {
      setState(() {
        isLoggedIn = false;
        if (val != null) isLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xff145C9E),
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          primarySwatch: Colors.blue,
        ),
        home: isLoggedIn ? ChatRoom() : Authenticate());
  }
}
