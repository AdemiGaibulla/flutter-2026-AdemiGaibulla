import 'package:flutter/material.dart';
import 'package:reading_club/models/book.dart';

class Routes {
  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

class DetailArguments {
  final Book book;
  final String profileName;
  final Book Function(Book, String) onToggleName;
  final VoidCallback onOpenProfile;
  final VoidCallback onDelete;
  final void Function(Book, Book) onBookUpdated;

  const DetailArguments({ required this.book, required this.profileName, required this.onToggleName, required this.onOpenProfile, required this.onDelete, required this.onBookUpdated,});
}

class FormArguments {
  final Book? book;

  const FormArguments({ required this.book});
}