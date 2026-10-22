import 'package:flutter/material.dart';

enum BookCategory{
  fiction('Fiction', Icons.menu_book),
  fantasy('Fantasy', Icons.auto_awesome),
  detective('Detective',Icons.search),
  science('Science', Icons.science),
  romance('Romance', Icons.favorite);

  final String label;
  final IconData icon;

  const BookCategory(this.label, this.icon);

  Color color(ColorScheme scheme) => switch(this) {
    BookCategory.fiction => scheme.primary,
    BookCategory.fantasy => scheme.secondary,
    BookCategory.detective => scheme.tertiary,
    BookCategory.science => scheme.outline,
    BookCategory.romance => scheme.error,
  };
}