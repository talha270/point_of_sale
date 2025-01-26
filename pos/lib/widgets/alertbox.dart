import'package:flutter/material.dart';

showalertbox({required BuildContext context,required String title,required String message}) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      elevation: 20,
      // backgroundColor: Colors.red.shade200,
      // icon: Icon(Icons.ac_unit_sharp),
      title: Text(title),
      shadowColor: Colors.black,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          // Text("you are sure to cancel")
        ],
      ),
      actions: [
        // TextButton(onPressed: (){}, child: const Text("Approved")),
        TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Ok")),
      ],
    );
  },);
}