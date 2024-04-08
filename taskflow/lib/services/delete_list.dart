import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteList extends StatefulWidget {
  final String apiKey;
  final String token;
  final String listId;
  final VoidCallback onDelete;

  const DeleteList(
      {super.key,
      required this.apiKey,
      required this.token,
      required this.listId,
      required this.onDelete});

  @override
  State<DeleteList> createState() => _DeleteListState();
}

class _DeleteListState extends State<DeleteList> {
  void _deleteList() async {
    final url =
        'https://api.trello.com/1/lists/${widget.listId}/closed?value=true&key=${widget.apiKey}&token=${widget.token}';
    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Supprimer cette liste?'),
        content: const Text(
            'Voulez-vous vraiment Supprimer cette liste? Cette action est irréversible.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                _deleteList();
                Navigator.of(context).pop();
              })
        ]);
  }
}
