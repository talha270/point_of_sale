import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/layout/mobile/mobileloginpage.dart';
import 'package:provider/provider.dart';

class GetbussinessDetail extends StatelessWidget {
  GetbussinessDetail({super.key});
  final _formkey=GlobalKey<FormState>();
  String businessname="";
  String businessaddress="";
  String businessponenumber="";
  String adminname="";
  String password="";
  String question1="";
  String question2="";
  final passwordcontroller=TextEditingController();
  final repasswordcontroller=TextEditingController();
  //----------------------functions-------------------------------
  trysubmit(BuildContext context){
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      _formkey.currentState!.save();
      Provider.of<ShareProvider>(context,listen: false).addnewadmin(adminname: adminname, password: password, question1: question1, question2: question2);
      Provider.of<ShareProvider>(context,listen: false).setbusinessdetail(date: DateFormat('yyyy-MM-dd').format(DateTime.now()),name: businessname, address1: businessaddress, ponenumber1: businessponenumber);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileLoginpage(),));
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
      ),
      body: SingleChildScrollView(
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
                  const SizedBox(height: 10,),
                  TextFormField(
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
                  Text("Create Admin Account",style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: 10,),
                  TextFormField(
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
                      adminname=newValue.toString().trim();
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    controller: passwordcontroller,
                    validator: (value) {
                      if(value.toString().length<10){
                        return "Password should contain 10 characters.";
                      }else if(value.toString()!=repasswordcontroller.text.toString()){
                        return "Password not Match.";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      password=passwordcontroller.text.toString().trim();
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Conform Password",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    controller: repasswordcontroller,
                    validator: (value) {
                      if(value.toString().length<10){
                        return "Password should contain 10 characters.";
                      }else if(value.toString()!=passwordcontroller.text.toString()){
                        return "Password not Match.";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      password=passwordcontroller.text.toString().trim();
                    },
                  ),
                  const SizedBox(height: 10,),
                  Text("Additional Information For Recovery.",style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Birth Place",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      question1=newValue.toString().trim();
                    },
                  ),
                  const SizedBox(height: 11,),
                  TextFormField(
                    decoration:InputDecoration(
                      hintText: "Pat Name",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if(value.toString().isEmpty){
                        return "Please Enter";
                      }else{
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      question2=newValue.toString().trim();
                    },
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.7,
                    child: ElevatedButton(onPressed: (){
                      trysubmit(context);
                    },
                        child: const Text("Create")),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
  }

