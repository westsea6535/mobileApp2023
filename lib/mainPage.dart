import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'ParagraphPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'provider/SentencesProvider.dart';
import 'package:provider/provider.dart';
import 'settingsPage.dart';
import 'provider/ScoreProvider.dart';

class MainScreen extends StatefulWidget {

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<MainScreen> {

  String exampleText = "An important advantage of disclosure, as apposed to more aggressive forms of regulation, it its flexibility and respect for the operation of free markets. Regulatory mandates are blunt words; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for applicances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed tof the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.";

  List<String> paragraphList = [
    "An important advantage of disclosure, as apposed to more aggressive forms of regulation, it its flexibility and respect for the operation of free markets. Regulatory mandates are blunt words; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for applicances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed tof the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.",
  ];

  // Use the pattern to split the paragraph into sentences
  List<String> sentences = [];

  String _extractedText = '';


  final ImagePicker _picker = ImagePicker();

  static String? savedOCRText;

  @override
  void initState() {
    super.initState();
    RegExp re = new RegExp(r"(\w|\s|,|')+[。.?!]*\s*");

    if (sentences.isEmpty) {
      Future.microtask(() {
        List<RegExpMatch> regProcess = re.allMatches(exampleText).toList();
        sentences = regProcess
          .map((match) => match.group(0)) // Map to String?
          .where((str) => str != null)     // Filter out null values
          .map((str) => str!)              // Convert to non-nullable String
          .toList();

        final sentencesList = Provider.of<SentencesList>(context, listen: false);
        sentencesList.setList(sentences);
      });
    }

    // 초기화 로직에 OCR 결과가 저장된 변수를 사용하여 exampleText 초기화
    if (savedOCRText != null) {
      Future.microtask(() {
        exampleText = savedOCRText!;
        List<RegExpMatch> regProcess = re.allMatches(savedOCRText!).toList();
        sentences = regProcess
          .map((match) => match.group(0)) // Map to String?
          .where((str) => str != null)     // Filter out null values
          .map((str) => str!)              // Convert to non-nullable String
          .toList();

        print(exampleText);
        final sentencesList = Provider.of<SentencesList>(context, listen: false);
        sentencesList.setList(sentences);
      });
    } 
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        recognizeText(croppedFile.path);
      }
    }
  }

  List<String> ocrResults = [];


  void recognizeText(String imagePath) async {
    try {
      final String rawText = await FlutterTesseractOcr.extractText(
          imagePath,
          language: 'eng', // 영어만 사용 설정
          args: {
            "psm": "4", // 페이지 세그먼트 모드
            "preserve_interword_spaces": "1" // 단어 간 공백 유지
          }
      );
      final String correctedText = correctLineBreaks(rawText);
      setState(() {
        _extractedText = correctedText;
        exampleText = correctedText; // OCR 결과로 업데이트
        savedOCRText = correctedText;

        paragraphList.add(correctedText);

        RegExp re = new RegExp(r"(\w|\s|,|')+[。.?!]*\s*");

        List<RegExpMatch> regProcess = re.allMatches(savedOCRText!).toList();
        sentences = regProcess
          .map((match) => match.group(0)) // Map to String?
          .where((str) => str != null)     // Filter out null values
          .map((str) => str!)              // Convert to non-nullable String
          .toList();

        print(exampleText);
        final sentencesList = Provider.of<SentencesList>(context, listen: false);
        sentencesList.setList(sentences);
      });
    } catch (e) {
      print("Tesseract OCR Error: $e");
    }
  }

  String correctLineBreaks(String text) {
    var correctedText = text.replaceAllMapped(
      RegExp(r'(\w)\n(\w)'),
          (match) {
        return '${match.group(1)}${match.group(2)}';
      },
    );
    return correctedText;
  }


  @override
  Widget build(BuildContext context) {

    final recentResult = Provider.of<ScoreProvider>(context).myScore;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThirdScreen()
                ),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 5),
            InkWell (
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParagraphPage(
                      paragraph: exampleText,
                      sentences: sentences,
                    ),
                  ),
                );
              },
              child: Container(
                width: 350.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 5.0
                    )
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    const SizedBox(height: 5),
                    Text(
                      'Recent Paragraph',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF7888FF),
                        fontWeight: FontWeight.w900,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 190,
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            // Calculate the number of lines for the current constraints and font size
                            final double fontSize = 15;
                            final double lineHeight = fontSize * 1.2; // Assuming a typical line height
                            final int maxLines = (constraints.maxHeight / lineHeight).floor() - (fontSize > 14 ? 1 : 2);

                            return Text(
                              exampleText,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black,
                              ),
                              maxLines: maxLines,
                            );
                          },
                        ),
                      )
                    )
                  ],
                )
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 350.0,
              height: 100.0,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5.0)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Recent Test Result',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )
                      ),
                      Text(
                        '${recentResult['total'] == 0 ? 0 : ((recentResult['correct']?.toDouble() ?? 0) / (recentResult['total']?.toDouble() ?? 1) * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7888FF),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: SimpleAnimationProgressBar(
                      height: 8,
                      width: 300,
                      backgroundColor: const Color(0x447888FF),
                      foregrondColor: const Color(0xFF7888FF),
                      ratio: recentResult['total'] == 0 ? 0 : ((recentResult['correct']?.toDouble() ?? 0) / (recentResult['total']?.toDouble() ?? 1)),
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ]
              )
            ),
            SizedBox(height:20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 10.0)
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Paragraph List',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF7888FF),
                          fontWeight: FontWeight.w900,
                        )
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: paragraphList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  width: 350.0,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          child: Text(
                                            paragraphList[index], // Replacing exampleText with the actual list element
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                            maxLines: 2,
                                          ),
                                        )
                                      )
                                    ],
                                  )
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ),
            )
          ]
        ),
      ),
      floatingActionButton: PopupMenuTheme(
        data: PopupMenuThemeData(
          // Customize your popup menu theme here
          color: Colors.white, // Example: change the background color
          textStyle: TextStyle(color: Colors.white), // Example: change text color
        ),
        child: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: Color(0xFF7888FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              pickImage();
            },
            child: Icon(Icons.add, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}

