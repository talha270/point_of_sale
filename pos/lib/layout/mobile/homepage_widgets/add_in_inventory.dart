import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos/layout/mobile/homepage_widgets/addscaner.dart';
import 'package:provider/provider.dart';
import '../../../controller/db_controller/dbcontroller.dart';
import '../../../widgets/alertbox.dart';

class AddInInventory extends StatefulWidget{
  const AddInInventory({super.key});

  @override
  State<AddInInventory> createState() => _AddInInventoryState();
}

class _AddInInventoryState extends State<AddInInventory> {
  MobileScannerController cameraController = MobileScannerController();

  XFile? image;

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
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  trysubmit(BuildContext context)async{
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      if(image!=null){
        _formkey.currentState!.save();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Addscaner(image: image!,description: description!,categoryname: categoryname,noofunit: noofunit!,perunitcost: perunitcost!,perunitprice: perunitprice!,productname: productname,taxrate: taxrate!),));

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
                      decoration: InputDecoration(
                        hintText: "Enter Product Name",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Product Name is not empty.";
                        }else if(itemnames.contains(value.toString())){
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
                        if(Platform.isMacOS||Platform.isWindows||Platform.isLinux){
                          pickImage(ImageSource.gallery);
                        }else{
                        showAlertBox(context);
                        }
                      },
                      child: Container(
                        height: MediaQuery.sizeOf(context).height*0.15,
                        width: MediaQuery.sizeOf(context).width*0.25,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Theme.of(context).focusColor),
                          image:image!=null?DecorationImage(fit: BoxFit.cover,image: FileImage(File(image!.path))):null,),
                        child:image == null ? const Icon(Icons.image,size: 40,) :null,
                      )
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                keyboardType: TextInputType.number,
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
                decoration: InputDecoration(
                  hintText: "Description.",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                ),
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Description is not null.";
                  }else if(value.toString().length<50){
                    return "Description should be above 50 characters.";
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
                          trysubmit(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text("Next")),
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
      image=image1;
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