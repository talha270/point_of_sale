import 'package:flutter/material.dart';
import 'package:pos/controller/db_controller/dbcontroller.dart';
import 'package:pos/controller/provider_controller/categoriesitem.dart';
import 'package:provider/provider.dart';

import '../layout/mobile/homepage_widgets/detailspage.dart';
import 'alertbox.dart';

class Searchbar extends StatelessWidget {
  var controller = TextEditingController();
  Searchbar({super.key, required this.removecheck});
  final bool removecheck;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).shadowColor),

      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Theme.of(context).shadowColor),
                  hintText: "Search Item By Name.",
                  errorBorder:InputBorder.none,
                  focusedBorder:InputBorder.none,
                  focusedErrorBorder:InputBorder.none,
                  disabledBorder:InputBorder.none,
                  enabledBorder:InputBorder.none,
                  border:InputBorder.none,
                ),
                controller: controller,
              ),
            ),
          ),
          IconButton(
              onPressed: ()async{
                FocusScope.of(context).unfocus();
                List temp= await Provider.of<Dbcontroller>(context,listen: false).getproductnames();
                if(temp.contains(controller.text.toString())){
                if(!removecheck){
                 List< Map<String,dynamic>> arg=await Provider.of<Dbcontroller>(context,listen: false).searchbyname(controller.text.toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Detailspage(itemmap: arg[0]),));
                  controller.clear();
                }
                else{
                  final categoryprovider=Provider.of<Categoriesitem>(context,listen: false);
                  categoryprovider.changesearch(search: controller.text.toString(), newCategory: "search");
                }
                }else{
                  showalertbox(context: context,title: "Alert Box",message: "No such Item Found.");
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
    );
  }
}
