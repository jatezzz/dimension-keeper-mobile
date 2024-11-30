import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/widgets/wrap_with_padding.dart';

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

  Future<void> _handleSave(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final updatedCharacter = Character(
        id: widget.character.id,
        name: nameController.text,
        status: selectedStatus,
        species: speciesController.text,
        gender: genderController.text,
        type: widget.character.type,
        image: widget.character.image,
      );

      // Update character
      await Provider.of<CharacterProvider>(context, listen: false)
          .updateCharacter(updatedCharacter, context);

      // Refresh character list
      await Provider.of<CharacterProvider>(context, listen: false)
          .fetchMyCharacters();

      // Close loading indicator and dialog
      Navigator.of(context).pop(); // Close loading indicator
      Navigator.of(context).pop(updatedCharacter); // Return updated character
    } catch (error) {
      Navigator.of(context).pop(); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update character: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Character Info'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            wrapWithPadding(
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
            wrapWithPadding(
              child: DropdownButtonFormField<Status>(
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
            ),
            wrapWithPadding(
              child: TextField(
                controller: speciesController,
                decoration: const InputDecoration(labelText: 'Species'),
              ),
            ),
            wrapWithPadding(
              child: TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel without returning anything
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _handleSave(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}