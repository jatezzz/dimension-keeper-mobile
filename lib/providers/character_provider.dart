import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/character.dart';

class CharacterProvider with ChangeNotifier {
  final String _baseUrl = "https://d51lfraz59.execute-api.us-west-2.amazonaws.com/characters";

  List<Character> _allCharacters = [];
  List<Character> _myCharacters = [];
  List<Character> _favorites = [];

  // Getters
  List<Character> get allCharacters => [..._allCharacters];
  List<Character> get myCharacters => [..._myCharacters];
  List<Character> get favorites => [..._favorites];

  // Fetch all characters from the API
  Future<void> fetchAllCharacters() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/all"));
      final data = json.decode(response.body);

      if (data['results'] != null) {
        _allCharacters = (data['results'] as List)
            .map((item) => Character.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (error) {
      print("Error fetching all characters: $error");
      throw error;
    }
  }

  // Fetch user-specific characters
  Future<void> fetchMyCharacters() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/me"));
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

  // Toggle favorites
  void toggleFavorite(Character character) {
    if (_favorites.contains(character)) {
      _favorites.remove(character);
    } else {
      _favorites.add(character);
    }
    notifyListeners();
  }

  // Create a new character
  Future<void> createCharacter(Character character) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': character.name,
          'status': character.status,
          'species': character.species,
          'gender': character.gender,
          'type': character.type,
        }),
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

  // Update an existing character
  Future<void> updateCharacter(Character character) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/${character.id}"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': character.name,
          'status': character.status,
          'species': character.species,
          'gender': character.gender,
          'type': character.type,
        }),
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

  // Delete a character
  Future<void> deleteCharacter(int characterId) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/$characterId"));

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