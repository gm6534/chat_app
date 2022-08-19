//
//
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// class CompleteProfileScreen extends StatefulWidget {
//   const CompleteProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
// }
//
// class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
//
//   File? imageFile;
//
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//
//
//   void selectImage(ImageSource source) async{
//    XFile? pickedFile = await ImagePicker().pickImage(source: source);
//
//    if(pickedFile != null){
//      cropImage(pickedFile);
//    }
//   }
//
//   void cropImage(XFile file) async{
//   File? croppedImage =  (await ImageCropper().cropImage(
//       sourcePath: file.path,
//       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: 20
//   )) as File?;
//
//   if(croppedImage != null){
//     setState(() {
//       imageFile = croppedImage;
//     });
//   }
//   }
//
//
//   void showPhotoOptions() {
//     showDialog(context: context, builder: (context)
//     {
//       return AlertDialog(
//         title: Text("Select Profile Image"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               onTap: (){
//                 Navigator.pop(context);
//                 selectImage(ImageSource.gallery);
//               },
//               leading: Icon(Icons.photo_album),
//               title: Text("Select From Gallery"),
//             ),
//             ListTile(
//               onTap: (){
//                 Navigator.pop(context);
//                 selectImage(ImageSource.camera);
//               },
//               leading: Icon(Icons.camera_alt),
//               title: Text("Take a Photo"),
//             )
//           ],
//         ),
//
//       );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//           child: Container(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 40
//               ),
//               child: ListView(
//                 children: [
//                   SizedBox(height: 30,),
//                   CupertinoButton(
//                     onPressed: () {
//                       showPhotoOptions();
//                     },
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundImage: (imageFile != null) ? FileImage (imageFile!) : null,
//                       child: (imageFile == null) ? Icon(Icons.person, size: 60,) : null,
//                     ),
//                   ),
//                   SizedBox(height: 30,),
//                   Form(
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             keyboardType: TextInputType.name,
//                             decoration: InputDecoration(hintText: "Enter Full Name", border: OutlineInputBorder(), labelText: "Name", prefixIcon: Icon(Icons.person)),
//                             validator:(val){
//                               if (val== null || val==""){
//                                 return "Required*";
//                               }
//                               else{
//                                 return null;
//                               }
//                             },
//                           ),
//                           SizedBox(height: 15,),
//                           TextFormField(
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: InputDecoration(hintText: "Enter Email", border: OutlineInputBorder(), labelText: "Email", prefixIcon: Icon(Icons.alternate_email_outlined)),
//                             validator:(val){
//                               if (val== null || val==""){
//                                 return "Required*";
//                               }
//                               else{
//                                 return null;
//                               }
//                             },
//                           ),
//                           SizedBox(height: 15,),
//                           TextFormField(
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(hintText: "Enter Mobile Number", border: OutlineInputBorder(), labelText: "Mobile", prefixIcon: Icon(Icons.phone)),
//                           ),
//                           SizedBox(height: 15,),
//                           TextFormField(
//                             decoration: InputDecoration(hintText: "Enter Address", border: OutlineInputBorder(), labelText: "Address", prefixIcon: Icon(Icons.location_on_sharp)),
//
//                           ),
//                         ],
//                       )),
//                   SizedBox(height: 30,),
//                   CupertinoButton(onPressed: (){},
//                       color: Colors.purple,
//                       child: Text("Submit", style: TextStyle(fontWeight: FontWeight.bold),)
//                   )
//
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
