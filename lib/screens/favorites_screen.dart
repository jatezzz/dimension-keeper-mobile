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
  late ScrollController _scrollController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _refreshFavorites() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    return RefreshIndicator(
      onRefresh: _refreshFavorites,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                      'Failed to load favorites: $_errorMessage'), // Error state
                )
              : characterProvider.myCharacters.isEmpty
                  ? const Center(
                      child: Text('No favorites added yet.'), // Empty state
                    )
                  : buildRefreshIndicator(
                      _refreshFavorites,
                      CharacterGrid(
                          characterProvider.myCharacters, _scrollController),
                    ),
    );
  }

  RefreshIndicator buildRefreshIndicator(
      Future<void> Function() onRefresh, Widget child) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: child,
      ),
    );
  }
}
