import 'package:flutter/material.dart';
import 'package:simple_gemini/api/gemini_service.dart';
import 'dart:async';

import 'package:simple_gemini/models/message.dart';
import 'package:simple_gemini/screen/welcome_screen.dart';
import 'package:simple_gemini/widgets/chat_bubble.dart';
import 'package:simple_gemini/widgets/thinking_indicator.dart';
import 'package:simple_gemini/widgets/typing_indicator.dart';
import 'package:simple_gemini/widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;
  bool _isThinking = false;
  String _currentTypingText = '';
  final AIService _aiService = AIService();
  final ScrollController _scrollController = ScrollController();

  bool _showWelcomeScreen = true;

  final List<String> _greetingKeywords = [
    'halo',
    'Halo',
    'hallo',
    'Hallo',
    'hai',
    'hi',
    'hello',
    'siapa kamu',
    'siapa',
    'perkenalkan',
    'selamat pagi',
    'selamat siang',
    'selamat sore',
    'selamat malam',
  ];
  late List<AnimationController> _dotControllers;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 900),
      )..repeat(),
    );
  }

  @override
  void dispose() {
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isGreeting(String text) {
    final lowercaseText = text.toLowerCase();
    return _greetingKeywords.any((keyword) => lowercaseText.contains(keyword));
  }

  void _scrollToBottom() {
    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _simulateTyping(String text) async {
    if (!mounted) return;

    setState(() {
      _isTyping = true;
      _isThinking = false;
      _currentTypingText = '';
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    for (int i = 0; i < text.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 30));

      if (!mounted) return;
      setState(() {
        _currentTypingText = text.substring(0, i + 1);
      });
      _scrollToBottom();
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;
    setState(() {
      _messages.add(Message(text: text, isUser: false));
      _isTyping = false;
      _currentTypingText = '';

      if (_showWelcomeScreen) {
        _showWelcomeScreen = false;
      }
    });
    _scrollToBottom();
  }

  void _handleSubmit(String text) async {
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isThinking = true;

      if (_showWelcomeScreen) {
        _showWelcomeScreen = false;
      }
    });
    _scrollToBottom();

    try {
      if (_isGreeting(text)) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        _simulateTyping(
          "Halo! Saya adalah Local AI, asisten berbasis kecerdasan buatan yang dibuat oleh Ryanprw, kamu bisa menganggapku sebagai teman virtual yang siap membantu kapan saja. Apa yang kamu ingin ketahui?",
        );
      } else {
        final response = await _aiService.sendMessage(text);
        if (!mounted) return;

        _simulateTyping(response);
      }
    } catch (e) {
      if (!mounted) return;
      _simulateTyping("Maaf, terjadi kesalahan: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Text(
                'L',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Local AI', style: TextStyle(fontSize: 16)),
                Text(
                  'Model AI Versi: 0.1.2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount:
                      _messages.length + (_isTyping || _isThinking ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      if (_isThinking) {
                        return ThinkingIndicator(
                          dotControllers: _dotControllers,
                        );
                      } else if (_isTyping) {
                        return TypingIndicator(text: _currentTypingText);
                      }
                    } else {
                      final message = _messages[index];
                      return ChatBubble(message: message);
                    }
                    return null;
                  },
                ),
              ),
              MessageInput(controller: _controller, onSubmit: _handleSubmit),
            ],
          ),

          if (_showWelcomeScreen)
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(child: WelcomeScreen()),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: MessageInput(
                      controller: _controller,
                      onSubmit: _handleSubmit,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
