import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/rapper.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  final Rapper rapper;
  final Uint8List? bytes;

  const DetailsScreen(this.rapper, {this.bytes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> allText = rapper.description.split(' ');
    final first = allText[0];
    allText.removeAt(0);

    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(title: Text(rapper.name)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: rapper.id,
                  child: rapper.image == null
                      ? Image.memory(bytes!)
                      : Image.network(rapper.image!),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.bounceIn,
                    padding: const EdgeInsets.all(10),
                    color: Colors.black54,
                    child: Text(
                      rapper.name,
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: first + ' ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...allText.map((e) => TextSpan(text: e + ' ')).toList()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
