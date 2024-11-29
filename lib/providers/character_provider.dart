import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/character.dart';

class CharacterProvider with ChangeNotifier {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  final List<Character> _allCharacters = [];
  List<Character> _myCharacters = [];
  final List<Character> _favorites = [];

  List<Character> get myCharacters => [..._myCharacters];
  List<Character> get favorites => [..._favorites];

  int _currentPage = 1; // Track the current page
  bool _isLoading = false; // Prevent multiple simultaneous fetches
  bool _hasMore = true; // Track if more data is available

  List<Character> get allCharacters => [..._allCharacters];
  bool get isLoading => _isLoading;

  // Utility method to log HTTP requests and responses
  Future<http.Response> _logHttpRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      print("HTTP Request: ${response.request}");
      print("HTTP Response: ${response.statusCode} - ${response.body}");
      return response;
    } catch (e) {
      print("HTTP Error: $e");
      rethrow;
    }
  }

  Future<void> fetchAllCharacters({bool isNextPage = false}) async {
    if (_isLoading || !_hasMore) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _logHttpRequest(
            () => http.get(Uri.parse("$_baseUrl/all?page=$_currentPage")),
      );

      final data = json.decode(response.body);

      if (data['results'] != null) {
        final newCharacters = (data['results'] as List)
            .map((item) => Character.fromJson(item))
            .toList();
        _allCharacters.addAll(newCharacters);

        // Check if there are more pages to fetch
        _hasMore = data['info']['next'] != null;

        if (_hasMore) {
          _currentPage++;
        }

        notifyListeners();
      }
    } catch (error) {
      print("Error fetching characters: $error");
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
      clearCharacters(); // Clear the list before making the request

      final response = await http.get(Uri.parse("$_baseUrl/all?name=$name"));
      final data = json.decode(response.body);

      if (data['results'] != null) {
        _allCharacters.addAll((data['results'] as List)
            .map((item) => Character.fromJson(item))
            .toList());
      }

      _isLoading = false; // Set loading to false after fetching data
      notifyListeners();
    } catch (error) {
      print("Error searching characters by name: $error");
      _isLoading = false; // Ensure loading is reset on error
      notifyListeners();
      throw error;
    }
  }

  Future<void> fetchMyCharacters() async {
    try {
      final response = await _logHttpRequest(
            () => http.get(Uri.parse("$_baseUrl/me")),
      );

      final data = json.decode(response.body);

      if (data['results'] != null) {
        _myCharacters = (data['results'] as List)
            .map((item) => Character.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (error) {
      print("Error fetching my characters: $error");
      throw error;
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

  Future<void> createCharacter(Character character) async {
    try {
      final response = await _logHttpRequest(
            () => http.post(
          Uri.parse("$_baseUrl"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': character.name,
            'status': character.status,
            'species': character.species,
            'gender': character.gender,
            'type': character.type,
          }),
        ),
      );

      if (response.statusCode == 201) {
        _myCharacters.add(character);
        notifyListeners();
      } else {
        throw Exception('Failed to create character');
      }
    } catch (error) {
      print("Error creating character: $error");
      throw error;
    }
  }

  Future<void> updateCharacter(Character character) async {
    try {
      final response = await _logHttpRequest(
            () => http.put(
          Uri.parse("$_baseUrl/${character.id}"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': character.name,
            'status': character.status,
            'species': character.species,
            'gender': character.gender,
            'type': character.type,
          }),
        ),
      );

      if (response.statusCode == 200) {
        final index = _myCharacters.indexWhere((item) => item.id == character.id);
        if (index != -1) {
          _myCharacters[index] = character;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update character');
      }
    } catch (error) {
      print("Error updating character: $error");
      throw error;
    }
  }

  Future<void> deleteCharacter(int characterId) async {
    try {
      final response = await _logHttpRequest(
            () => http.delete(Uri.parse("$_baseUrl/$characterId")),
      );

      if (response.statusCode == 200) {
        _myCharacters.removeWhere((item) => item.id == characterId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete character');
      }
    } catch (error) {
      print("Error deleting character: $error");
      throw error;
    }
  }
}