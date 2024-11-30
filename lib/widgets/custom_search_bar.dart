import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final String hintText;
  final String title;
  final Function(String) onSearch;
  final VoidCallback onCancel;
  final VoidCallback onStartSearch;

  const CustomSearchBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.hintText,
    required this.title,
    required this.onSearch,
    required this.onCancel,
    required this.onStartSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? TextField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle:
          TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        onChanged: onSearch,
        onSubmitted: (_) => FocusScope.of(context).unfocus(), // Hide keyboard
      )
          : Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      actions: isSearching
          ? [
        IconButton(
          icon: Icon(Icons.close,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: onCancel,
        ),
      ]
          : [
        IconButton(
          icon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: onStartSearch,
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}