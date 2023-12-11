import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'ParagraphPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'provider/SentencesProvider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<MainScreen> {


  double progressRatio = 0.4;
  Map<String, int> recentResult = {
    'correctCount': 12,
    'totalCount': 16,
  };

  String exampleText = "An important advantage of disclosure, as apposed to more aggressive forms of regulation, it its flexibility and respect for the operation of free markets. Regulatory mandates are blunt words; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for applicances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed tof the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.";


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

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                    Text(
                      '최근 지문',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF7888FF),
                        fontWeight: FontWeight.w900,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        exampleText,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )
                      ),
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
                        '${(recentResult['correctCount']?.toDouble() ?? 0) / (recentResult['totalCount']?.toDouble() ?? 1) * 100}%',
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
                      ratio: (recentResult['correctCount']?.toDouble() ?? 0) / (recentResult['totalCount']?.toDouble() ?? 1),
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ]
              )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('시험 결과')
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('재시험')
                    ),
                  )
                ],
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
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 130.0,
                  MediaQuery.of(context).size.height - 250.0,
                  MediaQuery.of(context).size.width - 30.0,
                  0.0,
                ),
                items: [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Color(0xFF7888FF),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          width: 100.0,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Text(
                                '촬영하기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF7888FF),
                                )
                              ),
                              Text(
                                '원하는 문장을 촬영',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xaa000000),
                                )
                              )
                            ]
                          )
                        ) ,
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0x55000000),
                        ),
                      ]
                    ),
                    value: 'item1',
                    onTap: () {
                      pickImage(); // OCR 기능 실행
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        const Icon(
                          Icons.text_fields,
                          size: 30,
                          color: Color(0xFF7888FF),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          width: 100.0,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Text(
                                '입력하기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF7888FF),
                                )
                              ),
                              Text(
                                '텍스트로 직접 입력',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0x55000000),
                                )
                              )
                            ]
                          )
                        ) ,
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0x55000000),
                        ),
                      ]
                    ),
                    value: 'item2',
                  ),
                  // Add more menu items as needed
                ],
              );
            },
            child: Icon(Icons.menu, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}

