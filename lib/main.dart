import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'mainPage.dart';
import 'mainTestPage.dart';
import 'settingsPage.dart';
import 'provider/DifficultyProvider.dart';
import 'package:provider/provider.dart';
import 'provider/SentencesProvider.dart';
import 'provider/ScoreProvider.dart';
import 'provider/ColorThemeProvider.dart';
import 'provider/ParagraphProvider.dart';

List<String> listPoint = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DifficultyLevel()
        ),
        ChangeNotifierProvider(
          create: (context) => SentencesList()
        ),
        ChangeNotifierProvider(
          create: (context) => ScoreProvider()
        ),
        ChangeNotifierProvider(
          create: (context) => ColorTheme()
        ),
        ChangeNotifierProvider(
          create: (context) => Paragraph()
        ),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreen()
    );
  }
}