import 'package:flutter/material.dart';

import 'profile_header.dart';
import 'data.dart';
import 'info_row.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My Profile')),
        body: Column(
          children: [
            ProfileHeader(name: myName, university: myUniversity),
            for (final fact in facts)
              InfoRow(label: fact.label, value: fact.value),
          ],
        ),
      ),
    ),
  );
}
