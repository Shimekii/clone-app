// import 'package:evgo_clone/screens/map_screen.dart';
import 'package:evgo_clone/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isRegistered = prefs.getBool("isLoggedIn") ?? false;
  final Widget initialScreen;

  if (!isRegistered){
    initialScreen = const RegisterScreen();
  } else {
    initialScreen = const MapScreen();
  }


  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialScreen
  });
    final Widget initialScreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialScreen
    );
  }
}