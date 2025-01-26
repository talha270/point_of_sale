import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Monthsalesrecord extends StatefulWidget{
  const Monthsalesrecord({super.key, required this.checkdate, required this.checkwherecolumn});
  final String checkdate;
  final String checkwherecolumn;
  @override
  State<Monthsalesrecord> createState() => _MonthsalesrecordState();
}

class _MonthsalesrecordState extends State<Monthsalesrecord> {
  late List<Map<String,dynamic>> itemsales;
  late List<Map<String,dynamic>> todayprofitandcost;
  bool isloading=true;
  int temp=0;
  @override
  void initState(){
    super.initState();
    getsalesdetails();
  }
  getsalesdetails()async{
    var dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
    itemsales=await dbcontroller.getUniqueProductSales(date:widget.checkdate,wherecolumn: widget.checkwherecolumn);
    todayprofitandcost=await dbcontroller.getprofitandcost(date: widget.checkdate,wherecolumn: widget.checkwherecolumn);
    setState(() {
      isloading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
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
      body:isloading?const Center(child: CircularProgressIndicator(),): Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.5,
                child: SfCartesianChart(
                  legend: const Legend(isVisible: true),
                  title: const ChartTitle(text: "Sales Analysis"),
                  series: [
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: itemsales,
                      legendItemText: "Products",
                      xValueMapper: (Map<String, dynamic> sales, _) {
                        return sales['productName']; // X-axis should remain String
                      },
                      yValueMapper: (Map<String, dynamic> sales, _) {
                        var quantity = sales['quantity'];
                        if (quantity is String) {
                          var parsedQuantity = int.tryParse(quantity) ?? double.tryParse(quantity);
                          return parsedQuantity ?? 0; // Safely return numeric value for Y-axis
                        }
                        return quantity as num; // Ensure it's a number
                      },
                    ),
                  ],
                  primaryXAxis: const CategoryAxis(
                    labelRotation: 45, // Rotate the x-axis labels by 45 degrees
                  ),
                  primaryYAxis: const NumericAxis(
                    interval: 1, // Set y-axis interval to 1
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              itemsales.isNotEmpty?itemsales.length>=6?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("The 6 Most Sold Products",style: Theme.of(context).textTheme.titleLarge,),
                  Text("1. ${itemsales[0]["productName"]}."),
                  Text("2. ${itemsales[1]["productName"]}."),
                  Text("3. ${itemsales[2]["productName"]}."),
                  Text("4. ${itemsales[3]["productName"]}."),
                  Text("5. ${itemsales[4]["productName"]}."),
                  Text("6. ${itemsales[5]["productName"]}."),
                ],
              ):Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("The ${itemsales.length} Most Sold Products",style: Theme.of(context).textTheme.titleLarge,),
                    ...itemsales.map((toElement){
                      temp++;
                      return Text("$temp. ${toElement["productName"]}");
                    }),
                  ]
                ),
              ):Container(),
              const SizedBox(height: 10,),
              itemsales.isNotEmpty?SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sales Amount: ${todayprofitandcost[0]["totalamount"].toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 2,),
                    Text("Sales Cost: ${todayprofitandcost[0]["totalcost"].toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 2,),
                    Text("Net Profit: ${(todayprofitandcost[0]["totalamount"]-todayprofitandcost[0]["totalcost"]).toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                  ],
                ),
              ):const Text("No Any Sales Yet."),
            ],
          ),
        ),
      ),
    );
  }
}