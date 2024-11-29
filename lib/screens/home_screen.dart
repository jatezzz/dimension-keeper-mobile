import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchFuture;
  int _currentIndex = 0;
  bool _isSearching = false; // Track if search mode is active
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFuture = Provider.of<CharacterProvider>(context, listen: false).fetchAllCharacters();
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
      Provider.of<CharacterProvider>(context, listen: false).resetCharacters(); // Reset character list
      _fetchFuture = Provider.of<CharacterProvider>(context, listen: false).fetchAllCharacters();
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<CharacterProvider>(context, listen: false).clearCharacters(); // Clear current list
      Provider.of<CharacterProvider>(context, listen: false).fetchAllCharactersByName(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    // Tabs content
    final List<Widget> pages = [
      if (characterProvider.isLoading)
        const Center(child: CircularProgressIndicator()) // Show loading indicator
      else if (characterProvider.allCharacters.isEmpty)
        const Center(child: Text('No characters found.')) // Show empty message
      else
        CharacterGrid(characterProvider.allCharacters),
      characterProvider.favorites.isEmpty
          ? const Center(child: Text('No favorite characters yet.'))
          : CharacterGrid(characterProvider.favorites),
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
            : Text(_currentIndex == 0 ? 'Explore Characters' : 'Saved Characters'),
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
}