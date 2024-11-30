import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/models/character.dart';

import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Character> _filteredCharacters = [];
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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _filteredCharacters =
            Provider.of<CharacterProvider>(context, listen: false)
                .myCharacters;
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
      setState(() {
        _filteredCharacters =
            Provider.of<CharacterProvider>(context, listen: false)
                .myCharacters;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  void _performSearch(String query) {
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    if (query.isNotEmpty) {
      setState(() {
        _filteredCharacters = provider.myCharacters
            .where((character) =>
            character.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredCharacters = provider.myCharacters;
      });
    }
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredCharacters = Provider.of<CharacterProvider>(context, listen: false)
          .myCharacters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    Widget content;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_errorMessage != null) {
      content = Center(
        child: Text('Failed to load favorites: $_errorMessage'),
      );
    } else if (_filteredCharacters.isEmpty) {
      content = const Center(
        child: Text('No favorite characters match your search.'),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: _refreshFavorites,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: CharacterGrid(_filteredCharacters, _scrollController),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search favorites...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus(); // Hide the keyboard
          },
        )
            : const Text('Saved Characters'),
        actions: _isSearching
            ? [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelSearch,
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: content,
    );
  }
}