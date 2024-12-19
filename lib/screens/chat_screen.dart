import 'dart:convert';
import 'dart:io';
import 'package:chat_boot/data/question_data.dart';
import 'package:chat_boot/riverpod/is_listining_provider.dart';
import 'package:chat_boot/screens/auth_screen.dart';
import 'package:chat_boot/services/speech_to_text.dart';
import 'package:chat_boot/widgets/chat_bubble.dart';
import 'package:chat_boot/models/chat_message.dart';
import 'package:chat_boot/widgets/drawer.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:chat_boot/widgets/question_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController textController = TextEditingController();
  late MySpeechToText speachToTextHelper;
  bool open = false;
  bool isListening = false;
  List<ChatMessage> historyItemsQ = [];
  List<ChatMessage> historyItemsA = [];
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;
  void onTapQuestion(String msg) {
    setState(() {
      onSend(msg, null);
    });
  }

  @override
  void initState() {
    super.initState();
    speachToTextHelper = MySpeechToText(ref: ref);
    speachToTextHelper.initSpeech();
    loading();
  }

  void resultText(String result) {
    print("result text function ********************\n");
    setState(() {
      print('$result ***********************\n');
      textController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    isListening = ref.watch(isListiningProvider);
    print("update the ui islisttening is $isListening ***************");
    Widget content = (messages.isEmpty)
        ? Expanded(
            child: ListView(
              children: [
                for (final question in questions)
                  QuestionIcon(
                    question: question,
                    onTap: onTapQuestion,
                  ),
              ],
            ),
          )
        : Expanded(
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
          );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: myText("Gemini Chat",
            size: 20,
            weight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
      ),
      drawer: MyDrawer(
        isOpen: open,
        onTapHistory: onTapHistory,
        historyItemsA: historyItemsA,
        historyItemsQ: historyItemsQ,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // padding: const EdgeInsets.all(12),/
        child: Column(
          children: [
            content,
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
                onPressed: () {
                  isListening
                      ? speachToTextHelper.stopListening()
                      : speachToTextHelper.startListening(resultText);
                },
                icon: Icon(
                  isListening ? Icons.mic_off : Icons.mic,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    // text = textController.text;
                    onSend(textController.text, null);
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

  void onTapHistory(List<ChatMessage> messagesAQ) {
    setState(() {
      messages = messagesAQ;
    });
  }

  void addMessageFireStore(String sender, FieldValue time, String userId,
      String message, String? imageUrl) async {
    final Map<String, dynamic> chatMessage = {
      "time": time,
      "text": message,
      "msgProvider": sender,
      "imageUrl": imageUrl,
    };
    try {
      await fireStore
          .collection("chat")
          .doc(userId)
          .collection("messages")
          .add(chatMessage);
    } catch (e) {
      print("error occured: $e  ************************");
    }
  }

  void loading() async {
    final history = await fireStore
        .collection("chat")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("messages")
        .orderBy("time", descending: true)
        .get();
    for (final h in history.docs) {
      print("***************************");
      Timestamp time = h.data()["time"];
      final imagePath = h.data()["imageUrl"];
      if (h.data()["msgProvider"] != "gemini") {
        setState(() {
          historyItemsQ = [
            ...historyItemsQ,
            ChatMessage(
              id: h.id,
              user: "user",
              time: time.toDate(),
              text: h.data()["text"],
              imagePath: imagePath,
            ),
          ];
        });
      } else {
        historyItemsA = [
          ...historyItemsA,
          ChatMessage(
            id: h.id,
            user: "gemini",
            time: time.toDate(),
            text: h.data()["text"],
          ),
        ];
      }
    }
  }

  Future<String> uploadImageToCloudinary(
    String imagePath,
  ) async {
    print("we are in upload image function ***********************");
    String imageUrl = "";
    const String cloudName = "dsmzourse";
    const String uploadPreset = "my_preset";
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest(
      "POST",
      url,
    )
      ..fields["upload_preset"] = uploadPreset
      ..files.add(
        await http.MultipartFile.fromPath('file', imagePath),
      );
    try {
      print("request send ******************in process");
      final response = await request.send();
      if (response.statusCode == 200) {
        print("response == 200 so it's successful");
        final responseBody = await response.stream.bytesToString();
        var responseJson = json.decode(responseBody);
        imageUrl = responseJson["secure_url"];
        print(
            "it's uploaded successfully : $responseBody  **************************");
      } else {
        // If the upload failed, print the error code
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("error occured : $e");
    }
    return imageUrl;
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

  void onSend(String message, ChatMessage? image) async {
    String question = message;
    final userId = firebaseAuth.currentUser!.uid;
    String imageUrl = "";
    ChatMessage chatmessage = image ??
        ChatMessage(
          id: "0",
          user: "user",
          time: DateTime.now(),
          text: message,
        );
    setState(() {
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
          .listen((event) async {
        print("we are generating the response here");
        ChatMessage? lastMessage = messages.lastOrNull;
        if (lastMessage != null && lastMessage.user == "gemini") {
          String response = event.content!.parts!.fold(
            "",
            (previousValue, element) => "$previousValue ${element.text}",
          );
          lastMessage.text += response;
          final lastOne = await fireStore
              .collection("chat")
              .doc(userId)
              .collection('messages')
              .orderBy("time", descending: true)
              .limit(1)
              .get();
          if (lastOne.docs.isNotEmpty) {
            await lastOne.docs.first.reference.update({
              "text": lastMessage.text,
            });
          }
          setState(() {});
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
          addMessageFireStore(
              "gemini", FieldValue.serverTimestamp(), userId, response, "");
        }
      });
    } catch (e) {
      print(e);
    } finally {
      // add the deleted code to add the msg of the user in firestore and the image and delete the
      // imageurl from  the gemini msg

      if (image != null) {
        print("image not null *************************");
        imageUrl = await uploadImageToCloudinary(image.imagePath!);
        print("$imageUrl ***********************");
      }
      addMessageFireStore(
          "user", FieldValue.serverTimestamp(), userId, question, imageUrl);
    }
    //
  }
}
