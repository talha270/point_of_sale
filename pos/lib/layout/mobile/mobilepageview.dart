import 'package:flutter/material.dart';
import 'package:pos/controller/provider_controller/pageprovider.dart';
import 'package:pos/layout/mobile/mobilehome.dart';
import 'package:pos/layout/mobile/record_of_sales_pages/recordsales.dart';
import 'package:pos/layout/mobile/scanning_and_get_details/Scan.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Mobilepageview extends StatelessWidget {
  const Mobilepageview({super.key});
  @override
  Widget build(BuildContext context) {
    final pageprovider=Provider.of<Pageprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Tech",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.blueAccent),),
        elevation:20,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: PageView(
        controller: pageprovider.controller,
        onPageChanged: (value) => pageprovider.onchange(value),
        children: const [
        Mobilehome(),
        Recordsales(),
          Scan()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageprovider.currentindex,
        elevation: 30,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        // backgroundColor: Theme.of(context).shadowColor,
        onTap: (value) => pageprovider.onchange(value),

        items: const [
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.houseFire),label: "Home"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.chartColumn),label: "Records"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.qrcode),label: "Scan"),
        ],
      ),
    );
  }
}

