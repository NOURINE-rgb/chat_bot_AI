class ChatMessage {
  ChatMessage(
      {required this.id,
      required this.user,
      required this.time,
      required this.text,
      this.profileImage,
      this.imagePath,
      });
  final String id;
  final String user;
  String text;
  final DateTime time;
  final String? profileImage;
  final String? imagePath;
}
