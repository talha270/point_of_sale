import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pos/controller/provider_controller/pageprovider.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/layout/mobile/homepage_widgets/mobilepos.dart';
import 'package:pos/layout/mobile/homepage_widgets/mobilesalespage.dart';
import 'package:provider/provider.dart';

import 'homepage_widgets/add_in_inventory.dart';
import 'homepage_widgets/edit_bussiness_details.dart';
import 'homepage_widgets/generatebarcodepage.dart';
import 'homepage_widgets/removeitempage.dart';
import 'homepage_widgets/showinventory.dart';
class Mobilehome extends StatefulWidget {
  const Mobilehome({super.key});

  @override
  State<Mobilehome> createState() => _MobilehomeState();
}

class _MobilehomeState extends State<Mobilehome> {
  String businessname = "";
  bool isloading = true;
  getname() async {
    businessname = await Provider.of<ShareProvider>(context, listen: false)
        .getbusinessdetail();
    setState(() {
      isloading = false;
    });
  }

  List data = [
    {
      "icon": FontAwesomeIcons.shop,
      "title": "POS",
      "subtitle": "Click here to sale items.",
    },
    {
      "icon": FontAwesomeIcons.accusoft,
      "title": "Show inventory",
      "subtitle": "Click here to show inventory.",
    },
    {
      "icon": Icons.add_business_outlined,
      "title": "Add item",
      "subtitle": "Click here to add item.",
    },
    {
      "icon": FontAwesomeIcons.houseSignal,
      "title": "Remove item",
      "subtitle": "Click here to remove item.",
    },
    {
      "icon": FontAwesomeIcons.salesforce,
      "title": "Sales",
      "subtitle": "Click her to see Sales.",
    },
    {
      "icon": FontAwesomeIcons.camera,
      "title": "Scan",
      "subtitle": "Scan Qrcode and Barcode to get details.",
    },
    {
      "icon": FontAwesomeIcons.barcode,
      "title": "Barcode",
      "subtitle": "Click her to create barcode for product.",
    },
    {
      "icon": FontAwesomeIcons.qrcode,
      "title": "QRCode",
      "subtitle": "Click her to create qrcode for product.",
    },
  ];
  @override
  void initState() {
    super.initState();
    getname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<ShareProvider>(builder: (context, value, child) {
                    return Row(
                      children: [
                      Text(
                      value.businessname,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditBussinessDetails(),));
                        },
                            icon: const Icon(Icons.edit,color: Colors.grey,))
                      ],
                    );
                  }),
                  Text(
                    "DashBoard",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).primaryColor)
                        ]),
                    child: Center(
                        child: Text(
                      "Select Option",
                      style: Theme.of(context).textTheme.headlineMedium,
                    )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Posmobile(),));
                            } else if (index == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Showinventory(),));
                            } else if (index == 2) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddInInventory(),));
                            } else if (index == 3) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Removeitempage(),));
                            } else if (index == 4) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Mobilesalespage(),));
                            } else if (index == 5) {
                              Provider.of<Pageprovider>(context,listen: false).onchange(2);
                            } else if (index == 6) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Generatebarcodepage(category: "Barcode",),));
                            } else if (index == 7) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Generatebarcodepage(category: "Qrcode",),));
                            } else {}
                          },
                          child: Container(
                            // height: 200,
                            // width: 200,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(data[index]["icon"],
                                      size: 40),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    data[index]["title"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    data[index]["subtitle"],
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 200),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
