import 'package:chat_boot/screens/chat_screen.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 100),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 15, left: 50, right: 10),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myText("Continue",
                  color: Colors.white, size: 26, weight: FontWeight.w500),
              const SizedBox(
                width: 80,
              ),
              const Icon(
                Icons.arrow_forward_outlined,
                color: Colors.white,
                size: 24,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              height: 250,
              width: 340,
              child: Column(
                children: [
                  myText("Your AI Assistant",
                      color: Theme.of(context).colorScheme.primary,
                      size: 23,
                      weight: FontWeight.bold),
                  const SizedBox(
                    height: 15,
                  ),
                  myText(
                    "Using this software you can ask you\nquestions and recieve articles using\nartificiel intelligence assistant",
                    size: 15,
                    textalign: TextAlign.center,
                    color: Colors.grey[600]!,
                  )
                ],
              ),
            ),
            Center(
              child: Image.asset(
                "assets/descrip.png",
                width: 320,
                height: 324,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
