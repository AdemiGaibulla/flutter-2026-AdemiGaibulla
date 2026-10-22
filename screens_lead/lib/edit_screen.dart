import 'package:flutter/material.dart';

import 'students.dart';

class EditScreen extends StatefulWidget {
  final Student student;

  const EditScreen({super.key, required this.student});

  @override
  State<EditScreen> createState() {
    return _EditScreenState();
  }
}

class _EditScreenState extends State<EditScreen> {
  late String _name = widget.student.name;

  bool get _dirty => _name != widget.student.name;

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('Keep editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<String>(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldDiscard = await _showDiscardDialog();

        if (shouldDiscard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Edit Student")),
        body: Column(
          children: [
            TextField(onChanged: (v) => setState(() => _name = v)),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(_name);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
