import 'package:reading_club/enums/book_category.dart';
import 'countdown.dart';

class Book{
  final String title;
  final BookCategory category;
  final DateTime when;
  final int limit;
  final List<String> names;
  final bool mode;
  final String? description;
  final bool favourite;

  const Book({
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    this.names = const [],
    this.mode = false,
    this.description,
    this.favourite = false,
  });

  Book copyWith({
    String? title,
    BookCategory? category,
    DateTime? when,
    int? limit,
    List<String>? names,
    bool? mode,
    String? description,
    bool? favourite,
  }){ return Book(
    title: title ?? this.title,
    category: category ?? this.category,
    when: when ?? this.when,
    limit: limit ?? this.limit,
    names: names ?? this.names,
    mode: mode ?? this.mode,
    description: description ?? this.description,
    favourite: favourite ?? this.favourite,
    );
  }

  factory Book.empty() {
    return Book(
      title: '',
      category: BookCategory.fiction,
      when: DateTime.now(),
      limit: 0,
      names: const [],
      mode: false,
      description: null,
      favourite: false,
    );
  }

  int get count => names.length;
  int get free => limit - count;
  bool get isFull => count >= limit;
  bool get isPast => DateTime.now().isAfter(when);
  bool contains(String name) {
    return names.contains(name);
  }
  ({int taken, int free}) get places => (
  taken: count,
  free: free,
  );

  Countdown get countdown{
    final now = DateTime.now();
    if(now.isBefore(when)){
      return Upcoming(when.difference(now));
    } else if(now.difference(when).inHours < 3) {
      return Started(now.difference(when));
    } else {
      return const Ended();
    }
  }
}
