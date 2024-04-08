import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taskflow/screens/main_screen.dart';
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/display_lists.dart';
import 'package:taskflow/services/add_board.dart';
import '../screens/display_boards_style.dart';
import '';

class DisplayBoards extends StatefulWidget {
  const DisplayBoards({super.key});

  @override
  State<DisplayBoards> createState() => _DisplayBoardsState();
}

class TrelloBoard {
  final String id;
  final String name;
  final String desc;

  TrelloBoard({required this.id, required this.name, this.desc = ''});

  factory TrelloBoard.fromJson(Map<String, dynamic> json) {
    return TrelloBoard(
      id: json['id'],
      name: json['name'],
      desc: json['desc'] ?? '',
    );
  }
}

class _DisplayBoardsState extends State<DisplayBoards> {
  List<TrelloBoard> projects = [];
  late String apiKey;
  late String token;

  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env['API_KEY']!;
    token = dotenv.env['TOKEN']!;
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    final url =
        'https://api.trello.com/1/members/me/boards?key=$apiKey&token=$token&filter=open';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> boardsJson = json.decode(response.body);
      setState(() {
        projects =
            boardsJson.map((data) => TrelloBoard.fromJson(data)).toList();
      });
    } else {
      throw Exception('Échec de chargement des projets depuis l\'API');
    }
  }

  void _deleteBoard(String boardId) async {
    final url =
        'https://api.trello.com/1/boards/$boardId/closed?value=true&key=$apiKey&token=$token';
    final response = await http.put(Uri.parse(url));

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        projects.removeWhere((project) => project.id == boardId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tableau supprimé avec succès.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erreur lors de la suppression du tableau.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            margin: EdgeInsets.only(top: 55.0, left: 40.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              title:
                  const Text('Vos Projets', style: BoardsStyle.titleTextStyle),
              backgroundColor: BoardsStyle.appBarColor,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(70.0),
          child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (BuildContext context, int index) {
                final project = projects[index];
                return ListTile(
                    title: Text(project.name),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayLists(
                                    projectId: project.id,
                                    url:
                                        'https://api.trello.com/1/boards/${project.id}/lists?key=$apiKey&token=$token',
                                    apiKey: apiKey,
                                    token: token,
                                  )));
                    },
                    subtitle: Text(project.desc),
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: Text('Supprimer "${project.name}"?'),
                                content: const Text(
                                    'Voulez-vous vraiment Supprimer ce tableau? Cette action est irréversible.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Annuler'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                      child: const Text('Supprimer'),
                                      onPressed: () {
                                        _deleteBoard(project.id);
                                        Navigator.of(context).pop();
                                      })
                                ])));
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Stack(
                        children: [
                          MainScreen(),
                          Opacity(
                            opacity: 0.8,
                            child: AddBoard(),
                          ),
                        ],
                      )),
            );
          },
          backgroundColor: BoardsStyle.buttonColor,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const BottomNavBar());
  }
}
