import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/layout/mobile/homepage_widgets/updatedetails.dart';
import 'package:provider/provider.dart';

class Detailspage extends StatelessWidget {
  const Detailspage({super.key, required this.itemmap});
  final Map<String, dynamic> itemmap;

  @override
  Widget build(BuildContext context) {
    final dbcontroller = Provider.of<Dbcontroller>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).focusColor,
          ),
        ),
        title: Text(
          "Inventory Tech",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.blueAccent),
        ),
        elevation: 20,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  foregroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(itemmap[dbcontroller.inventorycolumn7image])),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                  child: IconButton(icon: const Icon(Icons.update,size: 50,),
                      color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Updatedetails(item: itemmap,),));
                    },)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Product Name: ${ itemmap[dbcontroller.inventorycolumn2name]}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    context,
                    Icons.price_check,
                    "Per Unit Cost: ",
                    itemmap[dbcontroller.inventorycolumn6cost].toStringAsFixed(2),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    context,
                    Icons.price_check,
                    "Per Unit Price: ",
                    itemmap[dbcontroller.inventorycolumn3price].toStringAsFixed(2),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    context,
                    Icons.account_balance_outlined,
                    "Tax Rate: ",
                    itemmap[dbcontroller.inventorycolumn8taxrate].toStringAsFixed(2),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    context,
                    Icons.price_check,
                    "Final Price: ",
                    calculatefinalprice(dbcontroller)
                  ),
                  const SizedBox(height: 10),

                  _buildInfoRow(
                    context,
                    Icons.category,
                    "Category: ",
                    itemmap[dbcontroller.inventorycolumn9categoriesname],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    context,
                    Icons.production_quantity_limits,
                    "Units: ",
                    itemmap[dbcontroller.inventorycolumn5nounit].toString(),
                  ),
                  const SizedBox(height: 10),
                  _buildDescriptionContainer(
                      context, "Description:", itemmap[dbcontroller.inventorycolumn4description]),
                  const SizedBox(height: 10),
                  _buildDescriptionContainer(
                      context, "Barcode:", itemmap[dbcontroller.inventorycolumn10barcode]),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String calculatefinalprice(var dbcontroller){
    return (((itemmap[dbcontroller.inventorycolumn8taxrate]/100)*itemmap[dbcontroller.inventorycolumn3price])+itemmap[dbcontroller.inventorycolumn3price]).toStringAsFixed(2);
  }

  Widget _buildDescriptionContainer(
      BuildContext context, String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
