import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';

import 'addPhotoForm.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> _photos;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  void _loadPhotos() async {
    await Future.delayed(Duration(seconds: 4)); // simulate loading delay
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    final data = jsonDecode(response.body);
    setState(() {
      _photos = List.from(data)..sort((a, b) => b['id'].compareTo(a['id']));
      _isLoading = false;
    });
  }

    void _addPhoto(Map<String, String> photo) async {
    final response = await http.post(Uri.parse('https://jsonplaceholder.typicode.com/photos'),
        body: jsonEncode(photo), headers: {'Content-Type': 'application/json'});
    setState(() {
      _isLoading = true;
    });
    _loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
      ),
      body: _isLoading
          ? Center(
        child: LoadingFlipping.circle(
          size: 50,
        ),
      )
          : ListView.builder(
        itemCount: _photos.length,
        itemBuilder: (BuildContext context, int index) {
          final photo = _photos[index];
          return ListTile(
            leading: Image.network(photo['thumbnailUrl']),
            title: Text(photo['title']),
            subtitle: Text('ID: ${photo['id']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddPhotoForm();
              });
          if (result != null) {
            _addPhoto(result);
            _loadPhotos(); // Rafraîchir la liste des photos
          }
        },

        tooltip: 'Add Photo',
        child: Icon(Icons.add),
      ),
    );
  }
}
