import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool visible = false;
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
              const EdgeInsets.only(top: 10, bottom: 7, left: 30, right: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/fingerprint.svg",
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 2 -
                      100,
                ),
                const SizedBox(
                  height: 15,
                ),
                myText("Reset \nPassword",
                    size: 35,
                    weight: FontWeight.w700,
                    textalign: TextAlign.start,
                    color: Colors.black.withOpacity(0.9)),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: !visible,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    hintText: "New password",
                    hintStyle: TextStyle(color: Colors.grey[600]!),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: !visible,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    hintText: "Confirm new password",
                    hintStyle: TextStyle(color: Colors.grey[600]!),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: visible,
                      activeColor: Theme.of(context).colorScheme.secondary,
                      onChanged: (value) {
                        setState(() {
                          visible = value!;
                        });
                      },
                    ),
                    myText("Show Password",
                        size: 14, weight: FontWeight.w600, color: Colors.black),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    // margin: const EdgeInsets.only(right: 23, left: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
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
