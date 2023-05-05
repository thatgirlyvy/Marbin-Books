import 'package:crud_app/model/book.dart';
import 'package:crud_app/pages/edit.dart';
import 'package:crud_app/pages/lists.dart';
import 'package:crud_app/services/crud.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {

  BookModel book;
  DetailScreen(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title!),
        actions: <Widget> [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(
                  book: BookModel(
                    author: book.author,
                    description: book.description,
                    title: book.title,
                    imageUrl: book.imageUrl,
                    note: book.note,
                    id: book.id,
                    isFavorite: book.isFavorite
                  ),
                )));
                },
                child: const Icon(Icons.edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      elevation: 2,
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: <Widget> [
                          Container(
                            padding: const EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
                            margin: const EdgeInsets.only(top: 45),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10)
                              ]
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget> [
                                const Text('Delete this book', style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600
                                ),),
                                const SizedBox(height: 15,),
                                const Text('Are you sure you want to delete this item? This action is irreversible', style: TextStyle(
                                  fontSize: 14,
                                ), textAlign: TextAlign.center,),
                                const SizedBox(height: 22,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      FirestoreHelper.delete(book).then((value) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ListScreen()));
                                      });
                                      print(book.id);
                                    },
                                    child: const Text('Delete', style: TextStyle(fontSize: 18),),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 45,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(45)),
                                child: Image.asset('assets/logo.png'),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
                },
                child: const Icon(Icons.delete),
              ),
            ),
          ],
      ),
      body: ListView(
        children: <Widget> [
          Image.network(book.imageUrl!),
          Container(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Title: ${book.title!}',
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    Text(
                      'Author: ${book.author!}',
                      style: TextStyle(color: Colors.grey[500]),
                    )
                  ],
                )),
                Icon(Icons.star, color: Colors.red[500],),
                Text('${book.note}'),
                const SizedBox(width: 20,),
                Visibility(visible: book.isFavorite!,child: const Icon(Icons.favorite, color: Colors.amber,),)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(book.description!, softWrap: true,)
          )
        ],
      ),
    );
  }
}