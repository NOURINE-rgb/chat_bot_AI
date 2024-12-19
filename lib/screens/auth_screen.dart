import 'package:chat_boot/riverpod/signedup.dart';
import 'package:chat_boot/screens/reset_password/email.dart';
import 'package:chat_boot/widgets/animte_text.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

final firebaseAuth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance;

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool visible = true;
  bool isAuthenticated = false;
  String mode = "in";
  String enteredEmail = "";
  String password = "";
  String userName = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void storeInFireStore(
      String authProvider, UserCredential userCredential) async {
    if (!userCredential.additionalUserInfo!.isNewUser) {
      print('it\'s exist ****************');
      await fireStore.collection("users").doc(userCredential.user!.uid).update(
        {
          "lastSignIn": FieldValue.serverTimestamp(),
        },
      );
    } else {
      print('it\'s not exist ****************');
      ref.read(signedUpProvider.notifier).changeMode(true);
      await fireStore.collection("users").doc(userCredential.user!.uid).set({
        "userId": userCredential.user!.uid,
        "userName": authProvider == "email"
            ? userName
            : userCredential.user!.displayName,
        "authProvider": authProvider,
        "email":
            authProvider == "email" ? enteredEmail : userCredential.user!.email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  // douk min nji nsagem ta3 yro7 lel
  //page of user name  for google after that ot the contunnue screen for google and email
  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    try {
      setState(() {
        isAuthenticated = true;
      });
      if (mode == "in") {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: enteredEmail, password: password);
        storeInFireStore("email", userCredential);
      } else {
        final userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
                email: enteredEmail, password: password);
        storeInFireStore("email", userCredential);
        // ref.read(signedUpProvider.notifier).changeMode(true);
      }
    } on FirebaseAuthException catch (e) {
      print("Authentication failed ***************");
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(e.message ?? "Authentication Failed"),
          ),
        );
      }
      setState(() {
        isAuthenticated = false;
      });
    }
  }

  void signinGoogle() async {
    print("we are in the sign in with google method *************************");
    try {
      final userGoogle = await GoogleSignIn().signIn();
      print("$userGoogle *********************");
      if (userGoogle == null) {
        return;
      }
      final googleAuth = await userGoogle.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final userCredential = await firebaseAuth.signInWithCredential(cred);
      print("hhhhh *************************");
      storeInFireStore("google", userCredential);
      //storeInFireStore("google", userCredential);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("this the build method it's here ...........**");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 70, bottom: 50, right: 25, left: 25),
            child: Column(
              children: [
                const AnimateText(
                    speed: 50,
                    highlightText: "Gemini",
                    text: "Welcome to\nthe Gemini era"),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (mode == "up")
                        TextFormField(
                          initialValue: userName,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: "Full name",
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
                          validator: (value) {
                            if (value == null || value.trim().length < 4) {
                              return "Please enter at least 4 caracters";
                            }
                            return null;
                          },
                          onSaved: (newValue) => userName = newValue!,
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: enteredEmail,
                        keyboardType: TextInputType.emailAddress,
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
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains("@")) {
                            return "Error , please enter a valid email";
                          }
                          return null;
                        },
                        onSaved: (newValue) => enteredEmail = newValue!,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: password,
                        obscureText: visible,
                        decoration: InputDecoration(
                          hintText: "Your Password",
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                visible = !visible;
                              });
                            },
                            child: Icon(
                              !visible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                          ),
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
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return "enter a strong password with over 6 caracters";
                          }
                          return null;
                        },
                        onSaved: (newValue) => password = newValue!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (mode == "in")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              side: BorderSide(
                                  color: Colors.grey[500]!, width: 2.0),
                              value: false,
                              onChanged: (value) {},
                            ),
                            myText("Remember Me",
                                color: Colors.black,
                                size: 14,
                                weight: FontWeight.bold),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              ),
                              child: myText("Forget Password",
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 14,
                                  weight: FontWeight.bold),
                            ),
                          ],
                        ),
                      isAuthenticated
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: submit,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: myText("Sign $mode",
                                    color: Colors.white,
                                    size: 18,
                                    weight: FontWeight.w600),
                              ),
                            ),
                    ],
                  ),
                ),
                myText("or",
                    color: Colors.grey.shade700,
                    size: 15,
                    weight: FontWeight.w600),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: signinGoogle,
                  child: Container(
                    padding: const EdgeInsets.only(left: 25),
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/google.png",
                          width: 32,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        myText("Sign $mode with Google",
                            color: Colors.black54,
                            size: 15,
                            weight: FontWeight.w500),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign ${mode == "in" ? "up" : "in"}",
                        style: GoogleFonts.nunito(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              mode = (mode == "up") ? "in" : "up";
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
