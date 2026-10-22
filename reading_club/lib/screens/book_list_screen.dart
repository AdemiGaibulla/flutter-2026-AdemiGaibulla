import 'package:flutter/material.dart';
import 'package:reading_club/enums/book_category.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/widgets/book_collection.dart';

class BookListScreen extends StatefulWidget{
  final List<Book> books;
  final void Function(Book) onToggleFavourite;
  final void Function(Book) onBookTap;
  final VoidCallback onAddBook;

  const BookListScreen({super.key, required this.books, required this.onToggleFavourite, required this.onBookTap, required this.onAddBook,});

  @override
  State<BookListScreen> createState(){
    return _StateBookListScreen();
  }
}

class _StateBookListScreen extends State<BookListScreen>{
  String _search = '';
  BookCategory? _selectedCategory;
  bool _showPast = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final filteredBooks = widget.books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_search.toLowerCase());
      final matchesCategory = _selectedCategory == null || book.category == _selectedCategory;
      final matchesPast = !_showPast || book.isPast;

      return matchesSearch && matchesCategory && matchesPast;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _search = '';
                    });
                  },
                ) : null,
              ),
              onChanged: (value) {
                setState(() { _search = value; });
              },
            )
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                ),
                for(final category in BookCategory.values)
                  ChoiceChip(
                      label: Text(category.label),
                      selected: _selectedCategory == category,
                      onSelected: (_){
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilterChip(
                label: const Text('Past items'),
                selected: _showPast,
                onSelected: (value){
                  setState(() {
                    _showPast = value;
                  });
                }, ),
          ),

          Expanded(
                child: filteredBooks.isEmpty ? const Center(child: Text('No books found'),)
                    : BookCollection(
                    books: filteredBooks,
                    onToggleFavourite: widget.onToggleFavourite,
                    onBookTap: widget.onBookTap,
                ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}