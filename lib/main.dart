import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'Models/FirebaseHelper.dart';
import 'Models/UserModels.dart';
import 'Pages/homeScreen.dart';
import 'Pages/login.dart';
import 'Test/Testing.dart';
import 'Widgets/ProgressIndicater.dart';
import 'Widgets/Toolbar.dart';

var uuid = Uuid();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? cUser = FirebaseAuth.instance.currentUser;

  if (cUser != null) {
    UserModel? thisUserModel = await FirebaseHElper.getUserModelById(cUser.uid);
    if (thisUserModel != null) {
      runApp(LoggedIn(userModel: thisUserModel, user: cUser));
    } else {
      runApp(MyApp());
    }
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter ChatApp',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: LogInScreen());
  }
}

class LoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User user;

  const LoggedIn({super.key, required this.userModel, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter ChatApp',
      theme: ThemeData(primarySwatch: Colors.purple),
      home:
      // ImageLoader()
      HomeScreen(user: user, userModel: userModel),
    );
  }
}
