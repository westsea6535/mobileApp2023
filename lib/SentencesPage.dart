import 'package:flutter/material.dart';

class SentencesPage extends StatelessWidget {
  final List<String> sentences;

  SentencesPage({required this.sentences});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("sentences"),
      ),
      body: ListView.separated(
        itemCount: sentences.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          // 각 항목을 만들고 반환합니다.
          String item = sentences[index];
          return ListTile(
            title: Row(
              children: [
                Container(
                  width: 50.0, // 크기를 50으로 고정
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Text('${index + 1}'),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      item,
                      softWrap: true, // 줄 바꿈 허용
                    ),
                  ),
                ),
              ],
            ),
            // 여기에 각 항목에 대한 추가 구성 요소를 추가할 수 있습니다.
          );
        },
      )

    );
  }
}

