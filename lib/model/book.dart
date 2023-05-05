import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String? author;
  final String? description;
  final String? imageUrl;
  final String? note;
  final String? title;
  final String? id;
  final String? username;
  final bool? isFavorite;

  BookModel({this.author, this.description, this.imageUrl, this.note, this.title, this.id, this.isFavorite, this.username});

  factory BookModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return BookModel(
      author: snap['author'],
      description: snap['description'],
      imageUrl: snap['image_url'],
      note: snap['note'],
      title: snap['title'],
      id: snap['id'],
      username: snap['username'],
      isFavorite: snap['is_favorite']
    );
  }

  Map<String, dynamic> toJson() => {
    'author': author,
    'description': description,
    'image_url': imageUrl,
    'note': note,
    'title': title,
    'id': id,
    'username': username,
    'is_favorite': isFavorite
  };
}