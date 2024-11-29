import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({Key? key, required this.character})
      : super(key: key);

  void _showEditDialog(BuildContext context, Character character) {
    final nameController = TextEditingController(text: character.name);
    final statusController = TextEditingController(text: character.status);
    final speciesController = TextEditingController(text: character.species);
    final genderController = TextEditingController(text: character.gender);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit Character'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                ),
                TextField(
                  controller: speciesController,
                  decoration: InputDecoration(labelText: 'Species'),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedCharacter = Character(
                  id: character.id,
                  name: nameController.text,
                  status: statusController.text,
                  species: speciesController.text,
                  gender: genderController.text,
                  type: character.type,
                  image: character.image,
                );

                Provider.of<CharacterProvider>(context, listen: false)
                    .updateCharacter(updatedCharacter);
                Navigator.of(ctx).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int characterId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Delete Character'),
          content: Text('Are you sure you want to delete this character?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<CharacterProvider>(context, listen: false)
                    .deleteCharacter(characterId);
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider =
        Provider.of<CharacterProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              characterProvider.favorites.contains(character)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              characterProvider.toggleFavorite(character);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditDialog(context, character),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, character.id),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character Image
            Stack(
              children: [
                Hero(
                  tag: character.id,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(24)),
                      image: DecorationImage(
                        image: NetworkImage(character.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      character.name,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ],
            ),

            // Character Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailItem(label: 'Status', value: character.status),
                  DetailItem(label: 'Species', value: character.species),
                  DetailItem(label: 'Gender', value: character.gender),
                  if (character.type.isNotEmpty)
                    DetailItem(label: 'Type', value: character.type),
                  const SizedBox(height: 16),
                  Text(
                    'Origin',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // Text(
                  //   character.origin['name'],
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  // ),
                  const SizedBox(height: 16),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // Text(
                  //   character.location['name'],
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for Reusable Detail Rows
class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
