import 'package:flutter/material.dart';

import 'contact_card.dart';
import 'contacts.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '20 contacts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: contacts.length,
              itemBuilder: (context, i) => ContactCard(contact: contacts[i]),
              separatorBuilder: (context, i) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}