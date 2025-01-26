import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Generatebarcodepage extends StatefulWidget{
  const Generatebarcodepage({super.key, required this.category});
  final String category;
  @override
  State<Generatebarcodepage> createState() => _GeneratebarcodepageState();
}

class _GeneratebarcodepageState extends State<Generatebarcodepage> {
  bool generated=false;

  final _formkey=GlobalKey<FormState>();

  String productname="";

  String countrycode="";

  @override
  Widget build(BuildContext context) {
  final dbprovider=Provider.of<Dbcontroller>(context,listen: false);
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
        elevation: 30,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: generated==false?FutureBuilder(future: dbprovider.getproductnames(),
        builder: (context, snapshot) {
        if(snapshot.hasData){
          return Container(
            margin: const EdgeInsets.all(20),
            child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("How to Generate a ${widget.category} for Your Product:",style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 5,),
                       Text("Follow these simple steps to create a ${widget.category} for your product, based on its name and the country code."),
                      const SizedBox(height: 5,),
                      Text("1. Enter the Product Name",style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 5,),
Text("Start by entering the name of your product in the provided field. This should be a short, clear name that helps identify your product.\nExample: If you're creating a ${widget.category} for a laptop, enter \"Laptop Pro.\" " ),
                      const SizedBox(height: 5,),
    Text("2. Enter the Country Code",style:Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 5,),
    const Text("Instead of selecting the country name, input the country code (the short code representing the country). This is a two-letter code used worldwide to identify countries (e.g., US for the United States, IN for India).\nExample: If your product originates from the United States, enter US."),
                      const SizedBox(height: 5,),
Text("3. Generate the ${widget.category}",style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 5,),
Text("Once you've entered the product name and country code, tap the \"Generate ${widget.category}\" button. This will create a ${widget.category} that encodes both the product name and the country code.\nThe ${widget.category} will be a unique identifier for your product based on these details."),
                      const SizedBox(height: 5,),
Text("4. Print Your ${widget.category}",style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 5,),
Text("After generating the ${widget.category}, you can:\nPrint it to label your product.\nBy using this ${widget.category}, you can easily scan and track your product based on its name and country of origin."),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),
                          Text("Generate ${widget.category}",style: Theme.of(context).textTheme.headlineMedium,),
                          const SizedBox(height: 10,),
                          TextFormField(
                            decoration:InputDecoration(
                              hintText: "Enter Product Name",
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            validator: (value) {
                              if(value.toString().isEmpty){
                                return "Please Enter";
                              }else if(snapshot.data!.contains(value)){
                                return "Product Name is Unique.";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              productname=newValue.toString().trim();
                            },
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            decoration:InputDecoration(
                              hintText: "Enter country Code",
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            validator: (value) {
                              if(value.toString().isEmpty){
                                return "Please Enter";
                              }else if(value.toString().length>2){
                                return "Country Code maximum Length is 2.";
                              }else{
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              countrycode=newValue.toString().trim();
                            },
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.7,
                            child: ElevatedButton(onPressed: (){
                              final isvalid=_formkey.currentState!.validate();
                              if (isvalid){
                                _formkey.currentState!.save();
                                generated=true;
                                setState(() {

                                });
                              }else{

                              }
                            },
                                child: const Text("Generate")),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        }else if(snapshot.hasError){
          // print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()),);
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }
      },):
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white, // Set container background color to white
                child: Padding(
                  padding: const EdgeInsets.all(10.0), // Adjust this value to increase/decrease the border size
                  child: BarcodeWidget(
                    backgroundColor: Colors.white,
                    data: "$countrycode-$productname",
                    barcode: widget.category == "Barcode" ? Barcode.code128() : Barcode.qrCode(),
                    width: 250,
                    height: widget.category == "Barcode" ? 100 : 250,
                    color: Colors.black,
                    drawText: false,
                  ),
                ),
              ),

              const SizedBox(height: 10,),
              SizedBox(
                height:50,
                width: MediaQuery.sizeOf(context).width*0.5,
                child: ElevatedButton(onPressed: (){
                  _printBarcode("$countrycode-$productname");
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
    );
  }
  Future<void> _printBarcode(String info) async {
    final pdf = pw.Document();

    // Add a page with the barcode
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>pw.Center(
          child: pw.BarcodeWidget(
            backgroundColor: PdfColors.white,
            data: "$countrycode-$productname",
            barcode:widget.category=="Barcode"? Barcode.code128():Barcode.qrCode(), // For Barcode
            width: 250,
            height: widget.category=="Barcode"?100:250,
            color: PdfColors.black,
            drawText: false,
          ),
        ),
        pageFormat: PdfPageFormat.a4,
      ),
    );

    // Show print dialog and allow user to select a printer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
