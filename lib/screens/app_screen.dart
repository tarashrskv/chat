import 'package:chat/providers/default_nav_bar_item_notifier.dart';
import 'package:chat/screens/regular_search_screen.dart';
import 'package:chat/screens/settings_screen.dart';
import 'package:chat/screens/thematic_chats_screen.dart';
import 'package:chat/widgets/extensions/context_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedNavigationItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: move Provider lower
    return ChangeNotifierProvider(
      create: (_) => DefaultNavBarItemNotifier(),
      child: Consumer<DefaultNavBarItemNotifier>(
        builder: (_, provider, __) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: _getContent(provider.defaultNavigationBarItem),
            bottomNavigationBar: _buildBottomNavBar(provider.defaultNavigationBarItem),
          );
        },
      ),
    );
  }

  Widget _getContent(NavBarItem defaultNavBarItem) {
    if (_selectedNavigationItemIndex == 2) {
      return const SettingsScreen();
    } else {
      final index = NavBarItem.values.indexOf(defaultNavBarItem);
      if (index == _selectedNavigationItemIndex) {
        return const RegularSearchScreen();
      } else {
        return const ThematicChatsScreen();
      }
    }
  }

  Widget _buildBottomNavBar(NavBarItem defaultNavBarItem) {
    return NavigationBar(
      destinations: getDestinations(defaultNavBarItem).toList(),
      onDestinationSelected: (index) {
        setState(() {
          _selectedNavigationItemIndex = index;
        });
      },
      selectedIndex: _selectedNavigationItemIndex,
    );
  }

  Iterable<NavigationDestination> getDestinations(NavBarItem defaultNavBarItem) sync* {
    final regularChatActive =
        (defaultNavBarItem == NavBarItem.regularSearch && _selectedNavigationItemIndex == 0) ||
            (defaultNavBarItem == NavBarItem.thematicChats && _selectedNavigationItemIndex == 1);
    final regularChatNavBarItem = NavigationDestination(
      icon: regularChatActive
          ? const Icon(Icons.question_answer_rounded)
          : const Icon(Icons.question_answer_outlined),
      label: 'Звичайні',
    );

    final isThematicChatActive =
        (defaultNavBarItem == NavBarItem.thematicChats && _selectedNavigationItemIndex == 0) ||
            (defaultNavBarItem == NavBarItem.regularSearch && _selectedNavigationItemIndex == 1);
    final thematicChatsNavBarItem = NavigationDestination(
      icon: isThematicChatActive
          ? const Icon(Icons.interests_rounded)
          : const Icon(Icons.interests_outlined),
      label: 'Тематичні',
    );

    if (defaultNavBarItem == NavBarItem.regularSearch) {
      yield regularChatNavBarItem;
      yield thematicChatsNavBarItem;
    } else {
      yield thematicChatsNavBarItem;
      yield regularChatNavBarItem;
    }

    yield NavigationDestination(
      icon: _selectedNavigationItemIndex == 2
          ? const Icon(Icons.settings_rounded)
          : const Icon(Icons.settings_outlined),
      label: 'Налаштування',
    );
  }
}
