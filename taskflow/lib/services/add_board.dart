import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taskflow/services/bottom_navigation_bar.dart';
import 'package:taskflow/services/display_lists.dart';

class AddBoard extends StatelessWidget {
  const AddBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Trello Board'),
        ),
        body: const CreateBoardForm(),
      ),
    );
  }
}

class CreateBoardForm extends StatefulWidget {
  const CreateBoardForm({super.key});

  @override
  _CreateBoardFormState createState() => _CreateBoardFormState();
}

class _CreateBoardFormState extends State<CreateBoardForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String apiKey;
  late String token;

  Future<void> _createBoard() async {
    if (_formKey.currentState!.validate()) {
      apiKey = dotenv.env['API_KEY']!;
      token = dotenv.env['TOKEN']!;
      const String url = 'https://api.trello.com/1/boards';

      final Map<String, dynamic> body = {
        'name': _nameController.text,
        'desc': _descriptionController.text,
        'key': apiKey,
        'token': token,
      };

      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        final projectId = json.decode(response.body)['id'];

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
          content: Text('Error creating board: ${response.body}'),
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
                  decoration: const InputDecoration(labelText: 'Board Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name for the board';
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
                  onPressed: _createBoard,
                  child: const Text('Create Board'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
