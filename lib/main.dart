import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:themoviedb/Screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: HomeScreen(),
        theme: ThemeData(brightness: Brightness.dark),
      ),
    );
  }
}
