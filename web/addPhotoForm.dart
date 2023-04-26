import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPhotoForm extends StatefulWidget {
  @override
  _AddPhotoFormState createState() => _AddPhotoFormState();
}

class _AddPhotoFormState extends State<AddPhotoForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  Future<void> _addPhoto() async {
    final String title = _titleController.text;
    final String thumbnailUrl = _urlController.text;

    final Map<String, dynamic> photoData = {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
    };

    final http.Response response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(photoData),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Retourner à l'affichage de la galerie
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo ajoutée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de l\'ajout de la photo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une photo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL miniature'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addPhoto,
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
