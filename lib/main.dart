import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:talk_spot/screens/splash_screen.dart';
import 'package:talk_spot/services/routing.dart';
import 'package:talk_spot/services/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialise();
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
        child: Center(
          child: ThemeBuilder(
            defaultThemeMode: ThemeMode.light,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              accentColor: Color(0xffFF6B51),
              buttonColor: Color(0xffFF6B51),
              appBarTheme: AppBarTheme(color: Color(0xffFF6B51)),
            ),
            lightTheme: ThemeData(
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(color: Color(0xffFF6B51)),
              buttonColor: Color(0xffFF6B51),
              accentColor: Color(0xffFF6B51),
            ),
            builder: (context, lightTheme, darkTheme, themeMode) => MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              home: SplashScreen(),
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          ),
        ),
      ),
    );
  }
}
