import 'package:flutter_lovelove_mychat/chat_message_type.dart';

class Chat {
  final String message;
  final ChatMessageType type;
  final DateTime time;

  Chat({required this.message, required this.type, required this.time});

  factory Chat.sent({required String message}) => Chat(
        message: message,
        type: ChatMessageType.sent,
        time: DateTime.now(),
      );

  // Remove or comment out the generate() method
}
