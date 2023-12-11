import 'package:flutter/material.dart';
import 'dart:math';

// 문단 페이지: 사용자가 숫자를 입력하고 빈칸을 만들 페이지
class ParagraphPage extends StatelessWidget {
  final String paragraph;

  ParagraphPage({required this.paragraph});

  // 숫자 입력 대화상자를 표시하는 함수
  void _showTestDialog(BuildContext context) {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int numValue = 0;
        return AlertDialog(
          title: Text('Enter a number'),
          content: TextField(
            onChanged: (value) {
              numValue = int.tryParse(value) ?? 0;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter a number"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(numValue);
              },
            ),
          ],
        );
      },
    ).then((numWords) {
      if (numWords != null) {
        _processTextAndNavigate(context, numWords);
      }
    });
  }

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
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Sentence 버튼 기능 (추가 예정)
                },
                child: Text('Sentence'),
              ),
              ElevatedButton(
                onPressed: () => _showTestDialog(context),
                child: Text('Test'),
              ),
            ],
          ),
          SizedBox(height: 10), // 하단 여백
        ],
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