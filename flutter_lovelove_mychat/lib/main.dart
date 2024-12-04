import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 이 줄을 추가하세요
import 'package:provider/provider.dart';
import 'package:flutter_lovelove_mychat/chat_controller.dart';
import 'package:flutter_lovelove_mychat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 플러그인 초기화
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with GPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF007AFF),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => ChatController(),
        child: const ChatScreen(),
      ),
    );
  }
}
