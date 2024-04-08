import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/services/add_card.dart';
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/delete_card.dart';

class DisplayCards extends StatefulWidget {
  // const DisplayCards({super.key});
  final String listId;
  final String url;
  final String apiKey;
  final String token;

  const DisplayCards({
    super.key,
    required this.listId,
    required this.url,
    required this.apiKey,
    required this.token,
  });
  @override
  State<DisplayCards> createState() => _DisplayCardsState();
}

class _DisplayCardsState extends State<DisplayCards> {
  late List<dynamic> _cards = [];
  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    final response = await http.get(Uri.parse(widget.url));
    try {
      if (response.statusCode == 200) {
        setState(() {
          _cards = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Loading Error: ${response.body}'),
        ));
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
        body: _cards.isEmpty
            ? const Center(child: ButtonBar())
            : ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                          title: Text(_cards[index]['name']),
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteCard(
                                      apiKey: widget.apiKey,
                                      token: widget.token,
                                      cardId: _cards[index]['id'],
                                      onDelete: () {
                                        _fetchCards();
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
                    builder: (context) => AddCard(listId: widget.listId)));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const BottomNavBar());
  }
}
