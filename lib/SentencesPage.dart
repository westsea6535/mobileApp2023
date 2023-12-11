import 'package:flutter/material.dart';
import 'provider/SentencesProvider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
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
            title: Row(
              children: [
                Container(
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Text('${index + 1}'),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      item,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => _showSentenceDialog(index),
          );
        },
      ),
    );
  }
}
