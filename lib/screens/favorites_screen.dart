import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<void> _fetchFavoritesFuture;

  @override
  void initState() {
    super.initState();
    _fetchFavoritesFuture =
        Provider.of<CharacterProvider>(context, listen: false).fetchMyCharacters();
  }

  Future<void> _refreshFavorites() async {
    await Provider.of<CharacterProvider>(context, listen: false).fetchMyCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: FutureBuilder(
        future: _fetchFavoritesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load favorites: ${snapshot.error}'));
          } else if (characterProvider.myCharacters.isEmpty) {
            return const Center(child: Text('No favorites added yet.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshFavorites,
              child: Scrollbar(
                thumbVisibility: true, // Show scroll bar for better UX
                child: CharacterGrid(characterProvider.myCharacters),
              ),
            );
          }
        },
      ),
    );
  }
}