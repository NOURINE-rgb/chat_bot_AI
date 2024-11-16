import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(top: 70, bottom: 50, right: 25, left: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              myText("Welcome to\nthe Gemini era",
                  color: Colors.black,
                  weight: FontWeight.bold,
                  size: 30,
                  textalign: TextAlign.center),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        iconColor: Colors.grey[100],
                        hintText: "Your Email Address",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                              color: Colors.grey[300]!), // Default border
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 1.5), // On focus
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Your Password",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                              color: Colors.grey[300]!), // Default border
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 1.5), // On focus
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          side:
                              BorderSide(color: Colors.grey[500]!, width: 2.0),
                          value: false,
                          onChanged: (value) {},
                        ),
                        myText("Remember Me",
                            color: Colors.black,
                            size: 14,
                            weight: FontWeight.bold),
                        const SizedBox(
                          width: 100,
                        ),
                        myText("Forget Password",
                            color: Theme.of(context).colorScheme.primary,
                            size: 14,
                            weight: FontWeight.bold),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: myText("Sign in",
                          color: Colors.white,
                          size: 18,
                          weight: FontWeight.w600),
                    ),
                    myText("or Sign in with",
                        color: Colors.grey.shade700,
                        size: 15,
                        weight: FontWeight.w600),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 65,
                          width: 65,
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 3,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                "assets/google.png",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 65,
                          height: 65,
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 3,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                "assets/fc.png",
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black),
                  children: [
                    TextSpan(
                        text: "Sign up",
                        style: GoogleFonts.nunito(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("sing up clickable ***********");
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
