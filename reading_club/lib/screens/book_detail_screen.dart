import 'package:flutter/material.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/models/countdown.dart';
import 'dart:async';
import 'package:reading_club/utils/format.dart';
import 'package:reading_club/utils/routes.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final String profileName;
  final Book Function(Book, String) onToggleName;
  final VoidCallback onOpenProfile;
  final VoidCallback onDelete;
  final void Function(Book, Book) onBookUpdated;

  const BookDetailScreen({super.key, required this.book, required this.profileName, required this.onToggleName, required this.onOpenProfile, required this.onDelete, required this.onBookUpdated,});

  @override
  State<BookDetailScreen> createState() {
    return _BookDetailScreenState();
  }
}

class _BookDetailScreenState extends State<BookDetailScreen>{
  Timer? _timer;
  late Book _book;

  @override
  void initState(){
    super.initState();
    _book = widget.book;

    _timer = Timer.periodic(
        const Duration(minutes:1),
        (timer){
          setState(() {});
        }
    );
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  String _countdownText(Countdown countdown){
    return switch (countdown) {
      Upcoming(:final duration) => 'Starts in ${duration.inDays} days',
      Started(:final duration) => 'Started ${duration.inMinutes} minutes ago',
      Ended() => 'Ended',
    };
  }

  bool get _isJoined {
    return _book.contains(widget.profileName);
  }

  Future<bool> _confirmAction() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_isJoined ? 'Leave book club?' : 'Join book club?'),
          content: Text(
            _isJoined
                ? 'Do you want to leave?'
                : 'Do you want to join?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book?'),
        content: const Text(
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _deleteBook() async {
    final confirmed = await _confirmDelete();

    if (!mounted) return;
    if (!confirmed) return;

    widget.onDelete();
    Navigator.pop(context);
  }

  Future<void> _editBook() async {
    final oldBook = _book;

    final updatedBook = await Navigator.pushNamed<Book>(
      context,
      Routes.form,
      arguments: FormArguments(book: _book),
    );

    if (!mounted || updatedBook == null) return;

    widget.onBookUpdated(oldBook, updatedBook);

    setState(() {
      _book = updatedBook;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book Details'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                      _editBook();
                  } else if (value == 'delete') {
                    _deleteBook();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  children:[
                    Positioned.fill(
                      child: Image.asset('assets/book_header.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Icon(
                        Icons.menu_book,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Text(_book.category.label),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Text(
                        _countdownText(_book.countdown),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                tabs: [
                  Tab(text: 'About'),
                  Tab(text: 'Names (${_book.count})'),
                ],
              ),
              Expanded(
                child:TabBarView(
                  children: [
                    Column(
                      children: [
                        Text(formatDate(_book.when)),
                        Text(_book.place),
                        Builder(
                          builder: (context) {
                            final (:taken, :free) = _book.places;

                            return Text('$taken/${_book.limit} places taken · $free free');
                          },
                        ),
                        if (_book.description case final description?) Text(description),
                      ],
                    ),
                    ListView(
                      children: [
                        for (final name in _book.names)
                          ListTile(
                            title: Text(name == widget.profileName ? 'You' : name),
                          ),
                      ]
                    )
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: (_book.isFull && !_isJoined)
                      ? null
                      : () async {
                    if (widget.profileName.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please enter your name in Profile first'),
                          action: SnackBarAction(
                            label: 'Profile',
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onOpenProfile();
                            },
                          ),
                        ),
                      );
                      return;
                    }

                    final confirmed = await _confirmAction();

                    if (!mounted) return;
                    if (!confirmed) return;

                    setState(() {
                      _book = widget.onToggleName(_book, widget.profileName);
                    });
                  },
                  child: Text(_isJoined ? 'Leave' : 'Join'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}