
import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/salesprovider.dart';
import 'package:pos/layout/mobile/homepage_widgets/salesdetailmobile.dart';
import 'package:provider/provider.dart';

import '../../../widgets/chipsitems.dart';

class Mobilesalespage extends StatefulWidget{
  const Mobilesalespage({super.key});

  @override
  State<Mobilesalespage> createState() => _Mobilesalespagestate();
}

class _Mobilesalespagestate extends State<Mobilesalespage> {
  late List items;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Provider.of<Salesprovider>(context,listen: false).changedate("all");
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
              future: value.getdbdata(tablename: value.salestablename),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  // print(snapshot.data.runtimeType);
                  return snapshot.data!.isNotEmpty
                      ? FutureBuilder(
                    future: value.getsalesdate(),
                    builder: (context, chipsnapshot) {
                      if (chipsnapshot.hasData) {
                        List<Map<String, dynamic>> temp =
                        List<Map<String, dynamic>>.from(
                            chipsnapshot.data!).reversed.toList();
                        temp.insert(0, {"date": "all"});
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Chipsitems(items: temp,dateyacategory: "date"),
                              const SizedBox(
                                height: 10,
                              ),
                              Consumer<Salesprovider>(
                                builder: (context, salesProvider, child) {
                                  return FutureBuilder(
                                    future: salesProvider.getitems(snapshot.data!),
                                    builder: (context, itemsnapshot) {
                                      if (itemsnapshot.hasData) {
                                        List temp=itemsnapshot.data!.reversed.toList();
                                        return listitems(
                                            context: context,
                                            item: temp);
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
                      : const Center(child: Text("No Any Sales"));
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
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Salesdetailmobile(salesid: item[index][value.salescolumn1saleid],),));

            },
            child: Card(elevation: 30,
                child: ListTile(
                  title: Text(item[index][value.salescolumn2customername]),
                  subtitle: Text("${item[index][value.salescolumn3date]}, ${item[index][value.salescolumn4time]}",overflow: TextOverflow.ellipsis,),
                  leading:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ID"),
                      Text(item[index][value.salescolumn6totalcost].toString())
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Amount"),
                      Text(item[index][value.salescolumn5totalamount].toStringAsFixed(2))
                    ],
                  ),
                )),
          );
        },
        itemCount: item.length,
      ),
    );
  }
}