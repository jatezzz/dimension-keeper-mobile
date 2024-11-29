import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'error_handler.dart';

class CharacterProvider with ChangeNotifier {
  final CharacterRepository repository;

  CharacterProvider(this.repository);

  final List<Character> _allCharacters = [];
  final List<Character> _myCharacters = [];
  final List<Character> _favorites = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Character> get allCharacters => [..._allCharacters];
  List<Character> get myCharacters => [..._myCharacters];
  List<Character> get favorites => [..._favorites];
  bool get isLoading => _isLoading;

  Future<void> fetchAllCharacters({bool isNextPage = false}) async {
    if (_isLoading || !_hasMore) return;
    try {
      _isLoading = true;
      notifyListeners();

      final newCharacters = await repository.fetchAllCharacters(_currentPage);
      _allCharacters.addAll(newCharacters);
      _hasMore = newCharacters.isNotEmpty;
      if (_hasMore) _currentPage++;
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear characters when a new request starts
  void clearCharacters() {
    _allCharacters.clear();
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();
  }

  // Reset characters to their original state
  void resetCharacters() {
    _allCharacters.clear();
    _isLoading = false;
    _currentPage = 1;
    notifyListeners();
  }

  Future<void> fetchAllCharactersByName(String name) async {
    try {
      _allCharacters.clear();
      notifyListeners();

      final characters = await repository.fetchAllCharactersByName(name);
      _allCharacters.addAll(characters);
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMyCharacters() async {
    try {
      _myCharacters.clear();
      notifyListeners();

      final characters = await repository.fetchMyCharacters();
      _myCharacters.addAll(characters);
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  void toggleFavorite(Character character) {
    if (_favorites.contains(character)) {
      _favorites.remove(character);
    } else {
      _favorites.add(character);
    }
    notifyListeners();
  }

  Future<void> createCharacter(Character character, BuildContext context) async {
    try {
      await repository.createCharacter(character);
      _myCharacters.add(character);
      notifyListeners();
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<void> updateCharacter(Character character, BuildContext context) async {
    try {
      await repository.updateCharacter(character);
      final index = _myCharacters.indexWhere((item) => item.id == character.id);
      if (index != -1) {
        _myCharacters[index] = character;
        notifyListeners();
      }
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<void> deleteCharacter(String characterId, BuildContext context) async {
    try {
      await repository.deleteCharacter(characterId);
      _myCharacters.removeWhere((item) => item.id == characterId);
      notifyListeners();
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }
}