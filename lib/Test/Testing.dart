// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
//
// class ToolBar extends StatefulWidget {
//   const ToolBar({Key? key}) : super(key: key);
//
//   @override
//   State<ToolBar> createState() => _ToolBarState();
// }
//
// QuillController _controller = QuillController.basic();
//
// class _ToolBarState extends State<ToolBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//
//               Container(
//                 height: 300,
//                 decoration: BoxDecoration(border: Border.all(width: 1.5),
//                 borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 15,),
//                     QuillToolbar.basic(
//                       controller: _controller,
//                         // showUnderLineButton: false,
//                         showStrikeThrough: false,
//                         showColorButton: false,
//                         // showBackgroundColorButton: false,
//                         showListCheck: false,
//                         showIndent: false,
//                         showUndo: false,
//                         showRedo: false,
//                         showFontFamily: false,
//                         showFontSize: false,
//                         showImageButton: false,
//                         showVideoButton: false,
//                         showQuote: false,
//                         showSearchButton: false,
//                         showAlignmentButtons: true,
//                         showClearFormat: false,
//                         showLink: false,
//                       toolbarSectionSpacing: 1,
//                       toolbarIconAlignment: WrapAlignment.center,
//                       // toolbarIconSize: 15,
//                     ),
//                     Divider(),
//                     Scrollbar(
//                       child: Container(
//                         height: 194,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: QuillEditor.basic(
//                             controller: _controller,
//                             readOnly: false, // true for view only mode
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//     );
//   }
// }
//