import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/models/status_extension.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';

class EditCharacterDialog extends StatelessWidget {
  final Character character;

  const EditCharacterDialog({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: character.name);
    final statusController =
        TextEditingController(text: character.status.toReadableString());
    final speciesController = TextEditingController(text: character.species);
    final genderController = TextEditingController(text: character.gender);

    return AlertDialog(
      title: const Text('Edit Character Info'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status')),
            TextField(
                controller: speciesController,
                decoration: const InputDecoration(labelText: 'Species')),
            TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            var firstWhere = Status.values
                  .firstWhere((it) => it.name.toLowerCase() == statusController.text.toLowerCase(), orElse: ()=>Status.unknown);
            final updatedCharacter = Character(
              id: character.id,
              name: nameController.text,
              status: firstWhere,
              species: speciesController.text,
              gender: genderController.text,
              type: character.type,
              image: character.image,
            );

            Provider.of<CharacterProvider>(context, listen: false)
                .updateCharacter(updatedCharacter, context);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
