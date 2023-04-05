import 'package:chat/models/gender.dart';
import 'package:chat/widgets/thematic_chat_card.dart';
import 'package:flutter/material.dart';

class ThematicChatsScreen extends StatefulWidget {
  const ThematicChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ThematicChatsScreenState();
}

class _ThematicChatsScreenState extends State<ThematicChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ThematicChatCard(
                title: 'Blah-blah', // 40
                description: 'Blah-blah-blah', // 500
                authorGender: Gender.male,
                authorAge: '27', // 0-99
                authorLocation: 'Blah-blah-blahBlah-blah-blahff', // 30 TODO: overflow here if long
                hasQuestions: false,
                isAdult: false
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: const Text('Створити'),
      icon: const Icon(Icons.add),
    );
  }
}
