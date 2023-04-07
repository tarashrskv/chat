import 'dart:async';
import 'dart:convert';
import 'package:chat/models/gender.dart';
import 'package:chat/network/models/thematic_chats/author.dart';
import 'package:chat/widgets/app_screen_header_delegate.dart';
import 'package:http/http.dart' as http;

import 'package:chat/network/models/thematic_chats/thematic_chat.dart';
import 'package:chat/widgets/thematic_chat_card.dart';
import 'package:flutter/material.dart';

class ThematicChatsScreen extends StatefulWidget {
  const ThematicChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ThematicChatsScreenState();
}

class _ThematicChatsScreenState extends State<ThematicChatsScreen> {
  final ValueNotifier<List<ThematicChat>> _chats = ValueNotifier([]);

  late bool _isFirstConnection;

  @override
  void initState() {
    super.initState();

    _isFirstConnection = true;

    fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _chats,
        builder: (_, chats, __) {
          if (_isFirstConnection) return const Center(child: CircularProgressIndicator());
          return Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ThematicChatCard(
                    title: chats[index].title,
                    description: chats[index].description,
                    authorGender: chats[index].author.gender,
                    authorAge: chats[index].author.age,
                    authorLocation: chats[index].author.location,
                    hasQuestions: chats[index].questions == null,
                    isAdult: chats[index].adultOnly == true,
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 4),
            ),
          );
        },
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Future<List<ThematicChat>> fetchChats() async {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      _chats.value = [
        ThematicChat(
          title: 'Го палити дивани?',
          // 40
          description:
              'Неважливо, хто ти, звідки, скільки років і звідки знаєш про цей чат. Давай просто відірвемось бігом!',
          // 500
          author: Author(gender: Gender.male, age: 27, location: 'Івано-Франківськ'),
          // 30
          questions: [],
          // 3 max
          adultOnly: false,
          uuid: '',
        ),
      ];
      if (_isFirstConnection) {
        setState(() {
          _isFirstConnection = false;
        });
      }
    }
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog.fullscreen(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(delegate: AppScreenHeaderDelegate())
                      ],
                    ),
                  ),
              );
            });
      },
      label: const Text('Створити'),
      icon: const Icon(Icons.add),
    );
  }
}

// ThematicChatCard(
// title: 'Го палити дивани?', // 40
// description: 'Неважливо, хто ти, звідки, скільки років і звідки знаєш про цей чат. Давай просто відірвемось бігом!', // 500
// authorGender: Gender.male,
// authorAge: 27, // 0-99
// authorLocation: 'Івано-Франківськ', // 30
// hasQuestions: false,
// isAdult: false
// ),

//while (true) {
//final response = await http.get(Uri.parse('https://lfyou.com.ua/api/thematic'));
//if (response.statusCode == 200) {
//final decodedBody = utf8.decode(response.bodyBytes);
//final s = List<ThematicChat>.from(jsonDecode(decodedBody)['chats'].map((chat) => ThematicChat.fromJson(chat)));
// ...
//_chats.value = s
