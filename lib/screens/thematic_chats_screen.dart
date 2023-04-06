import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chat/network/models/topic_chats/topic_chat_response.dart';
import 'package:chat/widgets/thematic_chat_card.dart';
import 'package:flutter/material.dart';

class ThematicChatsScreen extends StatefulWidget {
  const ThematicChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ThematicChatsScreenState();
}

class _ThematicChatsScreenState extends State<ThematicChatsScreen> {

  late Future<List<TopicChat>> _future;

  @override
  void initState() {
    super.initState();
    _future = longPolling();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<List<TopicChat>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final messages = snapshot.data!;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ThematicChatCard(
                      title: messages[index].title!,
                      description: messages[index].description!,
                      authorGender: messages[index].author.gender,
                      authorAge: messages[index].author.age,
                      authorLocation: messages[index].author.geo,
                      hasQuestions: messages[index].questions == null,
                      isAdult: messages[index].adultOnly == true,
                  );
                },
              );
            }
          },
        ),
        ),
      floatingActionButton: _buildFab(),
    );
  }

  Future<List<TopicChat>> longPolling() async {
      try {
        final response = await http.get(Uri.parse('https://lfyou.com.ua/api/thematic'));
        if (response.statusCode == 200) {
          final decodedBody = utf8.decode(response.bodyBytes, allowMalformed: true);

          final s = List<TopicChat>.from(jsonDecode(decodedBody)['chats'].map((x) => TopicChat.fromJson(x)));
          return s;
          // Process the data received from the server
        } else {
          return [];
        }
      } catch (e) {
        print (e);
        return [];
      }

      // Wait for a specific duration before making the next request

  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
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
