import 'dart:io';
import 'package:chat_app/Widgets/Toolbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/UserModels.dart';
import 'homeScreen.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const CompleteProfile(
      {super.key, required this.userModel, required this.user});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  PickedFile? imageFile;
  String? imgUrl;
  final imagePicker = ImagePicker();
  TextEditingController fullNamecontroller = TextEditingController();
  // TextEditingController lastController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  checkValues() {
    if (fullNamecontroller.text.trim() == ""){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Full Name Required")));
    } else {
      uploadData();
    }
  }

  uploadData() async {
    var file = File(imageFile!.path);
    UploadTask uploadTask = FirebaseStorage.instance
        .ref(widget.userModel.email.toString())
        .putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String imgUrl = await snapshot.ref.getDownloadURL();
    UserModel userModel = UserModel(
        uid: widget.userModel.uid,
        fullname: fullNamecontroller.text,
        // firstname: firstcontroller.text.trim(),
        // lastname: lastController.text.trim(),
        address: addressController.text,
        phone: phoneController.text,
        email: widget.userModel.email,
        profilepic: imgUrl);
    await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(widget.userModel.uid)
        .update(userModel.toMap())
        .then((value) => {
              print("dataUpload"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          user: widget.user, userModel: widget.userModel)))
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              CupertinoButton(
                onPressed: () {
                  dialougeBox();
                },
                child: CircleAvatar(
                  backgroundImage: imageFile != null
                      ? FileImage(File(imageFile!.path))
                      : null,
                  radius: 70,
                  child: Icon(
                    imageFile == null ? Icons.person : null,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: fullNamecontroller,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person), hintText: "Type Full Name", labelText: "Name", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 12,
              ),
              // TextFormField(
              //   controller: lastController,
              //   decoration: const InputDecoration(
              //       prefixIcon: Icon(Icons.person), hintText: "Last Name"),
              // ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone), hintText: "Type Mobile Number", labelText: "Phone", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.place), hintText: "Type Address", labelText: "Place", border: OutlineInputBorder()),

              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BIO", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 20,),),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 250,
                    child: ToolBarWidget(),
                  ),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        checkValues();
                      },
                      child: const Text("Update"))),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickedImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
  }

  dialougeBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pick Profile Image"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () async {
                  pickedImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.browse_gallery_outlined),
                title: const Text("Gallery"),
              ),
              ListTile(
                onTap: () {
                  pickedImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              )
            ]),
          );
        });
  }
}



  // croppedfile(PickedFile file) async {
  //   CroppedFile? croppedImage = await ImageCropper.platform
  //       .cropImage(sourcePath: file.path, compressQuality: 20);
  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //     });
  //   }
  // }