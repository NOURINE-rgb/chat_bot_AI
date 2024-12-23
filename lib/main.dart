import 'package:chat_boot/constants.dart';
import 'package:chat_boot/firebase_options.dart';
import 'package:chat_boot/riverpod/signedup.dart';
import 'package:chat_boot/screens/auth_screen.dart';
import 'package:chat_boot/screens/chat_screen.dart';
import 'package:chat_boot/screens/second_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';


//min nji men sport nzid ta3 retrieve data the image ofc
// and show it normally 
// and ofv from voice to text

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: gemini_Api_Key);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedUp = ref.watch(signedUpProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF3369FF),
          secondary: const Color.fromARGB(255, 57, 157, 239),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print(isSignedUp);
          if (snapshot.hasData & !isSignedUp) {
            return const ChatScreen();
          } else if (!isSignedUp) {
            print("maind dart authscreen *************");
            return const AuthScreen();
          }
          print("maind dart secondscreen *************");
          return const SecondScreen();
        },
      ),
    );
  }
}
// i need the package of flutter_fotnev to store the envirenment variable
// handle the multiple language in speech to text
// handle the voice message to text
// don't forget to push the code to github right !