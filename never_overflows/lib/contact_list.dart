import 'package:flutter/material.dart';

import 'contacts.dart';
import 'contact_card.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Text("20 contacts"),
      Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ContactCard(contact: contacts[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: contacts.length,
        ),
      ),
    ],
  );
}
