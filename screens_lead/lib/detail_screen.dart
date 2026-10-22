import 'package:flutter/material.dart';

import 'students.dart';
import 'routes.dart';

class DetailScreen extends StatefulWidget {
  final Student student;

  const DetailScreen({super.key, required this.student});

  @override
  State<DetailScreen> createState() {
    return _DetailStateScreen();
  }
}

class _DetailStateScreen extends State<DetailScreen> {
  late Student _student = widget.student;

  Future<void> _edit() async {
    final name = await Navigator.of(context)
        .pushNamed<String>(Routes.edit, arguments: _student);
    if (name == null || !mounted) return; // backed out, or we are gone
    setState(() => _student = _student.copyWith(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.name),
        actions: [
          IconButton(
            onPressed: () {
              _edit();
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(leading: Icon(Icons.school), title: Text(_student.group)),
          ListTile(leading: Icon(Icons.mail), title: Text(_student.email)),
        ],
      ),
    );
  }
}
