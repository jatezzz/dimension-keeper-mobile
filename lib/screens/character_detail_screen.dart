import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';
import '../widgets/character_details_section.dart';
import '../widgets/character_image_header.dart';
import '../widgets/delete_character_dialog.dart';
import '../widgets/edit_character_dialog.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late Character character;
  late bool isSaved;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _checkIfSaved();
  }

  void _checkIfSaved() {
    final characterProvider =
        Provider.of<CharacterProvider>(context, listen: false);
    isSaved = characterProvider.myCharacters
        .map((it) => it.id)
        .contains(character.id);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleSaveCharacter() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .createCharacter(character, context);
      _showSnackBar('Character saved successfully!');
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();
      setState(() {
        _checkIfSaved(); // Update state after saving
      });
    } catch (error) {
      _showSnackBar('Failed to save character. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleEditCharacter() async {
    final updatedCharacter = await showDialog<Character>(
      context: context,
      builder: (ctx) => EditCharacterDialog(character: character),
    );
    if (updatedCharacter != null) {
      setState(() {
        character = updatedCharacter;
        _checkIfSaved();
      });
    }
  }

  Future<void> _handleDeleteCharacter() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) => DeleteCharacterDialog(characterId: character.id),
      );

      if (result == true) {
        await Provider.of<CharacterProvider>(context, listen: false)
            .fetchMyCharacters();
        setState(() {
          _checkIfSaved();
        });
      }
    } catch (error) {
      _showSnackBar('Failed to delete character. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(character.name,
                style: const TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 2,
            actions: isSaved
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: _isLoading ? null : _handleEditCharacter,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _isLoading ? null : _handleDeleteCharacter,
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: _isLoading ? null : _handleSaveCharacter,
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text("Save"),
                    ),
                  ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CharacterImageHeader(character: character),
                CharacterDetailsSection(character: character),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
