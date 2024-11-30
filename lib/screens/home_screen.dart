import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';
import 'favorites_screen.dart'; // Import the FavoritesScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _isLoading = true;
  String? _errorMessage;
  late Future<void> _fetchFuture;
  int _currentIndex = 0;
  bool _isSearching = false; // Track if search mode is active
  final TextEditingController _searchController = TextEditingController();

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


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      Provider.of<CharacterProvider>(context, listen: false)
          .resetCharacters(); // Reset character list
      _fetchFuture = Provider.of<CharacterProvider>(context, listen: false)
          .fetchAllCharacters();
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<CharacterProvider>(context, listen: false)
          .clearCharacters(); // Clear current list
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchAllCharactersByName(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);
    final List<Widget> pages = [
      _isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Loading indicator
      )
          : _errorMessage != null
          ? Center(
        child: Text(
            'Failed to load characters: $_errorMessage'), // Error state
      )
          : characterProvider.allCharacters.isEmpty
          ? const Center(
        child: Text('No characters found.'), // Empty state
      )
          : buildRefreshIndicator(
            () => Provider.of<CharacterProvider>(context, listen: false)
                .fetchAllCharacters(),
            CharacterGrid(characterProvider.allCharacters, _scrollController)),
      const FavoritesScreen(),
    ];

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
            : Text(
                _currentIndex == 0 ? 'Explore Characters' : 'Saved Characters'),
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
                  onPressed: _startSearch,
                ),
              ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
        ],
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
