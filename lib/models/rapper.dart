import 'dart:convert';

class Rapper {
  String id;
  String name;
  String? image;
  String description;

  Rapper(
    this.id,
    this.name,
    this.image,
    this.description,
  );

  static List<Rapper> toList(String json) {
    final List<Rapper> rappers = [];

    final data = jsonDecode(json);

    data['artists'].forEach((r) {
      rappers.add(Rapper(
        r['id'],
        r['name'],
        r['image'],
        r['description'],
      ));
    });

    // Sort alphabetically
    rappers.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return rappers;
  }
}
