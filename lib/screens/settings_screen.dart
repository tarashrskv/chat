import 'package:chat/providers/default_nav_bar_item_notifier.dart';
import 'package:chat/theme/theme_mode_notifier.dart';
import 'package:chat/widgets/chat_text_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = Provider.of<ThemeModeNotifier>(context);
    final defaultNavBarItemNotifier = Provider.of<DefaultNavBarItemNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          contentPadding: EdgeInsets.zero,
          title: const Text('Використовувати темну тему'),
          value: themeModeNotifier.themeMode == ThemeMode.dark,
          onChanged: (_) => themeModeNotifier.toggleThemeMode(),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Тематичні діалоги за замовчуванням'),
          value: defaultNavBarItemNotifier.defaultNavigationBarItem == NavBarItem.thematicChats,
          onChanged: (_) => defaultNavBarItemNotifier.toggleUseThematicChatsByDefault(),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              emojiShowing = !emojiShowing;
            });
          },
          icon: Icon(
            emojiShowing ? Icons.keyboard_outlined : Icons.tag_faces_outlined,
          ),
        ),
        ChatTextField(),
      ],
    );
  }
}
