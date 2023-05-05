import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/model/book.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper{

  static Future create(BookModel book) async {
    final bookCollection = FirebaseFirestore.instance.collection('BookCollection');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = bookCollection.doc().id;
    final docRef = bookCollection.doc(uid);
    final newBook = BookModel(
      title: book.title,
      author: book.author,
      description: book.description,
      note: book.note,
      imageUrl: book.imageUrl,
      id: uid,
      isFavorite: book.isFavorite,
      username: auth.currentUser!.email
    ).toJson();

    try {
      await docRef.set(newBook);
    } catch (e) {
      print('error occured: ' + e.toString());
    }
  }

  static Stream<List<BookModel>> read(){
    final bookCollection = FirebaseFirestore.instance.collection('BookCollection');
    final FirebaseAuth auth = FirebaseAuth.instance;
    return bookCollection.snapshots().map((event) => event.docs.map((e) => BookModel.fromSnapshot(e)).where((element) => element.username == auth.currentUser!.email).toList());
  }

  static Stream<List<BookModel>> readFavorites(){
    final bookCollection = FirebaseFirestore.instance.collection('BookCollection');
    final FirebaseAuth auth = FirebaseAuth.instance;
    return bookCollection.snapshots().map((event) => event.docs.map((e) => BookModel.fromSnapshot(e)).where((element) => element.username == auth.currentUser!.email && element.isFavorite == true).toList());
  }

  static Future update(BookModel book) async {
    final bookCollection = FirebaseFirestore.instance.collection('BookCollection');
    final docRef = bookCollection.doc(book.id);
    final FirebaseAuth auth = FirebaseAuth.instance;

    final newBook = BookModel(
      title: book.title,
      author: book.author,
      description: book.description,
      note: book.note,
      imageUrl: book.imageUrl,
      id: book.id,
      isFavorite: book.isFavorite,
      username: auth.currentUser!.email
    ).toJson();

    try {
      await docRef.update(newBook);
    } catch (e) {
      print('some error occured $e');
    }
  }

  static Future delete(BookModel book) async {
    final bookCollection = FirebaseFirestore.instance.collection('BookCollection');
    final docRef = bookCollection.doc(book.id).delete();
  }
}