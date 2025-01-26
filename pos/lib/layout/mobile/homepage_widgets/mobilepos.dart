import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos/layout/mobile/homepage_widgets/generated_bill.dart';
import 'package:provider/provider.dart';
import '../../../controller/db_controller/dbcontroller.dart';

class Posmobile extends StatefulWidget {
  const Posmobile({super.key});

  @override
  State<Posmobile> createState() => _Posmobilestate();
}

class _Posmobilestate extends State<Posmobile> {
  MobileScannerController cameraController = MobileScannerController(detectionSpeed: DetectionSpeed.normal,torchEnabled: true);
  bool isloading = true; // Loading state for fetching barcodes
  List<dynamic> barcodeList = []; // List of barcodes from database
  bool isscan = true;
  List billitems=[];
  List billbarcodes=[];
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  // Fetch barcodes from the database
  Future<void> getBarcodes() async {
    final dbController = Provider.of<Dbcontroller>(context, listen: false);
    barcodeList = await dbController.getproducdbarcode();
    setState(() {
      isloading = false;
    });
  }

  Future<void> tryToAddInBill({required String barcode}) async {
    final dbController = Provider.of<Dbcontroller>(context, listen: false);

    if (!barcodeList.contains(barcode)) {
      _showSnackbar("No Such Item In Inventory.");
      return;
    }

    final temp = await dbController.searchbybarcode(barcode);
    final int stock = temp[dbController.inventorycolumn5nounit];

    if (stock == 0) {
      _showSnackbar("No More Stock In Inventory.");
      return;
    }

    if (billbarcodes.contains(barcode)) {
      _updateBillItem(barcode, stock);
    } else {
      _addNewItemToBill(temp, barcode);
    }
  }

  void _updateBillItem(String barcode, int stock) {
    final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
    for (int i = 0; i < billitems.length; i++) {
      if (billitems[i][dbcontroller.inventorycolumn10barcode] == barcode) {
        if (stock >= (billitems[i][dbcontroller.salesitemcolumn4quantity] + 1)) {
          billitems[i][dbcontroller.salesitemcolumn4quantity]++;
          billitems[i][dbcontroller.salesitemcolumn6total] = billitems[i][dbcontroller.salesitemcolumn5price] * billitems[i][dbcontroller.salesitemcolumn4quantity];
          billitems[i]["totalcost"] = billitems[i][dbcontroller.inventorycolumn6cost] * billitems[i][dbcontroller.salesitemcolumn4quantity];
          _showSnackbar("Item Added In Bill.");
        } else {
          _showSnackbar("No More Stock In Inventory.");
        }
        break;
      }
    }
  }

  void _addNewItemToBill(Map<String, dynamic> temp, String barcode) {
    final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);
    final double price = temp[dbcontroller.inventorycolumn3price];
    final double taxRate = temp[dbcontroller.inventorycolumn8taxrate];
    final double finalPrice = price + (price * (taxRate / 100));

    billbarcodes.add(barcode);
    billitems.add({
      dbcontroller.inventorycolumn10barcode: barcode,
      "preprice": temp[dbcontroller.inventorycolumn3price],
      "totalcost": temp[dbcontroller.inventorycolumn6cost],
      dbcontroller.salesitemcolumn3productName: temp[dbcontroller.inventorycolumn2name],
      dbcontroller.salesitemcolumn4quantity: 1,
      dbcontroller.salesitemcolumn5price: finalPrice,
      dbcontroller.salesitemcolumn6total: finalPrice,
      dbcontroller.inventorycolumn7image:temp[dbcontroller.inventorycolumn7image],
      dbcontroller.inventorycolumn6cost:temp[dbcontroller.inventorycolumn6cost],
      dbcontroller.inventorycolumn4description:temp[dbcontroller.inventorycolumn4description],
      dbcontroller.inventorycolumn5nounit:temp[dbcontroller.inventorycolumn5nounit],
      dbcontroller.inventorycolumn8taxrate:temp[dbcontroller.inventorycolumn8taxrate],
      dbcontroller.inventorycolumn9categoriesname:temp[dbcontroller.inventorycolumn9categoriesname],
      dbcontroller.inventorycolumn1sno:temp[dbcontroller.inventorycolumn1sno]
    });
    _showSnackbar("Item Added In Bill.");
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      elevation: 30,
      backgroundColor: Theme.of(context).primaryColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    getBarcodes();
  }

  enablescan()async{
    await Future.delayed(const Duration(seconds: 2));
    isscan=true;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).focusColor,
            )),
        actions: [
          IconButton(
            icon: cameraController.torchEnabled
                ? const Icon(Icons.flash_on)
                : const Icon(Icons.flash_off),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
        elevation: 20,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                    children: [
            Expanded(child: MobileScanner(
              controller: cameraController,
              onDetect: (barcodeCapture) async {
                if(isscan){
                  tryToAddInBill(barcode: barcodeCapture.barcodes[0].rawValue!);
                  isscan=false;
                  enablescan();
                  setState(() {});
                }
              },
            ),),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GeneratedBill(itemlist: billitems),));
              },
                  child: const Text("Generate Bill")),
            ),
            const SizedBox(height: 10,),
                    ],
                  ),
          )
    );
  }
}
