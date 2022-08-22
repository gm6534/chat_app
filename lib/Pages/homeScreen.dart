import 'dart:developer';

import 'package:chat_app/Pages/searchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/ChatRoomModel.dart';
import '../Models/FirebaseHelper.dart';
import '../Models/UserModels.dart';
import 'Bio.dart';
import 'chatScreen.dart';
import 'completeProfile.dart';
import 'login.dart';


class HomeScreen extends StatefulWidget {
  final User user;

  final UserModel userModel;

  HomeScreen({required this.user, required this.userModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imgUrl;
  String? uName;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserImg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image: NetworkImage('https://media4.giphy.com/media/xSg1yroo8Q1VdZy2qS/giphy.gif?cid=ecf05e47y8innzopq2k9n0473qneu9eawdfu30rltevx6wa9&rid=giphy.gif&ct=g')
                  ),
                    color: Colors.purple
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CompleteProfile(
                                    userModel: widget.userModel,
                                    user: widget.user)));
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 38,
                          child: CircleAvatar(
                            radius: 34,
                            backgroundImage: NetworkImage(imgUrl.toString()),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          uName.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.userModel.email.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 25,)
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.home),
                          title: Text("Home"),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> BioScreen()));
                          },
                          leading: Icon(Icons.contact_mail),
                          title: Text("Bio"),
                        ),
                        // ListTile(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => SearchScreen(
                        //                 user: widget.user,
                        //                 userModel: widget.userModel)));
                        //   },
                        //   leading: Icon(Icons.search),
                        //   title: Text("Search Friends"),
                        // ),
                        // const Divider(),
                        // ListTile(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (_) => CompleteProfile(
                        //                 userModel: widget.userModel,
                        //                 user: widget.user)));
                        //   },
                        //   leading: Icon(Icons.edit),
                        //   title: Text("Profile Edit"),
                        // ),
                        const Divider(),
                        const Spacer(),
                        ListTile(
                          tileColor: Colors.red.shade600,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LogInScreen()),
                                (route) => false);
                          },
                          leading: Icon(Icons.logout),
                          title: Text("LogOut"),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: const Text("Chat App"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        user: widget.user, userModel: widget.userModel)));
          },
          child: Icon(Icons.search),
        ),
        body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participent.${widget.userModel.uid}", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.active) {
                  if (snapshots.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshots.data as QuerySnapshot;
                    return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              querySnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> participants =
                              chatRoomModel.participent!;
                          List<String> participantKeys =
                              participants.keys.toList();
                          participantKeys.remove(widget.userModel.uid);
                          return FutureBuilder(
                              future: FirebaseHElper.getUserModelById(
                                  participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    UserModel targetUser =
                                        userData.data as UserModel;
                                    return Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                            targetuser: targetUser,
                                                            chatRoomModel:
                                                                chatRoomModel,
                                                            user: widget.user,
                                                            userModel:
                                                                widget.userModel)));
                                          },
                                          leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  targetUser.profilepic
                                                      .toString())),
                                          title:
                                              Text(targetUser.fullname.toString()),
                                          subtitle: chatRoomModel.lastMessage != ""
                                              ? Text(
                                                  chatRoomModel.lastMessage
                                                      .toString(),
                                                )
                                              : const Text(
                                                  "Tap to Chat",
                                                  style:
                                                      TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
                                                ),
                                          trailing: IconButton(onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Chat With ${targetUser.fullname.toString()}"),
                                                    content: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Cancel")),
                                                          InkWell(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                    "chatrooms")
                                                                    .doc(
                                                                    chatRoomModel
                                                                        .chatid)
                                                                    .delete();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.red),
                                                              ))
                                                        ]),
                                                  );
                                                });
                                          }, icon: Icon(Icons.more_vert_outlined)),
                                        ),
                                        Divider()
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              });
                        });
                  } else if (snapshots.hasError) {
                    return Center(
                      child: Text(snapshots.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("no chat here"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
