import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskflow/services/add_list.dart';
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/delete_list.dart';
import 'package:taskflow/services/display_cards.dart';

class DisplayLists extends StatefulWidget {
  final String projectId;
  final String url;
  final String apiKey;
  final String token;

  const DisplayLists({
    super.key,
    required this.projectId,
    required this.url,
    required this.apiKey,
    required this.token,
  });

  @override
  _DisplayListsState createState() => _DisplayListsState();
}

class _DisplayListsState extends State<DisplayLists> {
  List<dynamic> _lists = [];

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          _lists = json.decode(response.body);
        });
      } else {
        print('Failed to load lists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching lists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Détails du Tableau'),
        ),
        body: _lists.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _lists.length,
                itemBuilder: (context, index) {
                  final list = _lists[index];
                  return Card(
                      child: ListTile(
                          title: Text(_lists[index]['name']),
                          onTap: () {
                            print(widget.apiKey);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DisplayCards(
                                        listId: _lists[index]['id'],
                                        apiKey: widget.apiKey,
                                        token: widget.token,
                                        url:
                                            'https://api.trello.com/1/lists/${_lists[index]['id']}/cards?key=${widget.apiKey}&token=${widget.token}')));
                          },
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteList(
                                      apiKey: widget.apiKey,
                                      token: widget.token,
                                      listId: _lists[index]['id'],
                                      onDelete: () {
                                        _fetchLists();
                                      });
                                });
                          }));
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddList(
                        boardId: widget.projectId,
                      )),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const BottomNavBar());
  }
}
