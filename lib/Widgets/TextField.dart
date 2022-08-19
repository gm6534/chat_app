// import 'package:flutter/material.dart';
//
// class Textfield extends StatelessWidget {
//   String hintText;
//   bool obsecureText;
//   Widget? suffix;
//   String? Function(String?)? validator;
//   TextEditingController? controller;
//   Textfield({required this.hintText, required this.obsecureText, this.suffix, this.controller, this.validator});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       // inputFormatters: <TextInputFormatter>[
//       //   FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
//       // ],
//         validator: validator,
//         controller: controller,
//         obscureText: obsecureText,
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: InputBorder.none,
//           suffixIcon: suffix,
//         )
//     );
//   }
// }