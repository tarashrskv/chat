import 'package:chat/screens/app_screen.dart';
import 'package:chat/theme/color_scheme.dart' as theme;
import 'package:chat/theme/theme_mode_notifier.dart';
import 'package:chat/theme/widget_themes.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ChatMaterialApp());
}

class ChatMaterialApp extends StatelessWidget {
  const ChatMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // lightColorScheme = lightDynamic.harmonized();
          // darkColorScheme = darkDynamic.harmonized();

          lightColorScheme = theme.lightColorScheme;
          darkColorScheme = theme.darkColorScheme;
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = theme.lightColorScheme;
          darkColorScheme = theme.darkColorScheme;
        }
        return ChangeNotifierProvider(
          create: (_) => ThemeModeNotifier(),
          child: Consumer<ThemeModeNotifier>(
            builder: (_, notifier, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: notifier.themeMode,
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
      },
    );
  }
}
