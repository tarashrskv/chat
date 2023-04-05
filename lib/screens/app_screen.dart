import 'package:chat/providers/default_nav_bar_item_notifier.dart';
import 'package:chat/screens/regular_search_screen.dart';
import 'package:chat/screens/settings_screen.dart';
import 'package:chat/screens/thematic_chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final s = ScrollController();
  static const Map<NavBarItem, List<NavBarItem>> _navBarItemOrder = {
    NavBarItem.regularSearch: [
      NavBarItem.regularSearch,
      NavBarItem.thematicChats,
      NavBarItem.settings,
    ],
    NavBarItem.thematicChats: [
      NavBarItem.thematicChats,
      NavBarItem.regularSearch,
      NavBarItem.settings,
    ],
  };

  int _selectedNavigationItemIndex = 0;
  late NavBarItem _selectedNavigationBarItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DefaultNavBarItemNotifier(),
      child: Consumer<DefaultNavBarItemNotifier>(
        builder: (_, provider, __) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 30,
              scrolledUnderElevation: 0,
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
    const regularChatNavBarItem = NavigationDestination(
      icon: Icon(Icons.chat_bubble_rounded),
      label: 'Звичайний пошук',
    );

    const thematicChatsNavBarItem = NavigationDestination(
      icon: Icon(Icons.lightbulb_outline_rounded),
      label: 'Тематичні діалоги',
    );

    return NavigationBar(
      destinations: [
        if (defaultNavBarItem == NavBarItem.regularSearch) ...[
          regularChatNavBarItem,
          thematicChatsNavBarItem,
        ] else
          ...[
            thematicChatsNavBarItem,
            regularChatNavBarItem,
          ],
        const NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: 'Налаштування',
        )
      ],
      onDestinationSelected: _onNavigationItemTapped,
      selectedIndex: _selectedNavigationItemIndex,
    );
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedNavigationItemIndex = index;
    });
  }

  NavBarItem _getCurrentNavBarItem(NavBarItem defaultNavBarItem) {
    return _navBarItemOrder[defaultNavBarItem]![_selectedNavigationItemIndex];
  }
}

