import 'package:flutter/material.dart';

class ParagraphPage extends StatelessWidget {
  final String paragraph;

  ParagraphPage({required this.paragraph});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paragraph Page')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                paragraph,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add your first button action here
                },
                child: Text('Sentence'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your second button action here
                },
                child: Text('Test'),
              ),
            ],
          ),
          SizedBox(height: 10), // For padding at the bottom
        ],
      ),
    );
  }
}
