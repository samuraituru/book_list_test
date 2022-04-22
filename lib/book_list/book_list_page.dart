import 'package:book_list_test/book_list/book_list_model.dart';
import 'package:book_list_test/book_list/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_book/add_book_page.dart';

class BookListPage extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本一覧'),
        ),

        body: Center(
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widget = books
                .map(
                    (book) => ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
            )
            .toList();
            return ListView(
              children: widget,
            );
          }),
        ),
        floatingActionButton: Consumer<AddBookModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBookPage()),
                );
                model.fetchBookList();
              },
              child: Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}
