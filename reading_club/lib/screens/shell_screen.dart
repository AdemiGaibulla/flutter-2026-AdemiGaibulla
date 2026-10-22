import 'package:flutter/material.dart';
import 'package:reading_club/data/seed_books.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/models/profile.dart';
import 'package:reading_club/screens/book_list_screen.dart';
import 'package:reading_club/screens/profile_screen.dart';
import 'package:reading_club/screens/favourites_screen.dart';
import 'package:reading_club/utils/routes.dart';

class ShellScreen extends StatefulWidget{
  final ThemeMode currentThemeMode;
  final void Function(ThemeMode) onChangeTheme;

  const ShellScreen({super.key, required this.onChangeTheme, required this.currentThemeMode, });

  @override
  State<ShellScreen> createState(){
    return _ShellScreenState();
  }
}

class _ShellScreenState extends State<ShellScreen>{
  List<Book> _books = List.of(seedBooks);
  int _selectedIndex = 0;
  Profile _profile = Profile.empty();

  void _toggleFavourite(Book book){
    setState(() {
      final index = _books.indexOf(book);

      if(index != -1) {
        _books[index] = book.copyWith(
          favourite: !book.favourite,
        );
      }
    });
  }

  Book _toggleName(Book book, String name) {
    final index = _books.indexOf(book);

    if (index == -1) return book;

    final names = List<String>.from(book.names);

    if (names.contains(name)) {
      names.remove(name);
    } else {
      names.add(name);
    }

    final updatedBook = book.copyWith(names: names);

    setState(() {
      _books[index] = updatedBook;
    });

    return updatedBook;
  }

  void _updateProfile(Profile profile) {
    setState(() {
      _profile = profile;
    });
  }

  void _openBook(Book book) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: DetailArguments(
        book: book,
        profileName: _profile.name,
        onToggleName: _toggleName,
        onOpenProfile: _openProfileTab,
        onDelete: () => _deleteBook(book),
        onBookUpdated: _updateBook,
      ),
    );
  }

  void _openProfileTab() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _deleteBook(Book book) {
    setState(() {
      _books.remove(book);
    });
  }

  void _updateBook(Book oldBook, Book updatedBook) {
    setState(() {
      final index = _books.indexOf(oldBook);

      if (index != -1) {
        _books[index] = updatedBook;
      }
    });
  }

  Future<void> _addBook() async {
    final newBook = await Navigator.pushNamed<Book>(
      context,
      Routes.form,
      arguments: const FormArguments(book: null),
    );

    if (!mounted || newBook == null) return;

    setState(() {
      _books.add(newBook);
    });
  }

  int _resetCount = 0;

  static const _titles = ['Books', 'Favourites', 'Profile'];

  Future<void> _showAbout() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const Text('Reading Club: Lab 1'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text('Books will be restored to the initial list and your profile will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _books = List.of(seedBooks);
      _profile = Profile.empty();
      _resetCount++;
    });
  }

  @override
  Widget build(BuildContext context){
    final screens = [
      BookListScreen(
        books: _books,
        onToggleFavourite: _toggleFavourite,
        onBookTap: _openBook,
        onAddBook: _addBook,
      ),
      FavouritesScreen(
          books: _books,
          onToggleFavourite: _toggleFavourite,
          onBookTap: _openBook,
      ),
      ProfileScreen(
        key: ValueKey(_resetCount),
        profile: _profile,
        onProfileChanged: _updateProfile,
        currentThemeMode: widget.currentThemeMode,
        onChangeTheme: widget.onChangeTheme,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Reading Club'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAbout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Reset data'),
              onTap: () {
                Navigator.pop(context);
                _resetData();
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination( icon: Icon(Icons.menu_book), label: 'Books' ),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorite'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}