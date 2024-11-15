import 'package:chat_boot/constants.dart';
import 'package:chat_boot/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // FlutterNativeSplash.preserve(
  //   widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  // );
  Gemini.init(apiKey: gemini_Api_Key);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF3369FF),
        ),
      ),
      home: const SecondScreen(),
    );
  }
}


// send message from gemini and make it in hte right order
