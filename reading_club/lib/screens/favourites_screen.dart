import 'package:flutter/material.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/widgets/book_collection.dart';

class FavouritesScreen extends StatelessWidget{
  final List<Book> books;
  final void Function(Book) onToggleFavourite;
  final void Function(Book) onBookTap;

  const FavouritesScreen({super.key, required this.books, required this.onToggleFavourite, required this.onBookTap});

  @override
  Widget build(BuildContext context){
    final favourites = books.where((book) => book.favourite).toList();

    return Scaffold(
      body: favourites.isEmpty
          ? const Center(child: Text('No favourites yet'),)
          : BookCollection(
              books: favourites,
              onToggleFavourite: onToggleFavourite,
              onBookTap: onBookTap,
          ),
    );
  }
}