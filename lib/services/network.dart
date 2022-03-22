import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../constants/rapper_constants.dart';

import '../models/rapper.dart';

class Network {
  final baseURL =
      'http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json';

  Future<List<Rapper>> fetchRappers() async {
    try {
      final response = await http.get(Uri.parse(baseURL));
      final rappers = Rapper.toList(response.body);

      // Update local data now that we were able to get data from the API
      Hive.box(RAPPER_DATA_BOX).put(RAPPER_DATA, response.body);
      Map<String, dynamic> cachedImages = {};

      // ...and now to cache the images
      for (var rapper in rappers) {
        final uriParsed = Uri.parse(rapper.image!);
        http.Response resp = await http.get(uriParsed);

        final bytes = base64Encode(resp.bodyBytes);
        cachedImages[rapper.id] = bytes;
      }

      // Images go in the same box, but under a different key
      Hive.box(RAPPER_DATA_BOX).put(RAPPER_IMAGES, cachedImages);

      return rappers;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<List<Rapper>> fetchRappersFromCache() async {
    try {
      // Try to get saved data from box, if any
      List<Rapper> storedData = [];
      final _boxExists = await Hive.boxExists(RAPPER_DATA_BOX);

      if (_boxExists) {
        if (Hive.box(RAPPER_DATA_BOX).isNotEmpty) {
          final boxData = await Hive.box(RAPPER_DATA_BOX).get(RAPPER_DATA);
          storedData = Rapper.toList(boxData);

          // Set a flag for the rapper_card to pick up
          for (var data in storedData) {
            data.image = null;
          }
        }
      }

      return storedData;
    } catch (e) {
      // print(e);
      return [];
    }
  }
}
