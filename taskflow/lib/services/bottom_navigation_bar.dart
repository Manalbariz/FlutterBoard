import 'package:flutter/material.dart';
import 'package:taskflow/services/display_boards.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _indiceOngletSelectionne = 0;

  void _onItemTapped(int index) {
    setState(() {
      _indiceOngletSelectionne = index;

      if (_indiceOngletSelectionne == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DisplayBoards()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Ajouter'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Param',
        )
      ],
      currentIndex: _indiceOngletSelectionne,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
