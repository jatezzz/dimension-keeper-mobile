import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Search...'),
          onSubmitted: (value) {
            characterProvider.fetchMyCharacters();
          },
        ),
      ),
      body: Consumer<CharacterProvider>(
        builder: (ctx, provider, _) {
          return CharacterGrid(provider.allCharacters);
        },
      ),
    );
  }
}