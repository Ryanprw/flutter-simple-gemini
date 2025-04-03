import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmit;

  const MessageInput({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ayo bertanya!',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: onSubmit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSubmit(controller.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
