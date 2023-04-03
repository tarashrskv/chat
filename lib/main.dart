import 'package:chat/screens/app_screen.dart';
import 'package:chat/theme/color_scheme.dart';
import 'package:chat/theme/theme_mode_notifier.dart';
import 'package:chat/theme/widget_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeNotifier(),
      child: Consumer<ThemeModeNotifier>(
        builder: (_, notifier, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: notifier.themeMode, // ThemeMode.dark,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              dividerTheme: dividerThemeData,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              dividerTheme: dividerThemeData,
            ),
            home: const AppScreen(),
          );
        },
      ),
    );
  }
}
