import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/character.dart';

class CharacterProvider with ChangeNotifier {
  final String _baseUrl = "https://d51lfraz59.execute-api.us-west-2.amazonaws.com/characters/all";

  List<Character> _characters = [];
  List<Character> _favorites = [];
  List<Character> get characters => [..._characters];
  List<Character> get favorites => [..._favorites];

  Future<void> fetchCharacters({String? query}) async {
      print('___fetchCharacters');

    try {
      final response = await http.get(Uri.parse("$_baseUrl${query ?? ''}"));
      print(response.body);
      final data = json.decode(response.body);
      print(data['results']);
      if (data['results'] != null) {
        _characters = (data['results'] as List)
            .map((item) => Character.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (error) {
      print('___error');
      print(error);
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
}