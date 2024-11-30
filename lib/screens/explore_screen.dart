import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ScrollController _scrollController;
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllCharacters();
    });
  }

  Future<void> _loadAllCharacters() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchAllCharacters();
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

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<CharacterProvider>(context, listen: false).clearCharacters();
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchAllCharactersByName(query);
    }
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      Provider.of<CharacterProvider>(context, listen: false).resetCharacters();
      _loadAllCharacters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
        child: Text('Failed to load characters: $_errorMessage'),
      );
    } else if (characterProvider.allCharacters.isEmpty) {
      content = const Center(
        child: Text('No characters found.'),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: () => Provider.of<CharacterProvider>(context, listen: false)
            .fetchAllCharacters(),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: CharacterGrid(
            characterProvider.allCharacters,
            _scrollController,
          ),
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
            hintText: 'Search by name...',
            border: InputBorder.none,
          ),
          onSubmitted: _performSearch,
        )
            : const Text('Explore Characters'),
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