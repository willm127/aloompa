import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function filterRappers;
  final Function clearSearch;
  final TextEditingController controller;

  const SearchBar(this.filterRappers, this.clearSearch, this.controller,
      {Key? key})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextField(
        onChanged: (value) => widget.filterRappers(value),
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            splashColor: Colors.transparent,
            onPressed: () => widget.clearSearch(),
            icon: const Icon(Icons.clear),
          ),
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}
