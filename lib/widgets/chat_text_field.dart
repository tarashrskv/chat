import 'package:chat/widgets/extensions/context_x.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<StatefulWidget> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool showingEmoji = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    //final s = EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio).bottom;
    final s = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    final viewInsets = EdgeInsets
        .fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets, WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;

    print('First: $s');
    print('Second: $viewInsets');

    return
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animation,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '',
                      filled: true,
                      fillColor: context
                          .getColorScheme()
                          .surfaceVariant,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.tag_faces_outlined),
                        onPressed: () {
                          setState(() {
                            showingEmoji = !showingEmoji;
                            if (showingEmoji) {
                              // Hide the keyboard when the emoji picker is shown.
                              //
                              showEmoji(context);
                              _focusNode.unfocus();
                            } else {
                              // Show the keyboard when the emoji picker is hidden.

                              _focusNode.requestFocus();
                              //FocusScope.of(context).requestFocus(_focusNode);
                              //Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: _textController.text.isNotEmpty
                            ? const Icon(Icons.send)
                            : const Icon(Icons.image_outlined),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (showingEmoji) ...[
              showEmoji(context),
            ]
          ],
        );
  }


  Widget showEmoji(BuildContext context) {
      return Offstage(
        offstage: !showingEmoji,
        child: SizedBox(
          height: getKeyboardHeight(context),
          child: EmojiPicker(
            textEditingController: _textController,
            config: Config(
              columns: 7,
// Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax:
              32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: true,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          ),
        ),
      );
  }

  double getKeyboardHeight(BuildContext context) {
    final bottomInsets = EdgeInsets
        .fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets, WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;

    print('>>Second: $bottomInsets');

    // Estimate the keyboard height when it's not shown.
    // You can adjust this value based on your observation of common keyboard heights.
    final defaultKeyboardHeight = 300.0;

    return bottomInsets != 0 ? bottomInsets : defaultKeyboardHeight;
  }
}

