import 'package:flutter/material.dart';

extension ContextX on BuildContext {

  ColorScheme getColorScheme() => Theme.of(this).colorScheme;

}