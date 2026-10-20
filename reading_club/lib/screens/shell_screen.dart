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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('Reading Club'),),


    );
  }
}