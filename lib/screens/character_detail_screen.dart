import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';
import '../widgets/character_details_section.dart';
import '../widgets/character_image_header.dart';
import '../widgets/delete_character_dialog.dart';
import '../widgets/edit_character_dialog.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _saveCharacter(BuildContext context) async {
    try {
      await Provider.of<CharacterProvider>(context, listen: false)
          .createCharacter(character, context);
      _showSnackBar(context, 'Character saved successfully!');
    } catch (error) {
      _showSnackBar(context, 'Failed to save character. Please try again.');
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => EditCharacterDialog(character: character),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteCharacterDialog(characterId: character.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider =
        Provider.of<CharacterProvider>(context, listen: false);

    var isSaved = characterProvider.myCharacters.contains(character);
    var saveButton = TextButton(
      onPressed: () => _saveCharacter(context),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Text("Save"),
    );
    var editButton = IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: () => _showEditDialog(context),
    );
    var deleteButton = IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => _showDeleteDialog(context),
    );
    List<Widget> actions = [];
    if (isSaved) {
      actions = [
        editButton,
        deleteButton,
      ];
    } else {
      actions = [saveButton];
    }
    return Scaffold(
      appBar: AppBar(
        title:
            Text(character.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: actions,
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
    );
  }
}
