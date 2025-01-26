import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:provider/provider.dart';

class Salesdetailmobile extends StatelessWidget{
  const Salesdetailmobile({super.key, required this.salesid});
  final int salesid;
  @override
  Widget build(BuildContext context) {
    final dbcontroller=Provider.of<Dbcontroller>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
             Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).focusColor,
            )),
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
      body:FutureBuilder(
        future:dbcontroller.getsalesitem(salesid: salesid),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Column(
              children: [
                const SizedBox(height: 10,),
                Text("Product Purchased",style: Theme.of(context).textTheme.headlineMedium,),
                Table(
                  border: TableBorder.all(color: Theme.of(context).focusColor), // Transparent borders like before
                  children: [
                    // Header row
                    const TableRow(
                      children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('SalesId', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('ProductName', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('price', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('total', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),

                    // Generate rows for each item in the list
                    ...snapshot.data!.map(
                          (item) => TableRow(
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn1id].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn2salesid].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn3productName].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn4quantity].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn5price].toStringAsFixed(2))),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn6total].toStringAsFixed(2))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      )
    );
  }
}