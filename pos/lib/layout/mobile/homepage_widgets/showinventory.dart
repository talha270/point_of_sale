import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/categoriesitem.dart';
import 'package:provider/provider.dart';

import '../../../widgets/chipsitems.dart';
import '../../../widgets/searchbar.dart';
import 'detailspage.dart';

class Showinventory extends StatefulWidget {
  const Showinventory({super.key});
  @override
  State<Showinventory> createState() => _ShowinventoryState();
}

class _ShowinventoryState extends State<Showinventory> {
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
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: Consumer<Dbcontroller>(
            builder: (context, value, child) {
              return FutureBuilder(
                future: value.getdbdata(tablename: value.inventorytablename),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                                      Searchbar(removecheck: false,),
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
        ));
  }

  listitems({required var item, required BuildContext context}) {
    final value = Provider.of<Dbcontroller>(context, listen: false);
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detailspage(
                      itemmap: item[index],
                    ),
                  ));
            },
            child: Column(
              children: [
                Stack(children: [
                  Card(
                    elevation: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        foregroundDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: FileImage(File(item[index][value.inventorycolumn7image])),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.sizeOf(context).height / 18,
                      left: 10,
                      child: Text(
                        item[index][value.inventorycolumn2name],
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      )),
                  Positioned(
                      bottom: MediaQuery.sizeOf(context).height * 0.03,
                      left: 10,
                      child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: Text(
                            item[index][value.inventorycolumn4description],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ))),
                ]),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          );
        },
        itemCount: item.length,
      ),
    );
  }

}
