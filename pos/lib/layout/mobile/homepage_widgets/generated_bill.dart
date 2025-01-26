import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class GeneratedBill extends StatefulWidget {
  const GeneratedBill({super.key, required this.itemlist});
  final List itemlist;

  @override
  State<GeneratedBill> createState() => _GeneratedBillState();
}

class _GeneratedBillState extends State<GeneratedBill> {
  late double totalamount;
  late double totalcost;
  late String customername;
  String cashiername="";
  String paymentmethod="";
  late int saleId;
  late double receivedamount;
  bool isloading=true;
  bool getname=true;
  final _formkey=GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    calculatefinaltotal();
  }
  calculatefinaltotal(){
    double temp=0;
    double temp1=0;
    for(int i=0; i<widget.itemlist.length;i++){
      temp+=widget.itemlist[i]["total"];
      temp1+=widget.itemlist[i]["totalcost"];
    }
    totalamount=temp;
    totalcost=temp1;
    setState(() {
      isloading=false;
    });

  }
  void addSaleWithItems() async {
    setState(() {
      isloading=true;
    });
    if(widget.itemlist.isNotEmpty){
      final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
      // Step 1: Insert into sales table
      saleId = await dbcontroller.insertSale(year: DateFormat.y().format(DateTime.now()),monthyear:DateFormat.yMMMM().format(DateTime.now()) ,totalcost: totalcost,date:  DateFormat('yyyy-MM-dd').format(DateTime.now()),time:  DateFormat('hh:mm:ss a').format(DateTime.now()),total:  totalamount,name: customername);

      // Step 2: Insert items into sale_items table
      for (var item in widget.itemlist) {
        await dbcontroller.updateInventory(image: item[dbcontroller.inventorycolumn7image], productname: item[dbcontroller.salesitemcolumn3productName], perunitprice: item["preprice"], perunitcost: item[dbcontroller.inventorycolumn6cost], description: item[dbcontroller.inventorycolumn4description], noofunit: item[dbcontroller.inventorycolumn5nounit]-item[dbcontroller.salesitemcolumn4quantity], taxrate: item[dbcontroller.inventorycolumn8taxrate],categorie: item[dbcontroller.inventorycolumn9categoriesname], id: item[dbcontroller.inventorycolumn1sno]);
        await dbcontroller.insertSaleItem(year: DateFormat.y().format(DateTime.now()),monthyear:DateFormat.yMMMM().format(DateTime.now()),saleId: saleId,productName:  item[dbcontroller.salesitemcolumn3productName],quantity:  item[dbcontroller.salesitemcolumn4quantity],price:  item[dbcontroller.salesitemcolumn5price],total:  item[dbcontroller.salesitemcolumn6total],date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
      }

    }
    setState(() {
      isloading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final dbcontroller = Provider.of<Dbcontroller>(context,listen: false);
    final shareprovider = Provider.of<ShareProvider>(context,listen: false);

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
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.blueAccent),
        ),
        elevation: 20,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: isloading?const Center(child: CircularProgressIndicator(),):widget.itemlist.isNotEmpty?getname?getnameform():
      SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Invoice', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Text(shareprovider.businessname,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                const SizedBox(height: 10),
                Text(shareprovider.address),
                const SizedBox(height: 10),
                Text("Phone# ${shareprovider.ponenumber}"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Cashier Name:  $cashiername')),
                    const SizedBox(width: 10,),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(DateFormat('yyyy-MM-dd').format(DateTime.now())))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Customer Name:  $customername')),
                    const SizedBox(width: 10,),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(DateFormat('hh:mm:ss a').format(DateTime.now())))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Payment Method:  $paymentmethod')),
                    const SizedBox(width: 10,),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("InvoiceId: $saleId"))
                  ],
                ),
                const SizedBox(height: 20),

                // The Table widget replaces DataTable
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2), // Product Name column gets more space
                  },
                  // border: TableBorder.all(color: Theme.of(context).focusColor), // Transparent borders like before
                  children: [
                    // Header row
                   const TableRow(
                      children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('EX.VAL', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('GST%', style: TextStyle(fontWeight: FontWeight.bold))),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('GST', style: TextStyle(fontWeight: FontWeight.bold))),

                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: FittedBox(fit: BoxFit.scaleDown,child:  Text('Price(unit)', style: TextStyle(fontWeight: FontWeight.bold)),),
                        ),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('total', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),

                    // Generate rows for each item in the list
                    ...widget.itemlist.map(
                          (item) => TableRow(
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn3productName].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn4quantity].toString())),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item["preprice"].toStringAsFixed(2))),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("${item[dbcontroller.inventorycolumn8taxrate]}%")),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(((item[dbcontroller.inventorycolumn8taxrate]/100)*item["preprice"]).toStringAsFixed(2))),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn5price].toStringAsFixed(2))),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item[dbcontroller.salesitemcolumn6total].toStringAsFixed(2))),
                        ],
                      ),
                    ),

                    // Total row
                    TableRow(
                      children: [
                        const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(totalamount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),

                    // Received Amount row
                    TableRow(
                      children: [
                        const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Received Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(receivedamount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),

                    // Return Amount row
                    TableRow(
                      children: [
                        const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Return Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text((receivedamount-totalamount).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  height:50,
                  width: MediaQuery.sizeOf(context).width*0.5,
                  child: ElevatedButton(onPressed: (){
                    printInvoice(context,widget.itemlist);
                  }, child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Print"),
                      SizedBox(width: 10,),
                      Icon(Icons.print)
                    ],)),
                )
              ],
            ),
          )

        ),
      )
          : const Center(
        child: Text("No any Item Purchased."),
      ),
    );
  }
  trysubmit()async{
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      _formkey.currentState!.save();
      getname=false;
      addSaleWithItems();
    }else{
      // print("error");
    }
  }
  Widget getnameform(){
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  Text("Tell Customer Details",style: Theme.of(context).textTheme.headlineMedium,),
                  Text("Total bill is: ${totalamount.toStringAsFixed(2)}",style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter Customer Name",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      customername=newValue.toString();
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter Cashier Name",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      cashiername=newValue.toString();
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter Received Amount",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else if(int.tryParse(value!.trim())==null){
                        return "Please enter the valid amount.";
                      }else if(int.tryParse(value.trim())!=null){
                        if(int.parse(value.toString())<totalamount){
                        return "Please enter the valid amount.";
                        }
                        else{ return null;}
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      receivedamount=double.parse(newValue.toString());
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter Payment Method",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      paymentmethod=newValue.toString();
                    },
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.7,
                    child: ElevatedButton(onPressed: (){
                      trysubmit();
                    },
                        child: const Text("Next")),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void printInvoice(BuildContext context, List itemlist) {
    final shareprovider=Provider.of<ShareProvider>(context,listen: false);
    final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();
        // Add content to the PDF
        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Invoice', style: const pw.TextStyle(fontSize: 24)),
                  pw.SizedBox(height: 20),
                  pw.Text(shareprovider.businessname, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                  pw.SizedBox(height: 10),
                  pw.Text(shareprovider.address),
                  pw.SizedBox(height: 10),
                  pw.Text("Phone# ${shareprovider.ponenumber}"),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Cashier Name:  $cashiername'),
                      pw.Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Customer Name:  $customername'),
                      pw.Text(DateFormat('hh:mm:ss a').format(DateTime.now())),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Payment Method:  $paymentmethod'),
                      pw.Text("InvoiceId: $saleId"),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // Table header
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('Product Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('QTY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('EX.VAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('GST%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('GST', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Price(unit)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      // Item rows
                      ...itemlist.map((item) {
                        return pw.TableRow(
                          children: [
                            pw.Text(item[dbcontroller.salesitemcolumn3productName].toString()),
                            pw.Text(item[dbcontroller.salesitemcolumn4quantity].toString()),
                            pw.Text(item["preprice"].toStringAsFixed(2)),
                            pw.Text("${item[dbcontroller.inventorycolumn8taxrate]}%"),
                            pw.Text(((item[dbcontroller.inventorycolumn8taxrate] / 100) * item["preprice"]).toStringAsFixed(2)),
                            pw.Text(item[dbcontroller.salesitemcolumn5price].toStringAsFixed(2)),
                            pw.Text(item[dbcontroller.salesitemcolumn6total].toStringAsFixed(2)),
                          ],
                        );
                      }),

                      // Total row
                      pw.TableRow(
                        children: [
                          pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(totalamount.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      // Received Amount row
                      pw.TableRow(
                        children: [
                          pw.Text('Received Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(receivedamount.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      // Return Amount row
                      pw.TableRow(
                        children: [
                          pw.Text('Return Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text(''),
                          pw.Text((receivedamount - totalamount).toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );

        return pdf.save();
      },
    );
  }




}
