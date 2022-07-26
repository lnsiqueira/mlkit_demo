import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Google ML'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hasImage = false;
  File? image;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  String? imagePath;
  String scanText = '';

  bool imageLabelChecking = false;

  XFile? imageFile;

  String imageLabel = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          setState(() {
            scanText = '$scanText  ${element.text}';
            debugPrint(scanText);
          });
        }
        scanText = '$scanText\n';
        imageLabelChecking = false;
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    imageLabelChecking = true;

    setState(() {
      scanText = "";
    });

    getText(imageFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imageFile != null)
              Image.file(
                File(imageFile!.path),
                width: 240.0,
                height: 240.0,
                fit: BoxFit.fill,
              ),
            if (imageLabelChecking)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                scanText,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _pickImage(context),
        tooltip: 'Image',
        child: const Icon(Icons.image_rounded),
      ),
    );
  }
}
