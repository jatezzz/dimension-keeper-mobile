import 'package:flutter/material.dart';
import '../models/character.dart';
import '../screens/detail_item.dart';

class CharacterDetailsSection extends StatelessWidget {
  final Character character;

  const CharacterDetailsSection({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailItem(label: 'Status', value: character.status),
          DetailItem(label: 'Species', value: character.species),
          DetailItem(label: 'Gender', value: character.gender),
          if (character.type.isNotEmpty)
            DetailItem(label: 'Type', value: character.type),
        ],
      ),
    );
  }
}