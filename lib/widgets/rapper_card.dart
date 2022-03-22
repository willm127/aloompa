import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rappers/screens/details_screen.dart';

import '../constants/rapper_constants.dart';

import '../models/rapper.dart';

class RapperCard extends StatefulWidget {
  final Rapper rapper;

  const RapperCard(this.rapper, {Key? key}) : super(key: key);

  @override
  State<RapperCard> createState() => _RapperCardState();
}

class _RapperCardState extends State<RapperCard> {
  late Rapper _rapper;
  Uint8List? bytes;
  late TextTheme _textTheme;

  final _padding = 10.0;
  var _favoritesCount = Random().nextInt(1000) + 500;
  bool _isFavorite = false;

  void _setFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _isFavorite ? _favoritesCount++ : _favoritesCount--;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _rapper = widget.rapper;
    _textTheme = Theme.of(context).textTheme;

    if (_rapper.image == null) {
      // We're offline! Better get the cached image
      var cacheImagesMap = Hive.box(RAPPER_DATA_BOX).get(RAPPER_IMAGES);
      bytes = base64Decode(cacheImagesMap[_rapper.id]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext ctx) => DetailsScreen(
              _rapper,
              bytes: bytes,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _padding,
          vertical: _padding * .5,
        ),
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color.fromARGB(50, 200, 200, 200)),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(_padding * 1.5),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: _rapper.id,
                      child: FadeInImage(
                        fadeInCurve: Curves.easeInQuad,
                        fadeInDuration: Duration(seconds: 1),
                        fit: BoxFit.cover,
                        placeholder: const AssetImage('assets/thumb.png'),
                        image: _rapper.image != null
                            ? NetworkImage(_rapper.image!) as ImageProvider
                            : MemoryImage(bytes!) as ImageProvider,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.only(left: _padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _rapper.name,
                          style: _textTheme.headlineSmall,
                        ),
                        Text(
                          'Favorites: $_favoritesCount',
                          style: _textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: IconButton(
                    icon: _isFavorite
                        ? const Icon(Icons.star)
                        : const Icon(Icons.star_border),
                    onPressed: _setFavorite,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
