import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../controller/db_controller/dbcontroller.dart';
import '../../../widgets/alertbox.dart';

class Updatedetails extends StatefulWidget{
  const Updatedetails({super.key, required this.item});
  final Map<String,dynamic> item;
  @override
  State<Updatedetails> createState() => _Updatedetailstate();
}

class _Updatedetailstate extends State<Updatedetails> {
  String? image;

  String productname="";

  double? perunitcost;

  double? perunitprice;
  double? taxrate;

  int? noofunit;
  String categoryname="";

  String? description;

  bool isloading=true;
  final _formkey=GlobalKey<FormState>();
  late List itemnames;
  setitems()async{
    // print("object");
    image=widget.item["image"];
    itemnames=await Provider.of<Dbcontroller>(context,listen: false).getproductnames();
    // print("object");
    isloading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    setitems();
  }
  trysubmit(BuildContext context,String image)async{
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      if(image!=null){
        _formkey.currentState!.save();
        final dbcontroller=Provider.of<Dbcontroller>(context,listen: false);

        bool check=await dbcontroller.updateInventory(image: image, productname: productname, perunitprice: perunitprice!, perunitcost: perunitcost!, description: description!, noofunit: noofunit!, taxrate: taxrate!,categorie: categoryname, id: widget.item[dbcontroller.inventorycolumn1sno]);
        if(check){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Item Updated In Inventory.",style: Theme.of(context).textTheme.titleLarge,),
            elevation: 30,
            backgroundColor: Theme.of(context).primaryColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ));
          Timer.periodic(const Duration(seconds: 2), (timer) {
            Navigator.pop(context);
            Navigator.pop(context);
          });

        }else{
          showalertbox(context: context,message: "Please Try Again.",title: "Alert Box");
        }
      }
      else{
        showalertbox(context: context,message: "Please Add Image.",title: "Alert Box");
      }

    }else{
      // print("error");
    }
  }
  @override
  Widget build(BuildContext context) {
    final dbcontroller=Provider.of<Dbcontroller>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text("Inventory Tech",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.blueAccent),),
          elevation:20,
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Theme.of(context).shadowColor,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).focusColor,))
      ),
      body:isloading?const Center(child: CircularProgressIndicator()):Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),// Allows scrolling if content is larger than the available height
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Item In Inventory",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: widget.item[dbcontroller.inventorycolumn2name].toString(),
                          decoration: InputDecoration(
                            hintText: "Enter Product Name",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Product Name is not empty.";
                            }else if(itemnames.contains(value.toString())&&value!=widget.item[dbcontroller.inventorycolumn2name]){
                              return "Please enter unique name.";
                            }else {
                              return null;
                            }
                          },
                          onSaved: (value){
                            productname=value!.toString().trim();
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                          onTap: ()async{
                            showAlertBox(context);
                          },
                          child: Container(
                            height: MediaQuery.sizeOf(context).height*0.15,
                            width: MediaQuery.sizeOf(context).width*0.25,
                            decoration: BoxDecoration(
                              // color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).focusColor),
                              image:DecorationImage(image: FileImage(File(image!)))),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: widget.item[dbcontroller.inventorycolumn6cost].toString(),
                    decoration: InputDecoration(
                      hintText: "Enter per unit cost.",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "cost is not null.";
                      }else if (double.tryParse(value!.trim()) == null) {
                        return "Please enter a valid number.";
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      perunitcost=double.parse(value!.toString());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: widget.item[dbcontroller.inventorycolumn3price].toString(),
                    decoration: InputDecoration(
                      hintText: "Enter per unit price.",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Price is not null.";
                      }else if (double.tryParse(value!.trim()) == null) {
                        return "Please enter a valid number.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      perunitprice=double.parse(value!.toString());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.item[dbcontroller.inventorycolumn5nounit].toString(),
                    decoration: InputDecoration(
                      hintText: "Enter Number of Unit.",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Unit is not null.";
                      }else if (int.tryParse(value!.trim()) == null) {
                        return "Please enter a valid number.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      noofunit=int.parse(value.toString());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    initialValue: widget.item[dbcontroller.inventorycolumn8taxrate].toString(),
                    decoration: InputDecoration(
                      hintText: "Enter Tax Rate.",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Tax Rate is not null.";
                      }else if (double.tryParse(value!.trim()) == null) {
                        return "Please enter a valid number.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      taxrate=double.parse(value.toString());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: widget.item[dbcontroller.inventorycolumn9categoriesname].toString(),
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Category is not null.";
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      categoryname=value.toString().trim();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 4,
                    initialValue: widget.item[dbcontroller.inventorycolumn4description].toString(),
                    decoration: InputDecoration(
                      hintText: "Description.",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Description is not null.";
                      }else if(value.toString().length<50){
                        return "Description should be above 100 characters.";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value){
                      description=value.toString().trim();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              trysubmit(context,image!);
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text("Update")),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      ),
                    ],
                  ),
                ],
              ),)
        ),
      ),
    );
  }
  showAlertBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text("Choice"),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async{
                Navigator.of(context).pop();
                await pickImage(ImageSource.gallery);
              },
              child: const Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 10),
                  Text("Gallery"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async{
                Navigator.of(context).pop();
                await pickImage(ImageSource.camera);
              },
              child: const Row(
                children: [
                  Icon(Icons.camera),
                  SizedBox(width: 10),
                  Text("Camera"),
                ],
              ),
            ),
          ],
        ),
        elevation: 20,
      ),
    );
  }
  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image1 = await picker.pickImage(source: source);
    if (image1 != null) {
      image=image1.path;
      setState(() {

      });
    }
  }
  bool validatename(String categoryname){
    bool check=false;
    for(int i=0;i<itemnames.length;i++){
      if(categoryname==itemnames[i]["categories"]){
        check=true;
      }
    }
    return check;
  }
}