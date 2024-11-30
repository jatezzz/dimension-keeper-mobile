import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'error_handler.dart';

class CharacterProvider with ChangeNotifier {
  final CharacterRepository repository;

  CharacterProvider(this.repository);

  final List<Character> _allCharacters = [];
  final List<Character> _myCharacters = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Character> get allCharacters => [..._allCharacters];
  List<Character> get myCharacters => [..._myCharacters];
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void clearCharacters() {
    _allCharacters.clear();
    _isLoading = true;
    _currentPage = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void resetCharacters() {
    _allCharacters.clear();
    _isLoading = false;
    _currentPage = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await fetchMyCharacters();
      _isInitialized = true;

      // Defer notifying listeners to after the current build frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (error) {
      debugPrint('Error during initialization: $error');
    }
  }

  Future<void> fetchMyCharacters() async {
    try {
      _myCharacters.clear();

      final characters = await repository.fetchMyCharacters();
      _myCharacters.addAll(characters);

      // Defer notifying listeners to avoid build conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAllCharactersByName(String name) async {
    _isLoading = true;
    try {
      _allCharacters.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final characters = await repository.fetchAllCharactersByName(name);
      _allCharacters.addAll(characters);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCharacter(Character character, BuildContext context) async {
    try {
      await repository.createCharacter(character);
      _myCharacters.add(character);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }

  Future<void> deleteCharacter(String characterId, BuildContext context) async {
    try {
      await repository.deleteCharacter(characterId);
      _myCharacters.removeWhere((item) => item.id == characterId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (error) {
      ErrorHandler.handleError(context, error);
    }
  }
}