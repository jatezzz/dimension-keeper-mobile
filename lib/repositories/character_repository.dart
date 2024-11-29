import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharacterRepository {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Character>> fetchAllCharacters(int page) async {
    final response = await http.get(Uri.parse("$_baseUrl/all?page=$page"));
    return _parseCharacterList(response, isExternal: true);
  }

  Future<List<Character>> fetchAllCharactersByName(String name) async {
    final response = await http.get(Uri.parse("$_baseUrl/all?name=$name"));
    return _parseCharacterList(response, isExternal: true);
  }

  Future<List<Character>> fetchMyCharacters() async {
    final response = await http.get(Uri.parse("$_baseUrl/me"));
    return _parseCharacterList(response);
  }

  Future<void> createCharacter(Character character) async {
    final response = await http.post(
      Uri.parse("$_baseUrl"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': character.id,
        'image': character.image,
        'name': character.name,
        'status': character.status,
        'species': character.species,
        'gender': character.gender,
        'type': character.type,
      }),
    );
    _checkResponse(response, 201, "Failed to create character");
  }

  Future<void> updateCharacter(Character character) async {
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
    _checkResponse(response, 200, "Failed to update character");
  }

  Future<void> deleteCharacter(String characterId) async {
    final response = await http.delete(Uri.parse("$_baseUrl/$characterId"));
    _checkResponse(response, 200, "Failed to delete character");
  }

  // Parse the character list from response
  List<Character> _parseCharacterList(http.Response response,
      {bool isExternal = false}) {
    _checkResponse(response, 200, "Failed to fetch characters");
    final data = json.decode(response.body);
    if(isExternal){
      return (data['results'] as List)
          .map((item) => Character.fromJson(item))
          .toList();
    }
    return (data as List)
        .map((item) => Character.fromJson(item))
        .toList();
  }

  // Check response status and throw an error if necessary
  void _checkResponse(http.Response response, int expectedStatus, String errorMessage) {
    if (response.statusCode != expectedStatus) {
      throw Exception("$errorMessage: ${response.statusCode} - ${response.body}");
    }
  }
}