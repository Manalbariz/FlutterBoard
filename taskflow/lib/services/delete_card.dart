import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteCard extends StatefulWidget {
  final String apiKey;
  final String token;
  final String cardId;
  final VoidCallback onDelete;

  const DeleteCard(
      {super.key,
      required this.apiKey,
      required this.token,
      required this.cardId,
      required this.onDelete});

  @override
  State<DeleteCard> createState() => _DeleteCardState();
}

class _DeleteCardState extends State<DeleteCard> {
  void _deleteList() async {
    final url =
        'https://api.trello.com/1/cards/${widget.cardId}/closed?value=true&key=${widget.apiKey}&token=${widget.token}';
    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Supprimer cette card?'),
        content: const Text(
            'Voulez-vous vraiment Supprimer cette card? Cette action est irréversible.'),
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
