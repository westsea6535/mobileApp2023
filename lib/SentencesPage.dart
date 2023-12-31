import 'package:flutter/material.dart';
import 'provider/SentencesProvider.dart';
import 'package:provider/provider.dart';
import 'provider/ColorThemeProvider.dart';
import 'provider/ParagraphProvider.dart';

class SentencesPage extends StatefulWidget {
  final List<String> sentences;

  SentencesPage({required this.sentences});

  @override
  State<SentencesPage> createState() => _SentencesPageState();
}


class _SentencesPageState extends State<SentencesPage> {
  void _showSentenceDialog(int index) {
    String sentence = widget.sentences[index];
    TextEditingController _controller = TextEditingController(text: sentence);
    bool isEditMode = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: isEditMode
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    minLines: 3,
                    maxLines: null,
                  )
                : Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 3.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(sentence),
                    )
                  ),
              actions: <Widget>[
                if (!isEditMode)
                  ElevatedButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                if (isEditMode)
                  ElevatedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      setDialogState(() {
                        isEditMode = false;
                        _controller.text = sentence; // Reset changes
                      });
                    },
                  ),
                ElevatedButton(
                  child: Text(isEditMode ? "Apply" : "Modify"),
                  onPressed: () {
                    if (isEditMode) {
                      setState(() {
                        widget.sentences[index] = _controller.text;

                        final sentencesList = Provider.of<SentencesList>(context, listen: false);

                        sentencesList.setList(widget.sentences);

                        String joinedSentence = widget.sentences.join(' ');
                        Provider.of<Paragraph>(context, listen: false).setParagraph(joinedSentence);
                      });
                      Navigator.of(context).pop();
                    } else {
                      setDialogState(() {
                        isEditMode = true;
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      barrierDismissible: true,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sentences"),
      ),
      body: ListView.separated(
        itemCount: widget.sentences.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          String item = widget.sentences[index];
          return ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            title: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 60,
                    ),
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Align(alignment:Alignment.center, child: Text('${index + 1}')),
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 60.0, // Set your desired minimum height here
                      ),
                      decoration: BoxDecoration(
                        color: colorPairs[selectedTheme]['background'],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          item,
                          softWrap: true,
                          style: TextStyle(
                            color: colorPairs[selectedTheme]['text'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _showSentenceDialog(index),
          );
        },
      ),
    );
  }
}
