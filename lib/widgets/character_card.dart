import 'package:flutter/material.dart';
import '../models/character.dart';
import '../screens/character_detail_screen.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  CharacterCard(this.character);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => CharacterDetailScreen(character)),
        );
      },
      child: GridTile(
        child: Image.network(character.image, fit: BoxFit.cover),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(character.name, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}