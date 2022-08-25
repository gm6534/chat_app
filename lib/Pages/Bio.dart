import 'dart:convert';

import 'package:chat_app/Models/UserModels.dart';
import 'package:chat_app/Pages/completeProfile.dart';
import 'package:chat_app/Widgets/ProgressIndicater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../Widgets/Toolbar.dart';
import '../Widgets/Toolbar.dart';

class BioScreen extends StatefulWidget {
  final User user;

  final UserModel userModel;

  BioScreen({required this.user, required this.userModel});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  String? feedBack;
  String? imgUrl;
  String? uName;
  QuillController _controller = QuillController.basic();

  bio() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(user!.uid).collection("feedback").doc(user!.uid)
        .get();
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    feedBack = map['feedBack'];
    print(map['feedBack']);
    var myJSON = jsonDecode(feedBack.toString());
    setState(() {
      _controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0));
    });
  }
  ///User Image

  getCurrentUserImg() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(user!.uid)
        .get();
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    print(map['fullname']);


    setState(() {
      imgUrl = map['profilepic'];
      uName=map['fullname'];


    });
    // print(uName);
  }


  ///

@override
  void initState() {
    // TODO: implement initState
    bio();
    getCurrentUserImg();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
              text: "BIO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
            )),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CompleteProfile(userModel: widget.userModel, user: widget.user)));
                setState(() {
                  QuillEditor.basic(
                    controller: _controller,
                    readOnly: false, // true for view only mode
                  );
                });
              },
              icon: Icon(Icons.edit)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              CircleAvatar(
                backgroundImage: NetworkImage(imgUrl.toString()),
                radius: 70,
              ),
              SizedBox(height: 80,),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    RichText(
                        text: TextSpan(
                            text: "Full Name:", style: TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold)
                        )),
                    SizedBox(width: 20,),
                    RichText(
                        text: TextSpan(
                            text: "$uName", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                        )),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                    text: TextSpan(
                      text: "Bio", style: TextStyle(color: Colors.purple, fontSize: 30, fontWeight: FontWeight.bold)
                    )),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: QuillEditor.basic(
                  controller: _controller,
                  readOnly: true, // true for view only mode
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

}
