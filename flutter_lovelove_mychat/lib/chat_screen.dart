// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lovelove_mychat/chat_controller.dart';
import 'package:flutter_lovelove_mychat/chat.dart';
import 'package:flutter_lovelove_mychat/bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = context.read<ChatController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("소미와의 채팅 💖"),
        backgroundColor: const Color(0xFFFFC5D3),
      ),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Opacity(
              opacity: 0.8, // 투명도 설정 (0.0 = 완전 투명, 1.0 = 완전 불투명)
              child: Image.asset(
                "assets/images/somi_background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 내용물 추가
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    chatController.focusNode.unfocus();
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Selector<ChatController, List<Chat>>(
                      selector: (context, controller) =>
                          controller.chatList.reversed.toList(),
                      builder: (context, chatList, child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          padding: const EdgeInsets.only(top: 12, bottom: 20) +
                              const EdgeInsets.symmetric(horizontal: 12),
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 12,
                          ),
                          controller: chatController.scrollController,
                          itemCount: chatList.length,
                          itemBuilder: (context, index) {
                            return Bubble(chat: chatList[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              const _BottomInputField(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom Fixed Field
class _BottomInputField extends StatelessWidget {
  const _BottomInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = context.read<ChatController>();

    return SafeArea(
      bottom: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // 배경색 투명도 조절
          border: const Border(
            top: BorderSide(
              color: Color(0xFFE5E5EA),
            ),
          ),
        ),
        child: Stack(
          children: [
            TextField(
              focusNode: chatController.focusNode,
              onChanged: chatController.onFieldChanged,
              controller: chatController.textEditingController,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  right: 42,
                  left: 16,
                  top: 18,
                ),
                hintText: '메시지를 입력하세요...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            // 전송 버튼
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/send.svg",
                  colorFilter: ColorFilter.mode(
                    context.select<ChatController, bool>(
                            (value) => value.isTextFieldEnable)
                        ? const Color(0xFF007AFF)
                        : const Color(0xFFBDBDC2),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: chatController.isTextFieldEnable
                    ? chatController.onFieldSubmitted
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
