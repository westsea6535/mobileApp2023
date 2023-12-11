import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'resultPage.dart';
import '../provider/DifficultyProvider.dart';
import '../provider/SentencesProvider.dart';

class TestPage extends StatefulWidget {
  final int sentenceNum;
  const TestPage({required this.sentenceNum});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController textFieldController1 = TextEditingController();
  List<TextEditingController> textControllers = [];

  @override
  void dispose() {
    // Dispose of all the controllers when the state is disposed
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = Provider.of<DifficultyLevel>(context).level;
    final sentences = Provider.of<SentencesList>(context).items;
    final sentence = sentences[widget.sentenceNum];

    double blankPercentage;
    switch (level) {
      case "Easy":
        blankPercentage = 0.2;
        break;
      case "Intermediate":
        blankPercentage = 0.5;
        break;
      case "Hard":
        blankPercentage = 0.8;
        break;
      default:
        blankPercentage = 0.2;
    }

    List<InlineSpan> spans = _generateSpansForSentence(sentence, blankPercentage);

    return Scaffold(
      appBar: AppBar(
        title: Text("Selected Difficulty: $level"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(children: spans),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => sentences.length - 1 == widget.sentenceNum ? ResultPage() : TestPage(sentenceNum: widget.sentenceNum + 1,),
                            // builder: (context) => TestPage(sentenceNum: widget.sentenceNum + 1,),
                          ));
                        },
                        child: const Text(
                          'Next'
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _generateSpansForSentence(String sentence, double blankPercentage) {
    Random random = Random();
    List<String> words = sentence.split(' ');
    int numBlanks = (words.length * blankPercentage).round();
    Set<int> blankIndices = {};

    while (blankIndices.length < numBlanks) {
      int randomIndex = random.nextInt(words.length);
      blankIndices.add(randomIndex);
    }
    textControllers = List.generate(numBlanks, (_) => TextEditingController());

    int blankIndex = 0;
    return List<InlineSpan>.generate(words.length, (index) {
      if (blankIndices.contains(index)) {
        double wordWidth = _calculateTextWidth(words[index]);

        return WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              child: SizedBox(
                width: wordWidth,
                child: EditableText(
                  controller: textControllers[blankIndex++],
                  focusNode: FocusNode(),
                  readOnly: false,
                  cursorColor: Colors.blue,
                  backgroundCursorColor: Colors.blue,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      } else {
        return TextSpan(text: words[index] + ' ');
      }
    });
  }

  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 16)), // Adjust the style to match your TextField's style
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

}