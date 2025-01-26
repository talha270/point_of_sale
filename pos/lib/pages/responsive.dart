import 'package:flutter/material.dart';

class Responsivelayout extends StatelessWidget {
  final Widget mobilebody;
  final Widget desktopbody;
  const Responsivelayout({super.key, required this.mobilebody, required this.desktopbody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context, constraints) {
        if(constraints.maxWidth < 550){
          return mobilebody;
        }
        else{
          return mobilebody;
        }
      },
    );
  }
}
