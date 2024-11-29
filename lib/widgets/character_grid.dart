import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/widgets/character_card.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';

class CharacterGrid extends StatefulWidget {
  final List<Character> characters;

  const CharacterGrid(this.characters, {super.key});

  @override
  _CharacterGridState createState() => _CharacterGridState();
}

class _CharacterGridState extends State<CharacterGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !Provider.of<CharacterProvider>(context, listen: false).isLoading) {
        Provider.of<CharacterProvider>(context, listen: false)
            .fetchAllCharacters(isNextPage: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
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
