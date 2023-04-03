import 'package:chat/models/age_option.dart';
import 'package:chat/providers/default_nav_bar_item_notifier.dart';
import 'package:chat/screens/regular_search_screen.dart';
import 'package:chat/screens/settings_screen.dart';
import 'package:chat/screens/thematic_chats_screen.dart';
import 'package:chat/widgets/bottom_sheet.dart';
import 'package:chat/widgets/looking_for_info.dart';
import 'package:chat/widgets/my_search_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/gender.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
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
              actions: _getCurrentNavBarItem(provider.defaultNavigationBarItem) == NavBarItem.regularSearch ? [
                PopupMenuButton(
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text('Моя інформація'),
                      ),
                      PopupMenuItem(
                          value: 1,
                          child: Text('Інформація мого пошуку')),
                    ];
                  },
                  onSelected: (index) async {
                    await showChatModalBottomSheet(
                      proceedLabel: 'Зберегти',
                      cancelLabel: 'Скасувати',
                      onProceed: () {},
                        onCancel: () {},
                      context: context,
                      content: index == 0 ? MySearchInfo(
                            genderNotifier: ValueNotifier(Gender.male), ageOptionNotifier: ValueNotifier(AgeOption.twentySixAndMore))
                        : LookingForInfo(gendersNotifier: ValueNotifier({}), ageOptionsNotifier: ValueNotifier({}))
                    );
                  },
                )
              ] : null,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: _getContent(provider.defaultNavigationBarItem),
            ),
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
    const regularChatNavBarItem = BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_rounded),
      label: 'Звичайний пошук',
    );

    const thematicChatsNavBarItem = BottomNavigationBarItem(
      icon: Icon(Icons.lightbulb_rounded),
      label: 'Тематичні діалоги',
    );

    return BottomNavigationBar(
      items: [
        if (defaultNavBarItem == NavBarItem.regularSearch) ...[
          regularChatNavBarItem,
          thematicChatsNavBarItem,
        ] else
          ...[
            thematicChatsNavBarItem,
            regularChatNavBarItem,
          ],
        const BottomNavigationBarItem(
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

  NavBarItem _getCurrentNavBarItem(NavBarItem defaultNavBarItem) {
    return _navBarItemOrder[defaultNavBarItem]![_selectedNavigationItemIndex];
  }
}

