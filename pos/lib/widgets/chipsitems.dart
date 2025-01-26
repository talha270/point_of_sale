import 'package:flutter/material.dart';
import 'package:pos/controller/provider_controller/categoriesitem.dart';
import 'package:pos/controller/provider_controller/salesprovider.dart';
import 'package:provider/provider.dart';

class Chipsitems extends StatelessWidget{
  const Chipsitems({super.key, required this.items, required this.dateyacategory});
  final List<Map<String,dynamic>> items;
  final String dateyacategory;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) =>  Padding(
          padding: const EdgeInsets.all(3),
          child: InkWell(
            onTap: (){
                dateyacategory!="date"?Provider.of<Categoriesitem>(context,listen: false).changename(items[index][dateyacategory]):
                    Provider.of<Salesprovider>(context,listen: false).changedate(items[index][dateyacategory]);

              },
            child: Chip(
                elevation: 20,
                shadowColor: Theme.of(context).shadowColor,
                side: BorderSide(color: Theme.of(context).shadowColor),
                shape:
                // BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                label:Text("${items[index][dateyacategory]}"),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            ),
          ),
        ),),
    );
  }
}
