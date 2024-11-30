import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';

class DeleteCharacterDialog extends StatelessWidget {
  final String characterId;

  const DeleteCharacterDialog({super.key, required this.characterId});

  Future<void> _handleDelete(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await Provider.of<CharacterProvider>(context, listen: false)
          .deleteCharacter(characterId, context);

      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();

      Navigator.of(context).pop();
      Navigator.of(context).pop(true); // Return success result
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete character: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Character'),
      content: const Text('Are you sure you want to delete this character?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Return cancel result
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _handleDelete(context),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}