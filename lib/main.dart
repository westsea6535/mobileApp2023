import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OCR Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OCRScreen(),
    );
  }
}

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  String _extractedText = '';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter OCR Demo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _extractedText.isNotEmpty ? _extractedText : 'Press the button to start OCR',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  //// 사진 가져오기, 화면 크롭 관련 부분 ////
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

  //// Google ML Kit ////
  // void recognizeText(String imagePath) async {
  //   final textRecognizer = GoogleMlKit.vision.textRecognizer();
  //   final inputImage = InputImage.fromFilePath(imagePath);
  //   final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  //
  //   String correctedText = correctLineBreaks(recognizedText.text);
  //
  //   setState(() {
  //     _extractedText = correctedText;
  //   });
  //
  //   textRecognizer.close();
  // }
  

  //// Tesseract Ocr ////
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
      });
    } catch (e) {
      print("Tesseract OCR Error: $e");
    }
  }

  
  // 원본 지문에서 줄바꿈이 있으면 이상하게 나오는데 그걸 다듬는 함수
  // 궁금하면 주석처리해서 테스트 가능 
  String correctLineBreaks(String text) {
    var correctedText = text.replaceAllMapped(
      RegExp(r'(\w)\n(\w)'),
          (match) {
        return '${match.group(1)}${match.group(2)}';
      },
    );
    return correctedText;
  }
}
