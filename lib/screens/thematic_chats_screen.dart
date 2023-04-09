import 'package:chat/network/api/socket_api.dart';
import 'package:chat/widgets/animated_list_model.dart';
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
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  late AnimatedListModel<ThematicChat> _chatsDisplayList;

  final ValueNotifier<List<ThematicChat>> _chats = ValueNotifier([]);
  final ValueNotifier<int?> _onlineCount = ValueNotifier(null);

  late final SocketApi _thematicChatsApi;

  bool _isFirstConnection = true;

  @override
  void initState() {
    super.initState();

    _thematicChatsApi = SocketApi('thematic')
      ..on('thematics.all', _rebuildChats)
      ..on('thematics.new', _addChat)
      ..on('thematics.remove', _removeChat)
      ..on('thematics.online', _rebuildOnlineCount)
      ..connect();
  }

  // TODO: add ScrollBar
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scaffold(
      body: (_chats.value.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    collapsedHeight: 56,
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
                  SliverAnimatedList(
                    key: _listKey,
                    initialItemCount: _chatsDisplayList.length,
                    itemBuilder: (_, index, animation) {
                      final chat = _chatsDisplayList[index];
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
                          animation: animation,
                          isActive: true,
                        ),
                      );
                    },
                  ),
                ],
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

  void _rebuildChats(dynamic chats) {
    final chatsList =
        List<ThematicChat>.from(chats.map((chat) => ThematicChat.fromJson(chat))).reversed.toList();

    setState(() {
      _chatsDisplayList = AnimatedListModel<ThematicChat>(
        listKey: _listKey,
        removedItemBuilder: (index, _, animation) {
          final chat = chatsList[index];
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
              animation: animation,
              isActive: false,
            ),
          );
        },
        initialItems: chatsList,
      );
    });

    _chats.value = chatsList;

    if (_isFirstConnection) {
      setState(() => _isFirstConnection = false);
    }
  }

  void _addChat(dynamic chat) {
    final s = ThematicChat.fromJson(chat);
    _chatsDisplayList.insert(0, s);
  }

  void _removeChat(dynamic chatId) {
    final index = _chatsDisplayList.items.indexWhere((chat) => chat.id == chatId as String);
    _chatsDisplayList.removeAt(index);
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
      },
    );
  }
}
