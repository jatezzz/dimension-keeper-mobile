import 'package:flutter/material.dart';
import '../models/character.dart';
import './character_card.dart';

class CharacterGrid extends StatelessWidget {
  final List<Character> characters;

  CharacterGrid(this.characters);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: characters.length,
      itemBuilder: (ctx, i) => CharacterCard(characters[i]),
    );
  }
}