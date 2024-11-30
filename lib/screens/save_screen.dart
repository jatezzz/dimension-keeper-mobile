import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/models/character.dart';

import '../main.dart';
import '../providers/character_provider.dart';
import '../widgets/character_grid.dart';
import '../widgets/custom_search_bar.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> with RouteAware {
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
      _loadSavedCharacters();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when navigating back to this screen
    _loadSavedCharacters();
  }

  Future<void> _loadSavedCharacters() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _filteredCharacters =
            Provider.of<CharacterProvider>(context, listen: false).myCharacters;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _refreshSavedCharacters() async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
      setState(() {
        _filteredCharacters =
            Provider.of<CharacterProvider>(context, listen: false).myCharacters;
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
      _filteredCharacters =
          Provider.of<CharacterProvider>(context, listen: false).myCharacters;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_errorMessage != null) {
      content = Center(
        child: Text('Failed to load saved characters: $_errorMessage'),
      );
    } else if (_filteredCharacters.isEmpty) {
      content = const Center(
        child: Text('No saved characters match your search.'),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: _refreshSavedCharacters,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: CharacterGrid(_filteredCharacters, _scrollController),
        ),
      );
    }

    return Scaffold(
      appBar: CustomSearchBar(
        isSearching: _isSearching,
        searchController: _searchController,
        hintText: 'Search saved...',
        title: 'Dimension Keeper',
        onSearch: _performSearch,
        onCancel: _cancelSearch,
        onStartSearch: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
      body: content,
    );
  }
}