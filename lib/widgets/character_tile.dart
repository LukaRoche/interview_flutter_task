import 'package:flutter/material.dart';
import '../models/person.dart';
import '../screens/character_details_screen.dart';
import 'package:provider/provider.dart';
import '../state/character_provider.dart';

class CharacterTile extends StatelessWidget {
  final Person person;

  const CharacterTile({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(person.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailsScreen(personId: person.id),
            ),
          );
        },
        trailing: Consumer<CharacterProvider>(
          builder: (context, provider, child) {
            final isFav = provider.isFavorite(person.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                provider.toggleFavorite(person.id);
              },
            );
          },
        ),
      ),
    );
  }
}