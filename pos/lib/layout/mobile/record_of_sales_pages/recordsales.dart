import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/layout/mobile/record_of_sales_pages/monthsalesrecord.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class Recordsales extends StatefulWidget {
  const Recordsales({super.key});

  @override
  State<Recordsales> createState() => _RecordsalesState();
}

class _RecordsalesState extends State<Recordsales> {
  late List<Map<String,dynamic>> itemsales;
  late List<Map<String,dynamic>> todayprofitandcost;
  late DateTime? date;
  bool isloading=true;


  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: date,
      lastDate: DateTime.now(),
        monthPickerDialogSettings: const MonthPickerDialogSettings(
          headerSettings: PickerHeaderSettings(
            headerBackgroundColor: Colors.blueAccent,
            headerCurrentPageTextStyle: TextStyle(fontSize: 14,color: Colors.black),
            headerSelectedIntervalTextStyle: TextStyle(fontSize: 16,color: Colors.black),
          ),
    )
    );

    if (picked != null){
      print(DateFormat.yMMM().format(picked));
      final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthsalesrecord(checkdate: DateFormat.yMMMM().format(picked).toString(),checkwherecolumn:dbcontroller.salesitemcolumn8monthyear,)));
    }
  }
  Future<void> _selectyear(BuildContext context) async {
    final picked = await showYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: date,
        lastDate: DateTime.now(),
        monthPickerDialogSettings: const MonthPickerDialogSettings(
          headerSettings: PickerHeaderSettings(
            headerBackgroundColor: Colors.blueAccent,
            headerCurrentPageTextStyle: TextStyle(fontSize: 14,color: Colors.black),
            headerSelectedIntervalTextStyle: TextStyle(fontSize: 16,color: Colors.black),
          ),
        )
    );

    if (picked != null){
      print(picked);
      final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthsalesrecord(checkdate: picked.toString(),checkwherecolumn:dbcontroller.salesitemcolumn9year,)));
    }
  }

  @override
  void initState() {
    super.initState();
    getsalesdetails();
  }
  getsalesdetails()async{
    final stringdate=Provider.of<ShareProvider>(context,listen: false).publishdate;
    date= DateTime.tryParse(stringdate);
    var dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
    itemsales =await dbcontroller.getUniqueProductSales(date:DateFormat('yyyy-MM-dd').format(DateTime.now()),wherecolumn: dbcontroller.salesitemcolumn7date);
    todayprofitandcost =await dbcontroller.getprofitandcost(date:DateFormat('yyyy-MM-dd').format(DateTime.now()),wherecolumn: dbcontroller.salesitemcolumn7date);
    setState(() {
      isloading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isloading?const Center(child: CircularProgressIndicator(),): Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children:[
              const SizedBox(height:10),
              const SizedBox(height:10),
              Text("Today's Product Sales Overview", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:10),
              const Text("1.Track the performance of each product with a real-time sales graph."),
              const SizedBox(height:10),
              const Text("2.See how each product is selling today and gain insights into the most popular items."),
               const SizedBox(height:10),
              const Text("3.Stay updated on today's sales trends for better decision-making."),
               const SizedBox(height:10),
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
              itemsales.isNotEmpty?SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text("Today Sales Amount: ${todayprofitandcost[0]["totalamount"].toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 2,),
                   Text("Today Sales Cost: ${todayprofitandcost[0]["totalcost"].toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 2,),
                   Text("Today Net Profit: ${(todayprofitandcost[0]["totalamount"]-todayprofitandcost[0]["totalcost"]).toStringAsFixed(2)}",style: Theme.of(context).textTheme.titleLarge,),
                  ],
                ),
              ):const Text("No Any Sales Yet."),
              const SizedBox(height:10),
              const Divider(),
              Text("Monthly Sales Overview", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:10),
              const Text("1.Tap on the dropdown to select the month you wish to view. You can scroll through the list of available months and pick the one you’re interested in."),
              const SizedBox(height:10),
              const Text("2.Once the month is selected, you’ll see a real-time sales graph displaying the total sales for that period.Track daily performance and see how each product has sold throughout the month."),
              const SizedBox(height:10),
              const Text("3.Below the graph, detailed statistics show the total profit and cost of products for the selected month.Review these to gain insights into your overall earnings and expenses."),
              const SizedBox(height:10),
              const Text("4.Use this data to understand trends and make informed choices on inventory and product pricing for the coming months."),
              Row(
                children: [
                  const Text("Select the Month => "),
                  TextButton(
                    onPressed: () => _selectMonth(context),
                    child: const Text('Select Month',style: TextStyle(color: Colors.blueAccent,fontSize: 14),),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Divider(),
              Text("Yearly Sales Overview", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height:10),
              const Text("1.Tap on the dropdown to select the year you wish to view. You can scroll through the list of available year and pick the one you’re interested in."),
              const SizedBox(height:10),
              const Text("2.Once the year is selected, you’ll see a real-time sales graph displaying the total sales for that period.Track daily performance and see how each product has sold throughout the year."),
              const SizedBox(height:10),
              const Text("3/.Below the graph, detailed statistics show the total profit and cost of products for the selected year.Review these to gain insights into your overall earnings and expenses."),
              const SizedBox(height:10),
              const Text("4.Use this data to understand trends and make informed choices on inventory and product pricing for the coming year."),
              Row(
                children: [
                  const Text("Select the Year => "),
                  TextButton(
                    onPressed: () => _selectyear(context),
                    child: const Text('Select Year',style: TextStyle(color: Colors.blueAccent,fontSize: 14),),
                  ),
                ],
              ),

            ]
          ),
        ),
      )
    );
  }
}
