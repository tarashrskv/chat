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
      ..on('thematics.all', _rebuildChats)
      ..on('thematics.online', _rebuildOnlineCount)
      ..connect();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            toolbarHeight: 56,
            collapsedHeight: 56,
            scrolledUnderElevation: 4,
            pinned: false,
            stretch: false,
            floating: false,
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
          SliverFillRemaining(
          child: ValueListenableBuilder(
            valueListenable: _chats,
            builder: (_, chats, __) {
              if (_isFirstConnection) return const Center(child: CircularProgressIndicator());
              return Scrollbar(
                controller: scrollController,
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
        )],
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
    _chats.value = List<ThematicChat>.from((chats).map((chat) => ThematicChat.fromJson(chat)));

    if (_isFirstConnection) {
      setState(() => _isFirstConnection = false);
    }
  }

  void _rebuildOnlineCount(dynamic onlineCount) {
    _onlineCount.value = onlineCount as int?;
  }

  void _showFilterDialog() {
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text('Сортування'),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: Text('Скасувати')),
          TextButton(onPressed: Navigator.of(context).pop, child: Text('Ок')),
        ],
      );
    });
  }
}
