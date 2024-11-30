import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterImageHeader extends StatelessWidget {
  final Character character;

  const CharacterImageHeader({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: character.id,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(character.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              character.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}