import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/character_list_screen.dart';
import 'state/character_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharacterProvider(),
      child: MaterialApp(
        title: 'Star Wars App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CharacterListScreen(),
      ),
    );
  }
}