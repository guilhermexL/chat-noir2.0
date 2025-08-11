import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const ChatNoirApp());
}

class ChatNoirApp extends StatefulWidget {
  const ChatNoirApp({super.key});

  @override
  State<ChatNoirApp> createState() => _ChatNoirAppState();
}

class _ChatNoirAppState extends State<ChatNoirApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.black,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    outline: Color(0xFFE5E7EB),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    error: Color(0xFFCF6679),
    onError: Colors.black,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    outline: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatNoir',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: lightColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
          elevation: 0,
        ),
        dividerColor: lightColorScheme.outline,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: darkColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          elevation: 0,
        ),
        dividerColor: darkColorScheme.outline,
      ),
      home: GameScreen(onThemeToggle: _toggleTheme),
    );
  }
}
