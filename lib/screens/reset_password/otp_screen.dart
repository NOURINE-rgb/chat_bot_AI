import 'package:chat_boot/screens/reset_password/new_password.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<TextEditingController> controllers;
  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      4,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void verifyOtp(String otp) {
    // i will handle this later when i learn how to build my own backend
    if (otp == "1234") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewPassword(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('the otp code is wrong'),
        ),
      );
    }
  }

  String get getOtp {
    String otp = "";
    controllers.map(
      (e) {
        otp += e.value.text;
      },
    );
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 30, left: 30, right: 30),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/otp.svg",
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 2 -
                        50,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  myText("Enter OTP",
                      size: 35,
                      weight: FontWeight.w700,
                      textalign: TextAlign.start,
                      color: Colors.black.withOpacity(0.9)),
                  const SizedBox(
                    height: 15,
                  ),
                  // nzid email address li raslouh hna
                  myText(
                      "An 4 digit code has been sent to\nemail addres nwirah.",
                      size: 16,
                      textalign: TextAlign.start,
                      weight: FontWeight.w600,
                      color: Colors.black.withBlue(50)),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: List<Widget>.generate(
                      4,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 40,
                        child: TextField(
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      final String otp = getOtp;
                      verifyOtp(otp);
                    },
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
      ),
    );
  }
}
