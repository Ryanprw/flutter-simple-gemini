import 'package:flutter/material.dart';

class ActionIcons extends StatelessWidget {
  const ActionIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionIcon(Icons.thumb_up_outlined),
        _buildActionIcon(Icons.thumb_down_outlined),
        _buildActionIcon(Icons.copy_outlined),
        _buildActionIcon(Icons.refresh),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 18, color: Colors.grey),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
      onPressed: () {},
    );
  }
}
