import 'package:chat_boot/screens/reset_password/otp_screen.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtpScreen(),
                    ),
                  ),
                  child: Container(
                    // margin: const EdgeInsets.only(right: 23, left: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: myText("Submit",
                        color: Colors.white, size: 19, weight: FontWeight.w700),
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
