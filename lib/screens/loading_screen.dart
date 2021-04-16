import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = 'loading_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}