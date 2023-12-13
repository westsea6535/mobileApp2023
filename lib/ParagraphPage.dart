import 'package:flutter/material.dart';
import 'dart:math';
import 'SentencesPage.dart';
import 'provider/DifficultyProvider.dart';
import 'package:provider/provider.dart';
import 'test/testPage.dart';
import '../provider/ScoreProvider.dart';
import '../provider/ColorThemeProvider.dart';
import '../provider/ParagraphProvider.dart';

// 문단 페이지: 사용자가 숫자를 입력하고 빈칸을 만들 페이지
class ParagraphPage extends StatelessWidget {
  final String paragraph;
  final List<String> sentences;


  ParagraphPage({required this.paragraph, required this.sentences});



  List<Map<String, Color>> colorPairs = [
    {'background': Color(0xFFFFFFFF), 'text': Color(0xFF000000), 'border': Color(0xFFDDDDDD)},
    {'background': Color(0xFF000000), 'text': Color(0xFFFFFFFF), 'border': Color(0xFF4C4C4C)},
    {'background': Color(0xFF44615F), 'text': Color(0xFFFFFFFF), 'border': Color(0xFF38504E)},
    {'background': Color(0xFFE4E6F2), 'text': Color(0xFF000000), 'border': Color(0xFFD8DAE6)},
    {'background': Color(0xFFDDEAD6), 'text': Color(0xFF000000), 'border': Color(0xFFCADCC1)},
    {'background': Color(0xFFD1D1D1), 'text': Color(0xFF000000), 'border': Color(0xFFCCCCCC)},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTheme = Provider.of<ColorTheme>(context).selectedTheme;
    final savedParagraph = Provider.of<Paragraph>(context).paragraph;

    Widget _dialogButton(BuildContext context, String level) {
      return ElevatedButton(
        onPressed: () {

          Provider.of<ScoreProvider>(context, listen: false).updateMap({'total': 0, 'correct': 0});
          Provider.of<DifficultyLevel>(context, listen: false).setLevel(level);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TestPage(sentenceNum: 0,),
          ));
        },
        child: Text(level),
      );
    }

    void _showDifficultyDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Difficulty"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _dialogButton(context, "Easy"),
                  _dialogButton(context, "Intermediate"),
                  _dialogButton(context, "Hard"),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Full Paragraph')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorPairs[selectedTheme]['border']!,
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)), // Optional: Border radius
                  color : colorPairs[selectedTheme]['background'],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    savedParagraph,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: colorPairs[selectedTheme]['text'],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            // Change your radius here
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      onPressed: () {
                        print(paragraph);
                        print(sentences[0]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SentencesPage(sentences: sentences),
                          ),
                        );
                      },
                      child: Text('Sentence'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            // Change your radius here
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _showDifficultyDialog(context);
                      },
                      child: Text('Test'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // 하단 여백
          ],
        ),
      ),
    );
  }
}
