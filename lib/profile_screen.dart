import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? selectedImage;

  getImageFromGallery() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  getImageFromCamera() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              selectedImage == null
                  ? CircleAvatar(
                      radius: 40,
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(selectedImage!.path)),
                    ),
              IconButton(
                onPressed: () {
                  getImageFromGallery();
                },
                icon: Icon(Icons.photo),
              ),
              IconButton(
                onPressed: () {
                  getImageFromCamera();
                },
                icon: Icon(Icons.camera_alt),
              ),
            ],
          ),
          Container(
            height: 400,
            width: double.infinity,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('images').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("no data found "),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        width: 100,
                        child:
                            Image.network(snapshot.data!.docs[index]['image']),
                      );
                    });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            FirebaseStorage fs = FirebaseStorage.instance;
            Reference ref = await fs
                .ref()
                .child(DateTime.now().millisecondsSinceEpoch.toString());
            await ref.putFile(File(selectedImage!.path));
            String url = await ref.getDownloadURL();
            await FirebaseFirestore.instance.collection('images').add({
              'image': url,
            });
          } catch (e) {
            print(e.toString());
          }
        },
        child: Text("ars"),
      ),
    );
  }
}
