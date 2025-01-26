import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos/layout/mobile/homepage_widgets/detailspage.dart';
import 'package:provider/provider.dart';
import '../../../controller/db_controller/dbcontroller.dart';

class Scan extends StatefulWidget {
  const Scan({super.key,});

  @override
  State<Scan> createState() => _Posmobilestate();
}

class _Posmobilestate extends State<Scan> {
  MobileScannerController cameraController = MobileScannerController(detectionSpeed: DetectionSpeed.normal,torchEnabled: true);
  bool isscan=true;
  bool isloading = true; // Loading state for fetching barcodes
  List<dynamic> barcodeList = []; // List of barcodes from database
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

  @override
  void initState() {
    super.initState();
    getBarcodes();
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
  enablescan()async{
    await Future.delayed(const Duration(seconds: 1));
    isscan=true;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
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
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : MobileScanner(
        controller: cameraController,
        onDetect: (barcodeCapture) async {
            if(isscan) {
              final String? scannedBarcode =
              barcodeCapture.barcodes.isNotEmpty
                  ? barcodeCapture.barcodes[0].rawValue
                  : null;

              if (scannedBarcode == null) {
                _showSnackbar('Failed to scan barcode');
              }

              if (barcodeList.contains(scannedBarcode)) {
              // isloading=true;
              final temp=await Provider.of<Dbcontroller>(context,listen: false).searchbybarcode(scannedBarcode!);
              tojump(temp);
              } else {
                _showSnackbar('this barcode is not present.');
              }

              isscan = false;
              enablescan();
              setState(() {});
            }
        },
      ),
    );
  }
  tojump(var temp){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Detailspage(itemmap: temp!),));
  }
}
