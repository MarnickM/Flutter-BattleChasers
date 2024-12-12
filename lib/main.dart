import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import './database_helper.dart';

void main() {
  runApp(const BattleChasersApp());
  clearData();
  insertInitialData();
}

  // clear the database and insert initial data
  Future<void> clearData() async {
    await DatabaseHelper.fetchScores();
  }

  Future<void> insertInitialData() async {
    await DatabaseHelper.insertScore('Player1', 150);
    await DatabaseHelper.insertScore('Player2', 350);
    await DatabaseHelper.insertScore('Player3', 100);
}

class BattleChasersApp extends StatelessWidget {
  const BattleChasersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battle Chasers',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1C2834),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1C2834)),
        primaryColor: const Color(0xFFFF440E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF440E),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomePage(),
    );
  }
}
