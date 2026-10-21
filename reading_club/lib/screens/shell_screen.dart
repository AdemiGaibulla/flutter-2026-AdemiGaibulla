import 'package:flutter/material.dart';
import 'package:reading_club/data/seed_books.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/models/profile.dart';


class ShellScreen extends StatefulWidget{
  const ShellScreen ({super.key});

  @override
  State<ShellScreen> createState(){
    return _ShellScreenState();
  }
}

class _ShellScreenState extends State<ShellScreen>{
  final int _selectedIndex = 0;
  List<Book> _books = List.from(seedBooks);
  Profile _profile = Profile.empty();

  void _toggleFavorite(Book targetBook) {
    setState(() {
      final index = _books.indexWhere((b) => b.title == targetBook.title);

      if(index != -1){
        _books[index] = _books[index].copyWith(favourite: !_books[index].favourite, );
      }
    });
  }

  void _resetData(){
    setState(() {
      _books = List.from(seedBooks);
      _profile = Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('Reading Club'),),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Reading Club App')),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reset Data'),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirmDialog(context);
              },
            ),
          ],
        ),
      ),

    );
  }
  void _showAboutDialog(BuildContext context) {
    showDialog(context: context,
      builder:(context) => AlertDialog(
        title: const Text('About'),
        content: const Text('Reading Club App\n Lab 1'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data'),
        content: const Text('Are you sure you want to restore seed books and clear profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetData();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}