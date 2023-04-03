import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController controller;

  const ChatTextField({
    super.key,
    required this.controller
  });

  @override
  State<StatefulWidget> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefix: EmojiPicker(),
      ),
    );
  }

}