import 'package:flutter/material.dart';
import '../mainPage.dart';

class ResultPage extends StatelessWidget {
  bool alwaysTruPredicate(Route<dynamic> route) => true;
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MainScreen(),
              ));

              print('Button Pressed!');
            },
            child: Text('to home'),
          ),
        ),
      ),
    );
  }
}
