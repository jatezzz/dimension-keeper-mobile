import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/widgets/character_card.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';

class CharacterGrid extends StatefulWidget {
  final List<Character> characters;
  final ScrollController _scrollController;

  const CharacterGrid(this.characters, this._scrollController, {super.key});

  @override
  _CharacterGridState createState() => _CharacterGridState();
}

class _CharacterGridState extends State<CharacterGrid> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Stack(
      children: [
        GridView.builder(
          controller: widget._scrollController,
          padding: const EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.characters.length,
          itemBuilder: (ctx, i) => CharacterCard(widget.characters[i]),
        ),
        if (provider.isLoading)
          const Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
