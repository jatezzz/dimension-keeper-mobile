import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';
import '../widgets/custom_search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isFirstLoad = true;

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
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      if (!provider.isInitialized) {
        await provider.initialize();
      } else {
        await provider.fetchAllCharacters();
      }
      setState(() {
        _isFirstLoad = false;
      });
    } catch (error) {
      setState(() {
        _isFirstLoad = false;
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
    return Scaffold(
      appBar: CustomSearchBar(
        isSearching: _isSearching,
        searchController: _searchController,
        hintText: 'Search by name...',
        title: 'Dimension Keeper',
        onSearch: _performSearch,
        onCancel: _cancelSearch,
        onStartSearch: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, characterProvider, _) {
          if (_isFirstLoad && characterProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (characterProvider.allCharacters.isEmpty) {
            return const Center(
              child: Text('No characters found.'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () =>
                  Provider.of<CharacterProvider>(context, listen: false)
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
        },
      ),
    );
  }
}
