import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/display_cards.dart';
import 'package:taskflow/services/display_lists.dart';

class AddCard extends StatelessWidget {
  final String listId;

  AddCard({
    super.key,
    required this.listId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Add a card'),
      ),
      body: CreateCardForm(
        listId: this.listId,
      ),
    ));
  }
}

class CreateCardForm extends StatefulWidget {
  final String listId;

  CreateCardForm({
    super.key,
    required this.listId,
  });

  @override
  State<CreateCardForm> createState() => _CreateCardFormState();
}

class _CreateCardFormState extends State<CreateCardForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String apiKey;
  late String token;

  Future<void> _createCard() async {
    if (_formKey.currentState!.validate()) {
      apiKey = dotenv.env['API_KEY']!;
      token = dotenv.env['TOKEN']!;
      var url =
          "https://api.trello.com/1/cards?idList=${widget.listId}&key=$apiKey&token=$token";

      final Map<String, dynamic> body = {
        'name': _nameController.text,
        'desc': _descriptionController.text,
        'key': apiKey,
        'token': token,
      };

      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        // final listId = json.decode(response.body)['id'];

        final projectId = widget.listId;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayCards(
                  listId: projectId,
                  apiKey: apiKey,
                  token: token,
                  url:
                      'https://api.trello.com/1/lists/$projectId/cards?key=$apiKey&token=$token',
    )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('failed : ${response.body}'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Card'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the card';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createCard,
                child: const Text('Create card'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
