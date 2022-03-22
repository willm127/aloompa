import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/rapper_constants.dart';

import '../screens/list_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(RAPPER_DATA_BOX);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _theme = ThemeData(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      primarySwatch: Colors.blueGrey,
      iconTheme: const IconThemeData(color: Colors.blueGrey),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.black87, fontSize: 35),
        headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        labelMedium: TextStyle(color: Colors.black54, fontSize: 14),
        bodyMedium: TextStyle(fontSize: 18),
      ),
      brightness: Brightness.light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _theme,
      home: const ListScreen(),
      routes: const {
        // DetailsScreen.routeName: (ctx) => DetailsScreen(),
      },
    );
  }
}
