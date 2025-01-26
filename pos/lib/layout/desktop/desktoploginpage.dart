import'package:flutter/material.dart';

class Desktoploginpage extends StatelessWidget {
  const Desktoploginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Tech",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.blueAccent),),
        elevation:20,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: Container(

      ),
    );
  }
}

