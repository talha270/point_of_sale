import 'package:flutter/material.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/layout/mobile/mobilepageview.dart';
import 'package:provider/provider.dart';

class EditBussinessDetails extends StatefulWidget {
  const EditBussinessDetails({super.key});

  @override
  State<EditBussinessDetails> createState() => _GetbussinessDetailState();
}

class _GetbussinessDetailState extends State<EditBussinessDetails> {
  final _formkey=GlobalKey<FormState>();
  bool isloading=true;
  String businessname="";

  String businessaddress="";

  String businessponenumber="";

  List<String> adminname=[];

  //----------------------functions-------------------------------
  tryupdate(BuildContext context){
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      _formkey.currentState!.save();
      final share=Provider.of<ShareProvider>(context,listen: false);
      share.updatebusinessdetail(name: businessname, address1: businessaddress, ponenumber1: businessponenumber, adminname: adminname);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Mobilepageview(),));
    }else{
      // print("error");
    }
  }
  @override
  void initState() {
    super.initState();
    getdetails();
  }
  getdetails()async{
    final shareprovider=Provider.of<ShareProvider>(context,listen: false);
    await shareprovider.getbusinessdetail();
    final userlist=await shareprovider.getuserdetails(index: 1);
    adminname=userlist;
    // print("name :$adminname");
    isloading=false;
    setState(() {

    });
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
      body:isloading?const Center(child: CircularProgressIndicator(),): Center(
        child: Consumer<ShareProvider>(
          builder: (context, value, child) {
            return  SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Inventory System",style: Theme.of(context).textTheme.headlineSmall,),
                        Text("And",style: Theme.of(context).textTheme.headlineSmall,),
                        Text("Point Of Sales System",style: Theme.of(context).textTheme.headlineSmall,),
                        const SizedBox(height: 30,),
                        TextFormField(
                          initialValue: value.businessname,
                          decoration:InputDecoration(
                            hintText: "Business Name",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if(value.toString().isEmpty){
                              return "Business Name Can't null";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            businessname=newValue.toString().trim();
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          initialValue: value.address,
                          decoration:InputDecoration(
                            hintText: "Shop Address",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if(value.toString().isEmpty){
                              return "Shop Address Can't null";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            businessaddress=newValue.toString().trim();
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          initialValue: value.ponenumber,
                          decoration:InputDecoration(
                            hintText: "Shop Phone number",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if(value.toString().isEmpty){
                              return "Shop Phone number Can't null";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            businessponenumber=newValue.toString().trim();
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          initialValue: adminname[0],
                          decoration:InputDecoration(
                            hintText: "Admin Name",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if(value.toString().isEmpty){
                              return "Admin Name Can't null";
                            }else if(value.toString().length<10){
                              return "Name length should be greater than 10 characters";
                            }else{
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            adminname[0]=newValue.toString().trim();
                          },
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.7,
                          child: ElevatedButton(onPressed: (){
                            tryupdate(context);
                          },
                              child: const Text("Update")),
                        ),
                      ],
                    )
                ),
              ),
            );
          },
        ),
      )
    );
  }
}

