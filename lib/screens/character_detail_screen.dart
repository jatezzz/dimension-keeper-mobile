import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  CharacterDetailScreen(this.character);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Column(
        children: [
          Image.network(character.image),
          Text('Status: ${character.status}'),
          Text('Species: ${character.species}'),
          Text('Gender: ${character.gender}'),
          Text('Type: ${character.type}'),
        ],
      ),
    );
  }
}