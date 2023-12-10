import 'package:flutter/material.dart';
import 'LoginPage.dart';


class ThirdScreen extends StatefulWidget {

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final bool isLoggedin = true;

  final String username = 'name';

  final String email = 'abc@gmail.com';

  int _selectedSize = 15;

  String selectedOption = ''; 

  List<Map<String, Color>> colorPairs = [
    {'background': Color(0xFFFFFFFF), 'text': Color(0xFF000000)},
    {'background': Color(0xFFDDDDDD), 'text': Color(0xFF000000)},
    {'background': Color(0xFFDDDDFF), 'text': Color(0xFF000000)},
    {'background': Color(0xFFDDFFDD), 'text': Color(0xFF000000)},
    {'background': Color(0xFF000000), 'text': Color(0xFFFFFFFF)},
    {'background': Color(0xFF00FF00), 'text': Color(0xFFFFFFFF)},
    {'background': Color(0xFF0000FF), 'text': Color(0xFFFFFFFF)},
    {'background': Color(0xFFFF0000), 'text': Color(0xFFFFFFFF)},
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget _loggedInContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10), // Adjust the height for desired spacing
          Text(email),
        ],
      );
    }

    void _updateSize(int newSize) {
      setState(() {
        _selectedSize = newSize;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          ListTile(
            leading: Container(
              width: 60.0, // CircleAvatar의 폭
              height: 60.0, // CircleAvatar의 높이
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person, size: 40.0), // 기본 유저 아이콘
              ),
            ),
            title: isLoggedin ? _loggedInContent() : Text('Login'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.5), // Top border
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.5), // Bottom border
              ),
              color: Colors.grey.withOpacity(0.1)
            ),
            child: ListTile(
              title: Text(
                'Text Options',
                style: TextStyle(
                  fontSize: 20.0,
                )
                ),
          
            ),
          ),
          ListTile(
            title: Text('Select Text Size'),
            trailing: Text('${_selectedSize}px'),
            onTap: () async {
              final selectedSize = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectionScreen(currentSize: _selectedSize),
                ),
              );
              if (selectedSize != null) {
                _updateSize(selectedSize);
              }
            },
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Background Setting'),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: colorPairs[selectedIndex]['background'],
                        ),
                        child: Center(
                          child: Text(
                            'Test Word',
                            style: TextStyle(color: colorPairs[selectedIndex]['text']),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: colorPairs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: colorPairs[index]['background'],
                              ),
                              child: Center(
                                child: Text(
                                  selectedIndex == index ? 'A' : '',
                                  style: TextStyle(color: colorPairs[index]['text']),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // _settingsOption(context, 'Text Color', TextColorPage()),
          // _settingsOption(context, 'Background Color', BackgroundColorPage()),
          // _settingsOption(context, 'Sentence Mode', SentenceModePage()),

        ],
      ),
    );

  }


  Widget _settingsOption(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

class TextColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Color Settings'),
      ),
      body: Center(
        child: Text('Text Color Settings Page Content'),
      ),
    );
  }
}

class BackgroundColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Color Settings'),
      ),
      body: Center(
        child: Text('Background Color Settings Page Content'),
      ),
    );
  }
}

class SentenceModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Mode Settings'),
      ),
      body: Center(
        child: Text('Sentence Mode Settings Page Content'),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  final int currentSize;

  SelectionScreen({required this.currentSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Size')),
      body: ListView(
        children: [12, 15, 20].map((size) {
          return ListTile(
            title: Text('Size $size'),
            leading: Radio<int>(
              value: size,
              groupValue: currentSize,
              onChanged: (int? value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              },
            ),
            onTap: () {
              Navigator.pop(context, size);
            },
          );
        }).toList(),
      ),
    );
  }
}