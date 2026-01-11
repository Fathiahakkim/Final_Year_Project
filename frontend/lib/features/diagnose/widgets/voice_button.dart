import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const VoiceButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic_none),
      onPressed: onTap,
    );
  }
}
