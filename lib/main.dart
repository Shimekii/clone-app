// import 'package:evgo_clone/screens/map_screen.dart';
import 'package:evgo_clone/screens/error_screen.dart';
import 'package:evgo_clone/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/register_screen.dart';
import 'package:http/http.dart' as http;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<Widget> getInitialScreen() async{
  final prefs = await SharedPreferences.getInstance();
  bool isRegistered = prefs.getBool("isLoggedIn") ?? false;
  final Widget initialScreen;

  bool hasInternet = await checkInternet();

  if (!isRegistered && hasInternet){
    initialScreen = const RegisterScreen();
  } else if (isRegistered && hasInternet) {
    initialScreen = const MapScreen();
  } else {
    initialScreen = const ErrorScreen();
  }
  return initialScreen;
}

Future<bool> checkInternet() async {
  try {
    final response = await http
                    .get(Uri.parse("https://tile.openstreetmap.org/0/0/0.png"))
                    .timeout(const Duration(seconds: 3));

    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Widget> _initialScreen = getInitialScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _initialScreen,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorScreen();
          }
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}