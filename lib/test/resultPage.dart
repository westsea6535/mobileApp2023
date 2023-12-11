import 'package:flutter/material.dart';
import '../mainPage.dart';

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

              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => MainScreen(),
              // // ));

            }, 
            child: Text('to home'),
          ),
        ),
      ),
    );
  }
}
