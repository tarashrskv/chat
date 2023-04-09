import 'package:chat/network/api/socket_api.dart';
import 'package:chat/widgets/extensions/context_x.dart';
import 'package:chat/widgets/full_screen_dialog.dart';
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
  final ValueNotifier<int?> _onlineCount = ValueNotifier(null);

  late final SocketApi _thematicChatsApi;

  late bool _isFirstConnection;

  @override
  void initState() {
    super.initState();

    _isFirstConnection = true;

    _thematicChatsApi = SocketApi('thematic')
      ..on('thematics.all', _buildChats)
      ..on('thematics.new', _addChat)
      ..on('thematics.online', _rebuildOnlineCount)
      ..connect();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _chats,
        builder: (_, chats, __) {
          if (chats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverAppBar(
                  toolbarHeight: 56,
                  collapsedHeight: 56,
                  scrolledUnderElevation: 4,
                  pinned: false,
                  floating: true,
                  snap: false,
                  stretch: true,
                  actions: [
                    if (_onlineCount.value != null) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.remove_red_eye_outlined),
                      const SizedBox(width: 4),
                      Text(_onlineCount.value!.toString()),
                      const Spacer(),
                    ],
                    if (_chats.value.isNotEmpty) ...[
                      ElevatedButton.icon(
                        onPressed: _showFilterDialog,
                        icon: const Icon(Icons.filter_alt_outlined),
                        label: Text('Фільтр'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sort_rounded),
                        label: Text('Сортування'),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
                SliverList(

                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final chat = chats[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ThematicChatCard(
                              title: chat.title,
                              description: chat.description,
                              authorGender: chat.author.gender,
                              authorAge: chat.author.age,
                              authorLocation: chat.author.location,
                              questions: chat.questions,
                              adultOnly: chat.adultOnly == true,
                            ),
                          );
                    },
                    childCount:
                        _chats.value.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFab(),
    );
  }

  @override
  void dispose() {
    _chats.dispose();
    _onlineCount.dispose();
    _thematicChatsApi.dispose();

    super.dispose();
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return Dialog.fullscreen(
              child: FullScreenDialog(),
            );
          },
        );
      },
      label: const Text('Створити'),
      icon: const Icon(Icons.add),
    );
  }

  void _buildChats(dynamic chats) {
    print(chats.length);

    _chats.value =
        List<ThematicChat>.from(chats.map((chat) => ThematicChat.fromJson(chat))).reversed.toList();

    if (_isFirstConnection) {
      setState(() => _isFirstConnection = false);
    }
  }

  void _addChat(dynamic chat) {
    final s = ThematicChat.fromJson(chat);
    _chats.value = _chats.value.toList()..insert(0, s);

    if (_isFirstConnection) {
      setState(() => _isFirstConnection = false);
    }
  }

  void _rebuildOnlineCount(dynamic onlineCount) {
    _onlineCount.value = onlineCount as int?;
  }

  void _showFilterDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Сортування'),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop, child: Text('Скасувати')),
              TextButton(onPressed: Navigator.of(context).pop, child: Text('Ок')),
            ],
          );
        },);
  }
}
