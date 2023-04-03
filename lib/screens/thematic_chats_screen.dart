import 'package:flutter/material.dart';

class ThematicChatsScreen extends StatefulWidget {
  const ThematicChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ThematicChatsScreenState();
}

class _ThematicChatsScreenState extends State<ThematicChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(),
    );
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: const Text('Створити'),
      icon: const Icon(Icons.add),
    );
  }
}
