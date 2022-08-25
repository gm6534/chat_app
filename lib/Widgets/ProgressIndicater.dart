import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class ImageLoader extends StatelessWidget {
  double val = 0.0;
  // double? size;

  ImageLoader({required this.val});


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 30,
      width: 250,
      child: LiquidLinearProgressIndicator(
        backgroundColor: Colors.white,
        borderColor: Colors.grey.shade300,
        direction: Axis.horizontal,
        value: val/100,
        borderRadius: 10,
        borderWidth: 2,
        center: Text("${val.toInt()}%", style: TextStyle(color: Colors.grey, fontSize: 20, decoration: TextDecoration.none),),
      ),
    );
  }
}
