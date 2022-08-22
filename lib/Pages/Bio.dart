import 'dart:convert';

import 'package:chat_app/Widgets/ProgressIndicater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({Key? key}) : super(key: key);

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  String? feedBack;
  bio() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatAppUsers")
        .doc(user!.uid).collection("feedback").doc(user!.uid)
        .get();
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    setState(() {
      feedBack = map['feedBack'];


    });
    print(map['feedBack']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BIO"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                // showDialog(context: context, builder: (context){
                //   return ImageLoader();
                //
                // }
                //
                // );
                bio();
              },
              icon: Icon(Icons.edit)
          )
        ],
      ),
      body: Center(
        child: Container(

          child: Text(
              feedBack.toString()
          ),
        ),
      ),
    );
  }
}
