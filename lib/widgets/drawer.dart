import 'dart:math';
import 'package:chat_boot/models/chat_message.dart';
import 'package:chat_boot/widgets/list_history.dart';
import 'package:chat_boot/widgets/my_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer(
      {required this.isOpen,
      required this.onTapHistory,
      required this.historyItemsQ,
      required this.historyItemsA,
      super.key});
  final bool isOpen;
  final List<ChatMessage> historyItemsQ;
  final List<ChatMessage> historyItemsA;
  final void Function(List<ChatMessage> messagesAQ) onTapHistory;
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();

  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    textFieldFocus.addListener(() {
      isSearching = textFieldFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  // let's do it whit the stack widget

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: !isSearching
          ? MediaQuery.of(context).size.width - 80
          : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                      if (!isSearching) {
                        textFieldFocus.unfocus();
                      } else {
                        textFieldFocus.requestFocus();
                      }
                    },
                    icon: Icon(
                      isSearching ? Icons.arrow_back : Icons.search,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: textFieldFocus,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: myText("chats",
                  color: Colors.black87, size: 15, weight: FontWeight.w700),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                      itemCount: widget.historyItemsQ.length,
                      itemBuilder: (context, index) {
                        print("$index ***************************");
                        return ItemHistory(
                            msg: widget.historyItemsQ[index],
                            onTap: () {
                              widget.onTapHistory(
                                [
                                  widget.historyItemsQ[index],
                                  widget.historyItemsA[index],
                                ],
                              );
                            });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Material(
                      child: ListTile(
                        tileColor: Colors.grey[50],
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          child: myText("N",
                              color: Colors.white,
                              weight: FontWeight.bold,
                              size: 20),
                        ),
                        title: const Text(
                          "NOURINE MOHAMED YACINE",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          //customize the listtile to be transparent to se what behind it
                          // that mean the hitory
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final shouldSignOut = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Sign Out"),
                                  content: const Text(
                                      "Are you sure you want to sign out?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(false); // Cancel
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(true); // Confirm
                                      },
                                      child: const Text("Confirm"),
                                    ),
                                  ],
                                );
                              },
                            );
                            // If the user clicks "Confirm", perform sign-out logic
                            if (shouldSignOut == true) {
                              FirebaseAuth.instance.signOut();
                            }
                          },
                          icon: Transform.rotate(
                            angle: pi,
                            child: const Icon(
                              Icons.logout,
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
