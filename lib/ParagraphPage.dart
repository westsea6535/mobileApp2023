import 'package:flutter/material.dart';
import 'dart:math';
import 'SentencesPage.dart';
import 'provider/DifficultyProvider.dart';
import 'package:provider/provider.dart';
import 'test/testPage.dart';
import '../provider/ScoreProvider.dart';
import '../provider/ColorThemeProvider.dart';

// 문단 페이지: 사용자가 숫자를 입력하고 빈칸을 만들 페이지
class ParagraphPage extends StatelessWidget {
  final String paragraph;
  final List<String> sentences;


  ParagraphPage({required this.paragraph, required this.sentences});


  // 빈칸으로 만들 단어의 수에 따라 새 문단을 만들고, TextDisplayPage로 이동하는 함수
  void _processTextAndNavigate(BuildContext context, int numWords) {
    List<String> words = paragraph.split(' ');
    Map<int, String> blanks = {};
    Set<int> usedIndexes = {};

    while (blanks.length < numWords) {
      int randomIndex = Random().nextInt(words.length);
      if (!usedIndexes.contains(randomIndex)) {
        usedIndexes.add(randomIndex);
        blanks[randomIndex] = words[randomIndex];
        words[randomIndex] = '_' * words[randomIndex].length;
      }
    }

    String newParagraph = words.join(' ');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TextDisplayPage(paragraph: newParagraph, blanks: blanks),
      ),
    );
  }

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
                    paragraph,
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

// 텍스트 디스플레이 페이지: 빈칸이 포함된 문단을 표시하고 사용자의 입력을 받는 페이지
class TextDisplayPage extends StatefulWidget {
  final String paragraph;
  final Map<int, String> blanks;

  TextDisplayPage({required this.paragraph, required this.blanks});

  @override
  _TextDisplayPageState createState() => _TextDisplayPageState();
}

class _TextDisplayPageState extends State<TextDisplayPage> {
  late List<String> words;
  Map<int, TextEditingController> controllers = {};
  late List<bool> blanks; // 빈칸 여부를 저장할 리스트

  @override
  void initState() {
    super.initState();
    words = widget.paragraph.split(' ');
    blanks = List.generate(words.length, (index) => false);
    widget.blanks.forEach((index, _) {
      controllers[index] = TextEditingController();
      blanks[index] = true; // 빈칸 위치를 true로 설정
    });
  }

  void checkAnswers() {
    int correctCount = 0;
    widget.blanks.forEach((index, correctWord) {
      // Null 검사를 추가합니다.
      String userAnswer = controllers[index]?.text.trim() ?? '';
      if (userAnswer == correctWord) {
        correctCount++;
      }
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(correctCount: correctCount, totalBlanks: widget.blanks.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = []; // Use a list of widgets instead of spans

    for (int i = 0; i < words.length; i++) {
      if (blanks[i]) {
        // For blanks, create a TextField
        children.add(SizedBox(
          width: words[i].length * 10.0, // Adjust width according to the word length
          child: TextField(
            controller: controllers[i],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: '_' * words[i].length,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        // For regular text, create a Text widget
        children.add(Text(words[i] + ' ', style: TextStyle(fontSize: 20.0)));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Fill in the Blanks')),
      body: SingleChildScrollView( // Use SingleChildScrollView to make the content scrollable
        padding: EdgeInsets.all(16),
        child: Wrap( // Use Wrap to keep the text flow
          children: children,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkAnswers,
        child: Icon(Icons.check),
      ),
    );
  }
}

// 결과 페이지: 사용자가 맞힌 단어의 수와 전체 빈칸의 수를 표시하는 페이지
class ResultPage extends StatelessWidget {
  final int correctCount;
  final int totalBlanks;

  ResultPage({required this.correctCount, required this.totalBlanks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You got $correctCount out of $totalBlanks correct!', style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}