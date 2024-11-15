import 'package:chat_boot/models/question.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';

class QuestionIcon extends StatelessWidget {
  const QuestionIcon({required this.question, required this.onTap, super.key});
  final Question question;
  final void Function(String msg) onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          question.iconPath,
          width: 40,
          color: Colors.black,
        ),
        myText(question.title,
            color: Colors.black, size: 14, weight: FontWeight.bold),
        const SizedBox(
          height: 20,
        ),
        for (int index = 0; index < question.questions.length; index++)
          InkWell(
            onTap: () => onTap(question.questions[index]),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 40,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade100,
              ),
              alignment: Alignment.center,
              child: myText(question.questions[index],
                  color: Colors.black, size: 14),
            ),
          ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
