import 'package:flutter/material.dart';
import 'package:talk_spot/screens/signin.dart';
import 'package:talk_spot/screens/signup.dart';
import 'package:talk_spot/screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => SignUp());
    }
  }
}
