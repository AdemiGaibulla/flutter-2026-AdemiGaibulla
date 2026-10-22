import 'package:flutter/material.dart';
import 'package:reading_club/models/book.dart';
import 'package:reading_club/enums/book_category.dart';

class BookFormScreen extends StatefulWidget {
  final Book? book;

  const BookFormScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookFormScreen> createState() {
    return _BookFormScreenState();
  }
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _limitController = TextEditingController();
  late BookCategory _selectedCategory;
  bool _mode = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;
  bool _allowPop = false;
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book?.title ?? '';
    _placeController.text = widget.book?.place ?? '';
    _limitController.text = widget.book?.limit.toString() ?? '';
    _selectedCategory = widget.book?.category ?? BookCategory.fiction;
    _mode = widget.book?.mode ?? false;
    final book = widget.book;
    _descriptionController.text = widget.book?.description ?? '';

    if (book != null) {
      _selectedDate = book.when;
      _selectedTime = TimeOfDay.fromDateTime(book.when);
      _dateController.text =
      '${book.when.day}.${book.when.month}.${book.when.year}';
    }
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final book = widget.book;
    if (book != null) {
      _timeController.text = _selectedTime!.format(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _limitController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final book = widget.book;

    if (book == null) {
      return _titleController.text.isNotEmpty ||
          _placeController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _limitController.text.isNotEmpty ||
          _mode ||
          _selectedDate != null ||
          _selectedTime != null;
    }

    return _titleController.text.trim() != book.title ||
        _placeController.text.trim() != book.place ||
        _descriptionController.text.trim() != (book.description ?? '') ||
        _limitController.text != book.limit.toString() ||
        _selectedCategory != book.category ||
        _mode != book.mode ||
        _selectedDate != book.when ||
        _selectedTime != TimeOfDay.fromDateTime(book.when);
  }

  Future<void> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your changes will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (discard == true) {
      setState(() {
        _allowPop = true;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges || _allowPop || _isSaving,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || !_hasChanges || _allowPop || _isSaving) {
          return;
        }

        _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text(widget.book == null ? 'New book' : 'Edit book'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              maxLength: 60,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final title = value?.trim() ?? '';

                if (title.length < 3 || title.length > 60) {
                  return 'Title must be 3–60 characters';
                }

                return null;
              },
            ),

            TextFormField(
              controller: _placeController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: _mode ? 'URL' : 'Place',
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Place is required';
                }
                if (_mode && !value.trim().contains('://')) {
                  return 'URL must contain ://';
                }
                return null;
              },
            ),

            SwitchListTile(
              title: const Text('Online mode'),
              value: _mode,
              onChanged: (value) {
                setState(() {
                  _mode = value;
                });
              },
            ),

            TextFormField(
              controller: _descriptionController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            TextFormField(
              controller: _limitController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Limit',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final limit = int.tryParse(value ?? '');

                if (limit == null || limit < 1 || limit > 500) {
                  return 'Limit must be an integer from 1 to 500';
                }

                final currentBook = widget.book;

                if (currentBook != null && limit < currentBook.count) {
                  return 'Limit cannot be below the current count';
                }

                return null;
              },
            ),
            DropdownButtonFormField<BookCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: BookCategory.values.map((category) {
                return DropdownMenuItem<BookCategory>(
                  value: category,
                  child: Text(category.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) return 'Category is required';
                return null;
              },
            ),

            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_month),
              ),
              controller: _dateController,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );

                if (!mounted) return;

                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    _dateController.text =
                    '${date.day}.${date.month}.${date.year}';
                  });
                }
              },
              validator: (_) {
                if (_selectedDate == null) return 'Date is required';

                return null;
              },
            ),

            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              controller: _timeController,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );

                if (!mounted) return;

                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                    _timeController.text = time.format(context);
                  });
                }
              },
              validator: (_) {
                if (_selectedTime == null) {
                  return 'Time is required';
                }
                return null;
              },
            ),

            FilledButton(
              onPressed: _isSaving
                  ? null
                  : () async {
                if (!_formKey.currentState!.validate()) return;

                final date = _selectedDate;
                final time = _selectedTime;

                if (date == null || time == null) return;

                final when = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                if (widget.book == null && !when.isAfter(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Choose a future date and time'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _isSaving = true;
                });

                final book = Book(
                  title: _titleController.text.trim(),
                  category: _selectedCategory,
                  when: when,
                  limit: int.parse(_limitController.text),
                  place: _placeController.text.trim(),
                  mode: _mode,
                  description: _descriptionController.text.trim().isEmpty
                      ? null
                      : _descriptionController.text.trim(),
                  favourite: widget.book?.favourite ?? false,
                  names: widget.book?.names ?? [],
                );

                await Future.delayed(const Duration(seconds: 1));

                if (!mounted) return;

                Navigator.pop(context, book);
              },
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
      )
    );
  }
}
