import 'package:flutter/material.dart';

class ScrollbarExample extends StatefulWidget {
  @override
  _ScrollbarExampleState createState() => _ScrollbarExampleState();
}

class _ScrollbarExampleState extends State<ScrollbarExample> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollbar Example'),
      ),
      body: Scrollbar(
        controller: _scrollController, // Attach the ScrollController
        thumbVisibility: true, // Optional for always showing the scrollbar
        child: ListView.builder(
          controller: _scrollController, // Attach the ScrollController to the ListView
          itemCount: 50,
          itemBuilder: (context, index) => ListTile(
            title: Text('Item $index'),
          ),
        ),
      ),
    );
  }
}