import 'package:flutter/material.dart';
import 'package:taskflow/screens/main_screen.dart';
import 'package:taskflow/screens/main_style.dart';
import 'package:taskflow/services/display_boards.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());

  // const MaterialApp(home: DisplayBoards())
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StyledDisplayBoards(),
    );
  }
}

class StyledDisplayBoards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: MainScreenStyle.backgroundColor,
        body: Stack(
          children: [
            MainScreen(),
            Opacity(
              opacity: 0.8,
              child: DisplayBoards(),
            ),
          ],
        ));
  }
}
