import'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/provider_controller/share_provider.dart';
import 'getuser.dart';

class MobileLoginpage extends StatelessWidget {
  MobileLoginpage({super.key});
  String username="";
  String password="";
  final _formkey=GlobalKey<FormState>();
  trysubmit(BuildContext context)async{
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      _formkey.currentState!.save();
      final shareprovider=Provider.of<ShareProvider>(context,listen: false);
      shareprovider.checklogin(adminname: username, password: password, context: context);
      
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
      body:Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
              children: [
                const SizedBox(height: 10,),
                Text("Login In Inventory Tech",style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration:InputDecoration(
                    hintText: "Enter User Name",
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
                    username=newValue.toString().trim();
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration:InputDecoration(
                    hintText: "Enter Password",
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
                    password=newValue.toString().trim();
                  },
                ),
                const SizedBox(height: 10,),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Getuser(),));
                },
                    child: Text("Want to change password?",style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.blueAccent),)),
                const SizedBox(height: 10,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width*0.7,
                  child: ElevatedButton(onPressed: (){
                    trysubmit(context);
                  },
                      child: const Text("Login")),
                ),
              ],
            )),
          ),
        ),
      )
    );
  }
}

