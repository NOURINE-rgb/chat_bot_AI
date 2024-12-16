import 'dart:io';

import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {this.profileImage,
      required this.from,
      required this.msg,
      required this.time,
      this.imagePath,
      super.key});
  final String? profileImage;
  final String? imagePath;
  final String from;
  final String msg;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          from == "gemini" ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (profileImage != null)
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 0.5,
                    blurRadius: 10,
                    offset: const Offset(1, 2)),
              ],
              image: DecorationImage(
                  image: AssetImage(profileImage!), fit: BoxFit.cover),
            ),
          ),
        Column(
          children: [
            if (imagePath != null)
              Container(
                height: 120,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: !imagePath!.startsWith('h')
                    ? Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        fit: BoxFit.fill,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(imagePath!)),
              ),
            Container(
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                constraints: const BoxConstraints(maxWidth: 240, minHeight: 34),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomRight: from == "gemini"
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomLeft: from != "gemini"
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                  ),
                  color: from == "gemini"
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                ),
                child: myText(
                  msg,
                  color: from == "gemini" ? Colors.white : Colors.black,
                  size: 14,
                )),
          ],
        ),
      ],
    );
  }
}
