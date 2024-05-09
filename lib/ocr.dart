import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:nutrition_app/taskbar.dart';

class OCR extends StatefulWidget {
  const OCR({Key? key}) : super(key: key);

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  File? _image;
  String text = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _textRecognition(File img) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);
    setState(() {
      text = recognizedText.text;
    });
    print(text);

    // Save extracted text to Firestore
    _saveTextToFirestore(text);
  }

  Future<void> _saveTextToFirestore(String extractedText) async {
    try {
      // Get the current user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not logged in
        print('User not logged in.');
        return;
      }

      // Build the Firestore path using the user's UID
      final uid = user.uid;
      final collectionPath = 'patients/$uid/extracted text';

      // Reference the Firestore collection with the specified path
      final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(collectionPath);

      // Add the extracted text to Firestore
      await collectionReference.add({'text': extractedText});
      print('Text saved to Firestore under $collectionPath');
    } catch (e) {
      print('Error saving text to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                "Text Recognition",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF223D60),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey,
                child: Center(
                  child: _image == null
                      ? const Icon(Icons.add_a_photo, size: 60,)
                      : Image.file(_image!),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 50,
                color: const Color(0xFF223D60),
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera).then((value) {
                      if (_image != null) {
                        _textRecognition(_image!);
                      }
                    });
                  },

                  child: const Text("Pick up the photo from camera", style: TextStyle(color: Colors.white, fontSize: 23,),),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 50,
                color: const Color(0xFF223D60),
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery).then((value) {
                      if (_image != null) {
                        _textRecognition(_image!);
                      }
                    });
                  },
                  child: const Text("Pick up the photo from Gallery", style: TextStyle(color: Colors.white, fontSize: 23,),),
                ),
              ),
              const SizedBox(height: 20,),
              SelectableText(
                text,
                style: const TextStyle(fontSize: 18),
              ),
              // Add your widgets here
            ],
          ),
        ),
      ),
      bottomNavigationBar: taskbar(),
    );
  }
}
