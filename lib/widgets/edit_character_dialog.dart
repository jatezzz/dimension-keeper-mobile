import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/status_extension.dart';
import '../providers/character_provider.dart';

class EditCharacterDialog extends StatefulWidget {
  final Character character;

  const EditCharacterDialog({super.key, required this.character});

  @override
  _EditCharacterDialogState createState() => _EditCharacterDialogState();
}

class _EditCharacterDialogState extends State<EditCharacterDialog> {
  late TextEditingController nameController;
  late TextEditingController speciesController;
  late TextEditingController genderController;
  late Status selectedStatus;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.character.name);
    speciesController = TextEditingController(text: widget.character.species);
    genderController = TextEditingController(text: widget.character.gender);
    selectedStatus = widget.character.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Character Info'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<Status>(
              value: selectedStatus,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Status'),
              items: Status.values.map((status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(status.toReadableString()),
                );
              }).toList(),
            ),
            TextField(
              controller: speciesController,
              decoration: const InputDecoration(labelText: 'Species'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
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
            final updatedCharacter = Character(
              id: widget.character.id,
              name: nameController.text,
              status: selectedStatus,
              species: speciesController.text,
              gender: genderController.text,
              type: widget.character.type,
              image: widget.character.image,
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