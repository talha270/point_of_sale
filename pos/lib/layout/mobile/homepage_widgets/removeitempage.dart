import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider_controller/categoriesitem.dart';
import '../../../widgets/alertbox.dart';
import '../../../widgets/chipsitems.dart';
import '../../../widgets/searchbar.dart';

class Removeitempage extends StatefulWidget{
  const Removeitempage({super.key});

  @override
  State<Removeitempage> createState() => _RemoveitempageState();
}

class _RemoveitempageState extends State<Removeitempage> {
  late List items;
  @override
  void initState() {
    super.initState();

  }
  trytoremove(BuildContext context,int id,var item)async{
        final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);

        bool check=await dbcontroller.deleteInventory(id: id);
        // print("check: $check");
        if(check){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Item Deleted From Inventory.",style: Theme.of(context).textTheme.titleLarge,),
              elevation: 30,
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(label: "undo", onPressed: ()async{
             bool test=await dbcontroller.adddatainventory( barcodestring: item[dbcontroller.inventorycolumn10barcode],image: item[dbcontroller.inventorycolumn7image], productname: item[dbcontroller.inventorycolumn2name], perunitprice: item[dbcontroller.inventorycolumn3price], perunitcost: item[dbcontroller.inventorycolumn6cost], description: item[dbcontroller.inventorycolumn4description], noofunit: item[dbcontroller.inventorycolumn5nounit], taxrate: item[dbcontroller.inventorycolumn8taxrate], categorie: item[dbcontroller.inventorycolumn9categoriesname]);
             if(test){
               // print("test $test");
               // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Re Added Item In Inventory.",style: Theme.of(context).textTheme.titleLarge,),
               //     elevation: 30,
               //     backgroundColor: Theme.of(context).primaryColor,
               //     behavior: SnackBarBehavior.floating,
               //     duration: const Duration(seconds: 3),
               // ));
               setState(() {

               });
              }})
          ));
          setState(() {

          });
        }else{
          showalertbox(context: context,message: "Please Try Again.",title: "Alert Box");
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Provider.of<Categoriesitem>(context,listen: false).changename("all");
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
      body:  RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {

          });
        },
        child: Consumer<Dbcontroller>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.getdbdata(tablename: value.inventorytablename),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  // print(snapshot.data.runtimeType);
                  return snapshot.data!.isNotEmpty
                      ? FutureBuilder(
                    future: value.getcategories(),
                    builder: (context, chipsnapshot) {
                      if (chipsnapshot.hasData) {
                        List<Map<String, dynamic>> temp =
                        List<Map<String, dynamic>>.from(
                            chipsnapshot.data!);
                        temp.insert(0, {"categories": "all"});
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Searchbar(removecheck: true,),
                              const SizedBox(
                                height: 10,
                              ),
                              Chipsitems(items: temp,dateyacategory: "categories",),
                              const SizedBox(
                                height: 10,
                              ),
                              Consumer<Categoriesitem>(
                                builder: (context, categoryProvider, child) {
                                  return FutureBuilder(
                                    future: categoryProvider.getitems(snapshot.data!),
                                    builder: (context, itemsnapshot) {
                                      if (itemsnapshot.hasData) {
                                        return listitems(
                                            context: context,
                                            item: itemsnapshot.data!);
                                      } else if (itemsnapshot.hasError) {
                                        return Center(
                                          child: Text("${itemsnapshot.error}"),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // print(snapshot.error);
                        return Center(
                          child: Text("${snapshot.error}"),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                      : const Center(child: Text("No Any Item"));
                } else if (snapshot.hasError) {
                  // print(snapshot.error);
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

listitems({required var item,required BuildContext context}) {
  final value = Provider.of<Dbcontroller>(context, listen: false);
  return Expanded(
    child: ListView.builder(
      itemBuilder: (context, index) {
        return Card(elevation: 30,
            child: ListTile(
                title: Text(item[index][value.inventorycolumn2name]),
                subtitle: Text(item[index][value.inventorycolumn4description],overflow: TextOverflow.ellipsis,),
                leading: CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: FileImage(File(item[index][value.inventorycolumn7image])),),
                trailing: IconButton(onPressed: (){

                  trytoremove(context,item[index][value.inventorycolumn1sno],item[index]);
                },
                    icon: const Icon(Icons.delete)),
            ));
      },
      itemCount: item.length,
    ),
  );
}

}


// Column(
// children: [
// Stack(children: [
// Card(
// elevation: 20,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(10),
// child: Container(
// height: MediaQuery.sizeOf(context).height * 0.3,
// foregroundDecoration: const BoxDecoration(
// gradient: LinearGradient(
// colors: [Colors.black, Colors.transparent],
// begin: Alignment.bottomCenter,
// end: Alignment.topCenter),
// ),
// decoration: BoxDecoration(
// // color: Colors.red,
// borderRadius: BorderRadius.circular(10),
// image: DecorationImage(
// image: MemoryImage(
// item[index][value.inventorycolumn7image]),
// fit: BoxFit.cover)),
// ),
// ),
// ),
// Positioned(
// bottom: MediaQuery.sizeOf(context).height / 18,
// left: 10,
// child: Text(
// item[index][value.inventorycolumn2name],
// style: Theme.of(context)
//     .textTheme
//     .headlineMedium!
//     .copyWith(color: Colors.white),
// )),
// Positioned(
// bottom: MediaQuery.sizeOf(context).height * 0.03,
// left: 10,
// child: SizedBox(
// width: MediaQuery.sizeOf(context).width * 0.8,
// child: Text(
// item[index][value.inventorycolumn4description],
// overflow: TextOverflow.ellipsis,
// style: Theme.of(context)
//     .textTheme
//     .bodyLarge!
//     .copyWith(color: Colors.white),
// ))),
// ]),
// const SizedBox(
// height: 5,
// )
// ],
// ),