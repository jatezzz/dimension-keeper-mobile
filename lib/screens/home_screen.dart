import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchFuture;

  @override
  void initState() {
    super.initState();
    // Fetch data once during initialization
    _fetchFuture = Provider.of<CharacterProvider>(context, listen: false).fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rick and Morty')),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load characters: ${snapshot.error}'));
          } else {
            return Consumer<CharacterProvider>(
              builder: (ctx, characterProvider, child) {
                return CharacterGrid(characterProvider.characters);
              },
            );
          }
        },
      ),
    );
  }
}