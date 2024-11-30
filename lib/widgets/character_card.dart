import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';
import '../screens/character_detail_screen.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard(this.character, {super.key});

  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<CharacterProvider>(context, listen: false)
        .myCharacters
        .contains(character);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CharacterDetailScreen(character: character),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Card's border radius
        ),
        clipBehavior: Clip.antiAlias, // Ensures content respects border radius
        elevation: 4,
        child: Stack(
          children: [
            // Image with rounded corners at the top
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ), // Rounds only the top corners
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    character.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            // Favorite Icon
            if (isFavorite)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
