import 'package:flutter/material.dart';
import '../mainPage.dart';
import 'package:provider/provider.dart';
import '../provider/ScoreProvider.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recentResult = Provider.of<ScoreProvider>(context).myScore;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Result'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'Your Score: ${recentResult['correct']}/${recentResult['total']}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )
              ), 
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }, 
                child: Text('to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
