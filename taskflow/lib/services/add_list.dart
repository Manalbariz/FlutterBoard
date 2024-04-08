import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/display_lists.dart';

class AddList extends StatelessWidget {
  final String boardId;

  AddList({
    super.key,
    required this.boardId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Add a list'),
      ),
      body: CreateListForm(
        boardId: this.boardId,
      ),
    ));
  }
}

class CreateListForm extends StatefulWidget {
  final String boardId;

  CreateListForm({
    super.key,
    required this.boardId,
  });

  @override
  State<CreateListForm> createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String apiKey;
  late String token;

  Future<void> _createList() async {
    if (_formKey.currentState!.validate()) {
      apiKey = dotenv.env['API_KEY']!;
      token = dotenv.env['TOKEN']!;
      var url = "https://api.trello.com/1/boards/${widget.boardId}/lists";

      final Map<String, dynamic> body = {
        'name': _nameController.text,
        'desc': _descriptionController.text,
        'key': apiKey,
        'token': token,
      };

      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        // final listId = json.decode(response.body)['id'];

        final projectId = widget.boardId;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayLists(
                  projectId: projectId,
                  url:
                      'https://api.trello.com/1/boards/$projectId/lists?key=$apiKey&token=$token',
                  apiKey: apiKey,
                  token: token)),
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
                decoration: const InputDecoration(labelText: 'List Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for the list';
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
                onPressed: _createList,
                child: const Text('Create List'),
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
