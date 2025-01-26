import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../controller/db_controller/dbcontroller.dart';
import '../../../widgets/alertbox.dart';

class Addscaner extends StatefulWidget {
  const Addscaner({
    super.key,
    required this.image,
    required this.productname,
    required this.perunitcost,
    required this.perunitprice,
    required this.taxrate,
    required this.noofunit,
    required this.categoryname,
    required this.description,
  });

  final XFile image;
  final String productname;
  final double perunitcost;
  final double perunitprice;
  final double taxrate;
  final int noofunit;
  final String categoryname;
  final String description;

  @override
  State<Addscaner> createState() => _Posmobilestate();
}

class _Posmobilestate extends State<Addscaner> {
  MobileScannerController cameraController = MobileScannerController(detectionSpeed: DetectionSpeed.normal,torchEnabled: true);
  bool isscanned = false; // Flag to prevent multiple scans
  bool isloading = true; // Loading state for fetching barcodes
  List<dynamic> barcodeList = []; // List of barcodes from database
  bool isAlertShowing = false; // Flag to track if the alert is already showing

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
      isscanned = false; // Reset scanning status on page load
    });
  }

  @override
  void initState() {
    super.initState();
    getBarcodes();
  }

  // Function to handle adding the barcode to the inventory
  Future<void> tryToAdd({required String barcode}) async {
    final dbController = Provider.of<Dbcontroller>(context, listen: false);
    bool success = await dbController.adddatainventory(
      barcodestring: barcode,
      image: widget.image.path,
      productname: widget.productname,
      perunitprice: widget.perunitprice,
      perunitcost: widget.perunitcost,
      description: widget.description,
      noofunit: widget.noofunit,
      taxrate: widget.taxrate,
      categorie: widget.categoryname,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Item Added to Inventory.",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 30,
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ));
      Navigator.pop(context); // Close current screen
      Navigator.pop(context); // Close current screen
    } else {
      showalertbox(
          context: context, message: "Please Try Again.", title: "Alert Box");
    }
  }

  // Show alert if barcode already exists
  void showBarcodeAlert(BuildContext context, String message) {
    if (!isAlertShowing) {
      isAlertShowing = true; // Prevent further alerts while one is showing
      showalertbox(
        context: context,
        message: message,
        title: "Alert Box",
      ).then((_) {
        setState(() {
          isAlertShowing = false; // Reset the flag when alert is closed
        });
      });
    }
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
          : isscanned
          ? const Center(child: CircularProgressIndicator())
          : MobileScanner(
        controller: cameraController,
        onDetect: (barcodeCapture) async {
          if (!isscanned) {
            final String? scannedBarcode =
            barcodeCapture.barcodes.isNotEmpty
                ? barcodeCapture.barcodes[0].rawValue
                : null;

            if (scannedBarcode == null) {
              debugPrint('Failed to scan barcode');
              return;
            }

            if (barcodeList.contains(scannedBarcode)) {
              // print("Barcode already exists: $scannedBarcode");
              showBarcodeAlert(context,
                  "This barcode is already added for another product.");
            } else {
              setState(() {
                isscanned = true; // Prevent further scans
              });
              // print("Adding new barcode: $scannedBarcode");
              await tryToAdd(barcode: scannedBarcode);
            }
          }
        },
      ),
    );
  }
}
