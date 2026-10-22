import 'package:flutter/material.dart';

import 'students.dart';
import 'routes.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(students[index].name[0])),
            title: Text(students[index].name),
            subtitle: Text(students[index].group),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.student, arguments: students[index]);
            },
          );
        },
        itemCount: students.length,
      ),
    );
  }
}
