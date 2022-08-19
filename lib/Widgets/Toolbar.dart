import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ToolBarWidget extends StatefulWidget {
  const ToolBarWidget({Key? key}) : super(key: key);

  @override
  State<ToolBarWidget> createState() => _ToolBarWidgetState();
}

QuillController _controller = QuillController.basic();

class _ToolBarWidgetState extends State<ToolBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
          child: Container(
            height: 220,
            decoration: BoxDecoration(border: Border.all(width: 1.5, color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                SizedBox(height: 15,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 15,),
                      QuillToolbar.basic(
                        controller: _controller,
                        // showUnderLineButton: false,
                        showStrikeThrough: false,
                        showColorButton: false,
                        // showBackgroundColorButton: false,
                        showListCheck: false,
                        showIndent: false,
                        showUndo: false,
                        showRedo: false,
                        showFontFamily: false,
                        showFontSize: false,
                        showImageButton: false,
                        showVideoButton: false,
                        showQuote: false,
                        showSearchButton: false,
                        showAlignmentButtons: true,
                        showClearFormat: false,
                        showLink: false,
                        toolbarSectionSpacing: 1,
                        toolbarIconAlignment: WrapAlignment.center,
                        // toolbarIconSize: 15,
                      ),
                    ],
                  ),
                ),
                Divider(),
                Scrollbar(
                  child: Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
