import 'package:crud_app/model/book.dart';
import 'package:crud_app/pages/detail.dart';
import 'package:crud_app/services/crud.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  List<Widget> createBookCardItem(List<BookModel> books, BuildContext context ) {
    // Children list for the list.
    List<Widget> listElementWidgetList = <Widget>[];
    var lengthOfList = books.length;
    for (int i = 0; i < lengthOfList; i++) {
      BookModel book = books[i];
      // Image URL
      var imageURL = book.imageUrl;
      // List item created with an image of the poster
      var listItem = GridTile(
          footer: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailScreen(book)));
              },
              child: GridTileBar(
                backgroundColor: Colors.black45,
                title: Text(book.title!),
              )),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DetailScreen(book)));
            },
            child: Image.network(imageURL!),
          ));
      listElementWidgetList.add(listItem);
    }
    return listElementWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
      stream: FirestoreHelper.read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasError) {
          return const Center(child: Text('some error occured'),);
        }
        if (snapshot.hasData) {
          final userData = snapshot.data;
          return CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: createBookCardItem(userData!, context),
                ),
              )
            ],
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
}