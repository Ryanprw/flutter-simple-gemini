import 'package:flutter/material.dart';

class ThinkingIndicator extends StatelessWidget {
  final List<AnimationController> dotControllers;

  const ThinkingIndicator({Key? key, required this.dotControllers})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Text(
            'L',
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 40, top: 5, bottom: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Text(
                  "Sedang berpikir",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  child: Row(
                    children: [
                      _buildAnimatedDot(0),
                      _buildAnimatedDot(1),
                      _buildAnimatedDot(2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDot(int index) {
    return SizedBox(
      width: 6,
      child: AnimatedBuilder(
        animation: dotControllers[index],
        builder: (context, child) {
          return Opacity(
            opacity:
                0.3 +
                (DateTime.now().millisecondsSinceEpoch ~/ 300 + index) %
                    3 *
                    0.2,
            child: const Text(
              ".",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
