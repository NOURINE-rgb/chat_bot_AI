import 'dart:async';
import 'dart:math';

import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';

class AnimateText extends StatefulWidget {
  const AnimateText(
      {required this.speed,
      required this.text,
      required this.highlightText,
      super.key});
  final String text;
  final int speed;

  final String highlightText;
  @override
  State<AnimateText> createState() {
    return _AnimateTextState();
  }
}

class _AnimateTextState extends State<AnimateText>
    with TickerProviderStateMixin {
  late Timer timer;
  late Random random;
  late ValueNotifier<String> displayText;
  late AnimationController _controller;
  late Animation myAnimation;
  Alignment _alignmentBegin = Alignment.topRight;
  Alignment _alignmentEnd = Alignment.bottomLeft;
  int currectIndex = 0;
  @override
  void initState() {
    super.initState();
    displayText = ValueNotifier<String>("");
    startTyping();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    ColorTween tween = ColorTween(
        begin: Colors.blue, end: const Color.fromARGB(255, 175, 126, 51));
    myAnimation = tween.animate(_controller);
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          changeGradient();
        }
      },
    );
    random = Random();
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    displayText.dispose();
    super.dispose();
  }

  void changeGradient() {
    _alignmentBegin =
        Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
    _alignmentEnd =
        Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
  }

  void startTyping() {
    timer = Timer.periodic(
      Duration(milliseconds: widget.speed),
      (timer) {
        if (currectIndex < widget.text.length) {
          displayText.value += widget.text[currectIndex];
          currectIndex++;
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("this the second build ***************");
    return AnimatedBuilder(
      animation: myAnimation,
      builder: (context, child) => ValueListenableBuilder<String>(
        valueListenable: displayText,
        builder: (context, value, child) {
          final parts = value.split(widget.highlightText);
          final bool hilights =
              (parts.length > 1 && value.contains(widget.highlightText));
          return RichText(
            text: TextSpan(
              text: parts.first,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.blue,
              ),
              children: [
                if (hilights)
                  TextSpan(
                    text: widget.highlightText,
                    style: TextStyle(color: myAnimation.value),
                  ),
                if (parts.length > 1) TextSpan(text: parts.last),
              ],
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
