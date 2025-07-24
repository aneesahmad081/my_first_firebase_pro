import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_firebase_pro/UI/util/toast_utils.dart';
import 'package:my_first_firebase_pro/UI/widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool lodaing = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Upload Image Firstore'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                  ),
                  height: 300,
                  width: 300,
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Center(child: Icon(Icons.image_outlined)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: 'Upload',
              loading: lodaing,
              onTap: () async {
                if (_image == null) {
                  ToastUtils.show('Please select an image');
                  return;
                }

                setState(() {
                  lodaing = true;
                });

                try {
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage
                      .instance
                      .ref(
                        '/flodername/' +
                            DateTime.now().millisecondsSinceEpoch.toString(),
                      );

                  firebase_storage.UploadTask uploadTask = ref.putFile(
                    _image!.absolute,
                  );

                  await uploadTask;
                  var newUrl = await ref.getDownloadURL();

                  await firestore.collection('post').add({
                    'id': '1232',
                    'title': newUrl.toString(),
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  setState(() {
                    lodaing = false;
                  });
                  ToastUtils.show('Uploaded');
                } catch (e) {
                  setState(() {
                    lodaing = false;
                  });
                  ToastUtils.show('Upload failed: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
