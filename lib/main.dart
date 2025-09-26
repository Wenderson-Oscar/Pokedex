import 'package:flutter/material.dart';
import 'package:api_pokemon/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Pokédex XY';

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3D7DCA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D7DCA),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: appTitle),
    );
  }
}
