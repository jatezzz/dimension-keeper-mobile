import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';

class DeleteCharacterDialog extends StatelessWidget {
  final String characterId;

  const DeleteCharacterDialog({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Character'),
      content: const Text('Are you sure you want to delete this character?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<CharacterProvider>(context, listen: false)
                .deleteCharacter(characterId, context);
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Return to the previous screen
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
