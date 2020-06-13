import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RSS Reader",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold()
    );
  }
}
