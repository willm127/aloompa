import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/rapper.dart';
import '../services/network.dart';
import '../widgets/search_bar.dart';
import '../widgets/rapper_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Rapper> rappers = [];
  List<Rapper> rappersFiltered = [];

  final TextEditingController controller = TextEditingController();
  bool _isLoading = true;
  bool _noData = false;

  void getRappers() async {
    final data = await Network().fetchRappers();
    rappers = data.toList();

    if (rappers.isEmpty) {
      rappers = await Network().fetchRappersFromCache();

      if (rappers.isEmpty) {
        // There was no data, even cached
        _noData = true;
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBuild(
            'No internet connection!\nPlease try again later...',
          ),
        );
      } else {
        // We at least have cached data
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBuild(
            'No internet connection!\nShowing cached data in the meantime.',
          ),
        );
      }
    }

    setState(() {
      rappersFiltered = [...rappers];
      _isLoading = false;
    });
  }

  void filterRapper(String value) {
    setState(() {
      rappersFiltered = rappers
          .where((element) => element.name.toLowerCase().contains(value))
          .toList();
    });
  }

  void clearSearch() {
    controller.clear();
    setState(() {
      rappersFiltered = [...rappers];
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    getRappers();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rappers'),
      ),
      body: _noData
          ? const Center(
              child: Text('Oops! No internet connection!'),
            )
          : Column(
              children: [
                SearchBar(filterRapper, clearSearch, controller),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : rappersFiltered.isEmpty
                          ? const Center(child: Text('No results found...'))
                          : ListView.builder(
                              itemCount: rappersFiltered.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return RapperCard(rappersFiltered[i]);
                              }),
                ),
              ],
            ),
    );
  }
}

SnackBar customSnackBuild(String text) {
  return SnackBar(
    content: Row(
      children: [
        const Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Icon(
            Icons.warning_amber,
            color: Colors.red,
          ),
        ),
        Flexible(
          flex: 4,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
