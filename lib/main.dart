import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_spot/screens/splash_screen.dart';
import 'package:talk_spot/services/routing.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
      ],
      child: KeyboardDismissOnTap(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color(0xff145C9E),
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
