import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'photo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoList(),
    );
  }
}

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonPhotos = jsonDecode(response.body);
      setState(() {
        photos = jsonPhotos.map((photo) => Photo.fromJson(photo)).toList();
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo App'),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(photos[index].title),
            leading: Image.network(photos[index].thumbnailUrl),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetail(photo: photos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhotoDetail extends StatelessWidget {
  final Photo photo;

  PhotoDetail({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(photo.url),
          SizedBox(height: 20),
          Text('Title: ${photo.title}'),
          SizedBox(height: 10),
          Text('ID: ${photo.id}'),
        ],
      ),
    );
  }
}
