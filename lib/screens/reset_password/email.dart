import 'package:chat_boot/screens/auth_screen.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController controller = TextEditingController();
  bool isSubmiting = false;
  void submit() async {
    print("${controller.text}**********************************");
    //  i will make it better tomorrow inchalah
    if (controller.text.trim().isEmpty || !controller.text.contains("@")) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email address."),
        ),
      );
      return;
    }
    setState(() {
      isSubmiting = true;
    });
    try {
      final queryOption = await fireStore
          .collection("users")
          .where("email", isEqualTo: controller.text)
          .get();
      print("$queryOption **********************************");
      final isEmailExist =
          await firebaseAuth.fetchSignInMethodsForEmail(controller.text);
      for (final email in isEmailExist) {
        print("$email **********************");
      }
      await firebaseAuth.sendPasswordResetEmail(
        email: controller.text,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("the link to change your password has been sent to your email"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      switch (e.code) {
        case "invalid-email":
          message = "invalid email please enter a valid one";
          break;
        case "user-not-found":
          message = "user not found";
          break;
        default:
          message = "An unxpected error occured. Please try again later";
          break;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("unexpected  error occured. Please try again later"),
        ),
      );
      print("$e *******************");
    } finally {
      setState(() {
        isSubmiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/safe.jpg",
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 2 -
                      50,
                ),
                const SizedBox(
                  height: 15,
                ),
                myText("forget \nPassword?",
                    size: 35,
                    weight: FontWeight.w700,
                    textalign: TextAlign.start,
                    color: Colors.black.withOpacity(0.9)),
                const SizedBox(
                  height: 15,
                ),
                myText(
                    "don't worry it happens, Please enter the \nassociated with your account.",
                    size: 16,
                    textalign: TextAlign.start,
                    weight: FontWeight.w600,
                    color: Colors.black.withBlue(50)),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    hintText: "@ Email ID",
                    hintStyle: TextStyle(color: Colors.grey[600]!),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () => submit(),
                  child: Container(
                    // margin: const EdgeInsets.only(right: 23, left: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: isSubmiting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : myText("Submit",
                            color: Colors.white,
                            size: 19,
                            weight: FontWeight.w700),
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
