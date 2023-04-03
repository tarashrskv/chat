import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultNavBarItemNotifier with ChangeNotifier {
  static const defaultNavBarItemKey = 'defaultNavBarItem';

  NavBarItem? _defaultNavigationBarItem;

  DefaultNavBarItemNotifier() {
    _getDefaultNavBarItem();
  }

  NavBarItem get defaultNavigationBarItem => _defaultNavigationBarItem ?? NavBarItem.regularSearch;

  void toggleUseThematicChatsByDefault() async {
    _defaultNavigationBarItem = _defaultNavigationBarItem == NavBarItem.regularSearch ? NavBarItem.thematicChats : NavBarItem.regularSearch;
    _saveDefaultNavigationBarItem();

    notifyListeners();
  }

  Future<void> _getDefaultNavBarItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _defaultNavigationBarItem = prefs.getString(defaultNavBarItemKey) == NavBarItem.thematicChats.name ? NavBarItem.thematicChats : NavBarItem.regularSearch;

    notifyListeners();
  }

  Future<void> _saveDefaultNavigationBarItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(defaultNavBarItemKey, _defaultNavigationBarItem!.name);
  }
}

enum NavBarItem {
  regularSearch,
  thematicChats,
  settings,
}