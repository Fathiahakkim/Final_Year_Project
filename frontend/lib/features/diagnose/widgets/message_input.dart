import 'package:flutter/material.dart';
import '../theme/diagnose_theme.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;

  const MessageInput({
    super.key,
    required this.controller,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: DiagnoseTheme.inputPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: DiagnoseTheme.cardWhite,
        borderRadius: BorderRadius.circular(DiagnoseTheme.inputRadius),
        boxShadow: DiagnoseTheme.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontSize: 16,
                color: DiagnoseTheme.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Type your message',
                hintStyle: TextStyle(
                  color: DiagnoseTheme.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
              ),
              cursorColor: DiagnoseTheme.accentBlue,
            ),
          ),
          IconButton(
            onPressed: onSend,
            icon: const Icon(
              Icons.send,
              color: DiagnoseTheme.accentBlue,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
