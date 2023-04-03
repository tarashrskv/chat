import 'dart:math';

import 'package:chat/screens/anonymous_chat_screen.dart';
import 'package:chat/screens/settings_screen.dart';
import 'package:chat/screens/thematic_chats_screen.dart';
import 'package:chat/widgets/extensions/context_x.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedNavigationItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildOnlineCountWidget()
        ],
        scrolledUnderElevation: 0,
      ),
      body: _buildBody(),
      floatingActionButton: _selectedNavigationItemIndex == 1 ? _buildFab() : null,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _getContent(),
          )
        )
      ],
    );
  }

  Widget _getContent() {
    if (_selectedNavigationItemIndex == 0) {
      return const AnonymousChatScreen();
    } else if (_selectedNavigationItemIndex == 1) {
      return const ThematicChatsScreen();
    } else {
      return const SettingsScreen();
    }
  }

  String _getAppBarTitle() {
    if (_selectedNavigationItemIndex == 0) {
      return 'Звичайний пошук';
    } else if (_selectedNavigationItemIndex == 1) {
      return 'Тематичні діалоги';
    } else {
      return 'Налаштування';
    }
  }

  Stream<int> _getOnlineCount() {
    final random = Random();

    return Stream.periodic(const Duration(seconds: 2), (_) => random.nextInt(991) + 10);
  }

  Widget _buildOnlineCountWidget() {
    return StreamBuilder(
      stream: _getOnlineCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          return Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.people_outline_rounded, color: context.getColorScheme().onSurfaceVariant),
                ),
              SizedBox(width: 10),
              Text(
                  snapshot.data.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
            ],
          );
        } else {
          return IconButton(onPressed: () {}, icon: const Icon(Icons.sync_problem_rounded));
        }
      },
    );
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: const Text('Створити'),
      icon: const Icon(Icons.add),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer_rounded),
          label: 'Звичайний чат',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.topic_rounded),
          label: 'Тематичні діалоги',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Налаштування',
        )
      ],
      onTap: _onNavigationItemTapped,
      currentIndex: _selectedNavigationItemIndex,
    );
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedNavigationItemIndex = index;
    });
  }
}
