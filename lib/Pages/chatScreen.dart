import 'dart:developer';
import 'package:chat_app/Pages/completeProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Models/ChatRoomModel.dart';
import '../Models/MessageModel.dart';
import '../Models/UserModels.dart';
import '../Widgets/triangleChatWidget.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final UserModel targetuser;
  final ChatRoomModel chatRoomModel;
  final User user;
  final UserModel userModel;

  const ChatScreen(
      {super.key,
      required this.targetuser,
      required this.chatRoomModel,
      required this.user,
      required this.userModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var updateTime = DateFormat("hh:mm a").format(DateTime.now());

  User? _auth = FirebaseAuth.instance.currentUser;

  TextEditingController controller = TextEditingController();
  void sendMessage() async {
    String msg = controller.text.trim();
    if (msg != null) {
      //send messages
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatid)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatid)
          .set(widget.chatRoomModel.toMap());
    }
  }

  bool show = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var uid;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          title: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.targetuser.profilepic.toString()),
                    ),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
              SizedBox(width: 5,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteProfile(userModel: widget.userModel, user: widget.user)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.targetuser.fullname.toString()),
                    Text("last scene today at $updateTime", style: TextStyle(fontSize: 10),),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // IconButton(onPressed: (){}, icon: Icon(Icons.videocam), tooltip: "Video Call",),
            IconButton(onPressed: (){}, icon: Icon(Icons.call), tooltip: "Audio Call",),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_outlined), tooltip: "More Options",),
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/img/wallpaper.jpg"), fit: BoxFit.cover)),
            child: Column(children: [
              Expanded(
                  child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoomModel.chatid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.active) {
                      if (snapshots.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshots.data as QuerySnapshot;

                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: (currentMessage.sender ==
                                    widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(19),
                                            bottomLeft: Radius.circular(19),
                                            bottomRight: Radius.circular(19),
                                          ),
                                          color: (currentMessage.sender ==
                                              widget.userModel.uid)
                                              ? Colors.purple
                                              : Colors.blue,
                                        ),
                                        child: Text(
                                           currentMessage.text.toString(),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                                ///
                              //   Row(
                              //   mainAxisAlignment: (currentMessage.sender ==
                              //           widget.userModel.uid)
                              //       ? MainAxisAlignment.end
                              //       : MainAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //         margin: EdgeInsets.symmetric(
                              //             horizontal: 8, vertical: 4),
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 10, vertical: 10),
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           color: (currentMessage.sender ==
                              //                   widget.userModel.uid)
                              //               ? Colors.grey
                              //               : Colors.teal,
                              //         ),
                              //         child: Text(
                              //           currentMessage.text.toString(),
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 20),
                              //         )),
                              //   ],
                              // );
                              ///
                            });
                      } else if (snapshots.hasError) {
                        return const Center(child: Text("Some Error Occured"));
                      } else {
                        return const Center(
                          child: Text("Say SomeThing"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),

              ///



              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.78,
                          decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.purple, width: 1.5), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 5,

                              keyboardType: TextInputType.multiline,
                              textAlign: TextAlign.start,
                              controller: controller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 50,top: 6,bottom: 6),
                                hintText: "Type your message here",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: IconButton(onPressed: (){
                            if (!show) {
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                            }
                            setState(() {
                              show = !show;
                            });
                          },
                            icon: Icon(show
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,color: show?Colors.purple:Colors.orange),),),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: (){
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (builder)=> bottomsheet());
                              },
                              icon: Icon(Icons.attach_file, color: Colors.purple,)),)
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.purple,
                      child: IconButton(
                          onPressed: (){
                            sendMessage();
                            setState(() {
                              updateTime = DateFormat("hh:mm a").format(DateTime.now());
                            });
                            controller.clear();
                          },
                          icon: Icon(Icons.send, color: Colors.white,)),
                    ),                  ],
                ),
              ),




              ///
              // Padding(
              //   padding: const EdgeInsets.only(top: 4, bottom: 3.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.8,
              //         child: TextFormField(
              //             controller: controller,
              //             minLines: 1,
              //             maxLines: 5,
              //             // maxLength: 500,
              //             decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: Colors.grey.shade300,
              //                 border: InputBorder.none,
              //                 contentPadding: const EdgeInsets.all(16),
              //                 hintText: "Type Message")),
              //       ),
              //       Container(
              //           height: 50,
              //           width: 50,
              //           child: ElevatedButton(
              //             onPressed: () {
              //               sendMessage();
              //               setState(() {});
              //               controller.clear();
              //             },
              //             style: ButtonStyle(
              //                 backgroundColor: MaterialStateProperty.all(
              //                     Colors.grey.shade300),
              //                 shape: MaterialStateProperty.all(
              //                     RoundedRectangleBorder(
              //                         borderRadius:
              //                             BorderRadius.circular(30)))),
              //             child: const Icon(
              //               Icons.send,
              //               color: Colors.teal,
              //             ),
              //           ))
              //     ],
              //   ),
              // )
            ]),
          ),
        ));
  }

  Widget bottomsheet(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Container(
        height: 278,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                    SizedBox(width: 40,),
                    InkWell(
                        onTap: () async{
                          await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 20);
                        },
                        child: iconCreation(Icons.camera_alt, Colors.pink, "Camera")),
                    SizedBox(width: 40,),
                    InkWell(onTap:() async{

                      await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 20);

                    },
                        child: iconCreation(Icons.insert_photo, Colors.purple, "Gallery")),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(Icons.headset, Colors.orange, "Audio"),
                    SizedBox(width: 40,),
                    iconCreation(Icons.location_pin, Colors.teal, "Location"),
                    SizedBox(width: 40,),
                    iconCreation(Icons.person, Colors.blue, "Contact"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget iconCreation(IconData icon, Color color, String text){
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
            size: 29,
          ),
        ),
        SizedBox(height: 5,),
        Text(text, style: TextStyle(
            fontSize: 12
        ),)
      ],
    );
  }


}
