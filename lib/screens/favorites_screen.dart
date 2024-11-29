import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteCharacters =
        Provider.of<CharacterProvider>(context).favorites;

    return Scaffold(
      body: favoriteCharacters.isEmpty
          ? Center(child: Text('No favorites added yet.'))
          : CharacterGrid(favoriteCharacters),
    );
  }
}