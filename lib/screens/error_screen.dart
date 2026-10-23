import 'package:evgo_clone/main.dart';
import 'package:evgo_clone/styles/styles.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen ({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreen();
}

class _ErrorScreen extends State<ErrorScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Spacer(),
                Image.asset("assets/images/error.png", width: 200, height: 200),
                Text("Ошибка", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Text("Произошла ошибка (код: 110). Пожалуйста, попробуйте еще раз.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: greenButton(
                    text: "Повторить",
                    onPressed: () async {
                      final screen = await getInitialScreen();
                      if (screen is! ErrorScreen){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => screen)
                        );
                      }
                    },
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        )
      )
    );
  }
}