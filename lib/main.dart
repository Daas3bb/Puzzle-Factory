import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/puzzle_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PuzzleProvider()),
      ],
      child: MaterialApp(
        title: 'Puzzle Album',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7B5CF6),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF333333)),
            titleTextStyle: TextStyle(
              color: Color(0xFF333333),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
