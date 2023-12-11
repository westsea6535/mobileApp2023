import 'package:flutter/material.dart';
import '../mainPage.dart';
import 'package:provider/provider.dart';
import '../provider/ScoreProvider.dart';

class ResultPage extends StatelessWidget {
  bool alwaysTruePredicate(Route<dynamic> route) => true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Button Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }, 
            child: Text('to home'),
          ),
        ),
      ),
    );
  }
}
