import 'package:flutter/material.dart';
import 'package:flutter_lovelove_mychat/chat.dart';
import 'package:flutter_lovelove_mychat/chat_message_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatController extends ChangeNotifier {
  /* Variables */
  List<Chat> chatList = [];

  /* Controllers */
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  /* 소미의 프롬프트 */
  String somiPrompt = '';

  /* Private Variables */
  final List<Map<String, String>> _conversationHistory = [];

  /* Constructor */
  ChatController() {
    _initializePrompt();
  }

  Future<void> _initializePrompt() async {
    try {
      somiPrompt =
          await rootBundle.loadString('assets/texts/gpt4o_somi_prompt.txt');
      // 시스템 프롬프트를 대화 내역에 추가
      _conversationHistory.add({'role': 'system', 'content': somiPrompt});
      notifyListeners();
    } catch (e) {
      print("Failed to load the prompt: $e");
    }
  }

  /* Intents */
  Future<void> onFieldSubmitted() async {
    if (!isTextFieldEnable) return;

    String userMessage = textEditingController.text.trim();
    if (userMessage.isEmpty) return;

    // 사용자의 메시지를 채팅 목록에 추가
    chatList.add(Chat.sent(message: userMessage));
    notifyListeners();

    // 대화 내역에 사용자 메시지 추가
    _conversationHistory.add({'role': 'user', 'content': userMessage});

    // 텍스트 필드 초기화
    textEditingController.clear();

    // 스크롤을 맨 아래로 이동
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // GPT로부터 응답 받기
    await getResponseFromGPT();
  }

  void onFieldChanged(String term) {
    notifyListeners();
  }

  /* Getters */
  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;

  /* Method to interact with GPT */
  Future<void> getResponseFromGPT() async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      print('API 키가 없습니다. .env 파일을 확인하세요.');
      // 에러 메시지를 채팅 목록에 추가
      chatList.add(Chat(
        message: 'Error: API 키가 없습니다. .env 파일을 확인하세요.',
        type: ChatMessageType.received,
        time: DateTime.now(),
      ));
      notifyListeners();
      return;
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final data = {
      'model': 'gpt-3.5-turbo',
      'messages': _conversationHistory,
      'max_tokens': 150,
      'temperature': 0.7,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      print('응답 상태 코드: ${response.statusCode}');
      print('응답 본문: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final resData = json.decode(utf8.decode(response.bodyBytes));
        final content = resData['choices'][0]['message']['content'].trim();

        // GPT의 응답을 채팅 목록에 추가
        chatList.add(Chat(
          message: content,
          type: ChatMessageType.received,
          time: DateTime.now(),
        ));
        notifyListeners();

        // 대화 내역에 GPT 응답 추가
        _conversationHistory.add({'role': 'assistant', 'content': content});

        // 스크롤을 맨 아래로 이동
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // 에러 처리
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = errorData['error']['message'];
        print('GPT 응답 실패: $errorMessage');

        // 에러 메시지를 채팅 목록에 추가
        chatList.add(Chat(
          message: 'Error: $errorMessage',
          type: ChatMessageType.received,
          time: DateTime.now(),
        ));
        notifyListeners();
      }
    } catch (e) {
      print('GPT와 통신 중 오류 발생: $e');

      // 에러 메시지를 채팅 목록에 추가
      chatList.add(Chat(
        message: 'Error: $e',
        type: ChatMessageType.received,
        time: DateTime.now(),
      ));
      notifyListeners();
    }
  }
}
