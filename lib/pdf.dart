import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:nutrition_app/taskbar.dart';

class AddPlus extends StatefulWidget {
  const AddPlus({Key? key}) : super(key: key);

  @override
  _AddPlusState createState() => _AddPlusState();
}

class _AddPlusState extends State<AddPlus> {
  File? _image;
  String imageUrl = '';
  final picker = ImagePicker();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Upload papers for Medications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(0xFF223D60),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await _getImage();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _image == null
                        ? Center(
                      child: const Icon(
                        Icons.add_circle_sharp,
                        color: Colors.black,
                        size: 150,
                      ),
                    )
                        : Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 10),
                    child: Text(
                      "Add the Medical Photo ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF223D60),
                          fontSize: 20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      "For History ",
                      style: TextStyle(

                          color: Color(0xFF223D60),
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: TextField(
                controller: productDescriptionController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter a description',
                  prefixIcon: Icon(Icons.description),
                  labelText: ' Enter the details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF223D60),
                shape: StadiumBorder(),
              ),
              onPressed: () {
                if (_image != null) {
                  uploadImageAndDescriptionToFirebase();
                } else {
                  print('Image is null. Handle this case accordingly.');
                }
              },
              child: const Text('Upload Image', style: TextStyle(fontSize: 20, color: Colors.white),),
            ),
          ],
        ),
      ),
      bottomNavigationBar: taskbar(),
    );
  }

  Future<void> _getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImageAndDescriptionToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var imageName = basename(_image!.path);
        var refStorage = FirebaseStorage.instance.ref(imageName);
        await refStorage.putFile(_image!);
        imageUrl = await refStorage.getDownloadURL();
        print('Image URL: $imageUrl');

        final uid = user.uid;
        final pdfCollection = FirebaseFirestore.instance.collection('patients').doc(uid).collection('pdf files');
        await pdfCollection.add({
          'image_url': imageUrl,
          'description': productDescriptionController.text,
        });

        print('Image and description added to Firestore successfully!');
        setState(() {});
      } else {
        print('User is null. Not signed in?');
      }
    } catch (e) {
      print('Error uploading image and description to Firebase: $e');
    }
  }
}
