import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screen/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    print(
      "API Key loaded: ${dotenv.env['GEMINI_API_KEY']?.substring(0, 5)}...",
    );
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(const LocalAIApp());
}

class LocalAIApp extends StatelessWidget {
  const LocalAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
