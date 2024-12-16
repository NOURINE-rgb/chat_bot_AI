import 'package:chat_boot/models/chat_message.dart';
import 'package:flutter/material.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory({required this.msg, required this.onTap, super.key});
  final ChatMessage msg;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      title: Text(
        msg.text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.delete),
    );
  }
}
