import 'package:flutter_lovelove_mychat/chat.dart';
import 'package:flutter_lovelove_mychat/chat_message_type.dart';
import 'package:flutter_lovelove_mychat/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class Bubble extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Chat chat;

  const Bubble({
    super.key,
    this.margin,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignmentOnType,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chat.type == ChatMessageType.received)
          const CircleAvatar(
            backgroundImage:
                AssetImage("assets/images/somi_profile_image_circle.png"),
          ),
        Container(
          margin: margin ?? EdgeInsets.zero,
          child: PhysicalShape(
            clipper: clipperOnType,
            elevation: 2,
            color: bgColorOnType,
            shadowColor: Colors.grey.shade200,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: paddingOnType,
              child: Column(
                crossAxisAlignment: crossAlignmentOnType,
                children: [
                  Text(
                    chat.message,
                    style: TextStyle(color: textColorOnType),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    Formatter.formatDateTime(chat.time),
                    style: TextStyle(color: textColorOnType, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Getter for alignment based on message type
  MainAxisAlignment get alignmentOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return MainAxisAlignment.end;
      case ChatMessageType.received:
        return MainAxisAlignment.start;
    }
  }

  // Getter for cross-axis alignment based on message type
  CrossAxisAlignment get crossAlignmentOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return CrossAxisAlignment.end;
      case ChatMessageType.received:
        return CrossAxisAlignment.start;
    }
  }

  // Getter for padding based on message type
  EdgeInsets get paddingOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
          right: 24,
        );
      case ChatMessageType.received:
        return const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 24,
          right: 10,
        );
    }
  }

  // Getter for background color based on message type
  Color get bgColorOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return const Color(0xFF007AFF);
      case ChatMessageType.received:
        return const Color(0xFFFFC5D3);
    }
  }

  // Getter for text color based on message type
  Color get textColorOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return Colors.white;
      case ChatMessageType.received:
        return const Color(0xFF0F0F0F);
    }
  }

  // Getter for clipper based on message type
  CustomClipper<Path> get clipperOnType {
    switch (chat.type) {
      case ChatMessageType.sent:
        return ChatBubbleClipper1(type: BubbleType.sendBubble);
      case ChatMessageType.received:
        return ChatBubbleClipper1(type: BubbleType.receiverBubble);
    }
  }
}
