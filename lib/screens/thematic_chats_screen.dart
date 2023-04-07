import 'dart:async';
import 'dart:convert';
import 'package:chat/models/gender.dart';
import 'package:chat/network/models/thematic_chats/author.dart';
import 'package:chat/widgets/app_screen_header_delegate.dart';
import 'package:chat/widgets/styles.dart';
import 'package:flutter/services.dart';
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: Navigator.of(context).pop,
                            icon: const Icon(Icons.close_rounded)),
                        Text(
                          'Створити чат',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const Spacer(),
                        TextButton(onPressed: () {}, child: Text('Ок'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            maxLength: 40,
                            maxLines: null,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Заголовок',
                                helperMaxLines: 2,
                                helperText: 'Наприклад: поговорю про фільми, шукаю компанію, потрібна порада тощо.'
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            maxLength: 100,
                            maxLines: null,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Опис чату',
                                helperMaxLines: 2,
                                helperText: 'Можна вказати чим цікавишся, з ким хочеться поговорити або інші деталі.'
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: textFieldDecoration.copyWith(
                                  labelText: 'Твій вік',
                                ),
                              )),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(child: TextFormField(
                                decoration: textFieldDecoration.copyWith(
                                  labelText: 'Твоя стать',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                ),
                              ),),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                              decoration: textFieldDecoration.copyWith(
                                labelText: true ? 'Введи регіон пошуку' : 'Регіон пошуку',
                                helperMaxLines: 2,
                                helperText: 'Назва твого міста або, наприклад, те, що ти в повній жопі.'
                              ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            title: Text('Без обмежень'),
                            subtitle: Text(
                                'Позначай цей прапорець, якщо тема стосується інтиму, «вірту», відвертощів пікантного характеру, еротики, контенту «для дорослих», NSFW тощо.'),
                            value: true,
                            onChanged: (_) {},
                          ),
                          CheckboxListTile(
                            title: Text('Не впускати нових користувачів'),
                            subtitle: Text(
                                'Не впустить у твій діалог користувачів, які тільки-но завітали на сайт (менше 20хв тому). Допоможе, коли тебе атакують, обходячи блокування.'),
                            value: true,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
