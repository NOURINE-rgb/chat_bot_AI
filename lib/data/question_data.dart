import 'package:chat_boot/models/question.dart';
import 'package:flutter/material.dart';

List<Question> questions = [
  const Question(
    iconPath: "assets/email.png",
    title: "Explain",
    questions: [
      "Explain quantum physics",
      "What are wormholes explain like i am 5",
    ],
  ),
  const Question(
    iconPath: "assets/pencil.png",
    title: "Write & edit",
    questions: [
      "Write a tweet about global  warming",
      "Write a poem about flower and love",
      "Write a rap song lyrics about",
    ],
  ),
  const Question(
    iconPath: "assets/translate.png",
    title: "Translate",
    questions: [
      "How do you say \"how are you\"in korean?",
      "How do you say \"how are you\"in arabic?",
    ],
  ),
];
const colorizeColors = [
  // Colors.purple,
  Colors.blue,
  Color.fromARGB(255, 219, 167, 89)
];
