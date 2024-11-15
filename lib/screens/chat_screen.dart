import 'dart:io';
import 'dart:typed_data';

import 'package:chat_boot/widgets/chat_bubble.dart';
import 'package:chat_boot/models/chat_message.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  String? text;
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: myText("Gemini Chat", size: 20),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // padding: const EdgeInsets.all(12),/
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) => ChatBubble(
                    from: messages[messages.length - index - 1].user,
                    profileImage:
                        messages[messages.length - index - 1].profileImage,
                    imagePath: messages[messages.length - index - 1].imagePath,
                    msg: messages[messages.length - index - 1].text,
                    time: messages[messages.length - index - 1].time),
              ),
            ),
            inputMessage(),
          ],
        ),
      ),
    );
  }

  Widget inputMessage() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 80,
          padding: const EdgeInsets.only(
            left: 20,
          ),
          margin: const EdgeInsets.only(bottom: 20, left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your message",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.mic,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    text = textController.text;
                    onSend(text!, null);
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 10),
          child: IconButton(
            onPressed: sendImage,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  void sendImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    String imagePath = pickedImage.path;
    final chatMessage = ChatMessage(
        id: "0",
        user: "user",
        time: DateTime.now(),
        text: "describe the image",
        imagePath: imagePath);
    onSend("describe the image", chatMessage);
  }

  void onSend(String message, ChatMessage? image) {
    String question = message;
    ChatMessage chatmessage = image ??
        ChatMessage(
          id: "0",
          user: "user",
          time: DateTime.now(),
          text: message,
        );
    setState(() {
      text = null;
      textController.clear();
      messages.add(chatmessage);
    });
    FocusScope.of(context).unfocus();
    List<Uint8List>? images =
        image == null ? [] : [File(image.imagePath!).readAsBytesSync()];
    try {
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        print("we are generating the response here");
        ChatMessage? lastMessage = messages.lastOrNull;
        if (lastMessage != null && lastMessage.user == "gemini") {
          String response = event.content!.parts!.fold(
            "",
            (previousValue, element) => "$previousValue ${element.text}",
          );
          setState(() {
            lastMessage.text += response;
          });
        } else {
          String response = event.content!.parts!.fold(
            "",
            (previousValue, element) => "$previousValue ${element.text}",
          );
          print("$response this our response ***********");
          ChatMessage newMessage = ChatMessage(
              id: "1",
              user: "gemini",
              time: DateTime.now(),
              profileImage: "assets/robot.png",
              text: response);
          setState(() {
            messages.add(newMessage);
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
