import 'package:flutter/material.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:provider/provider.dart';

class Mobilechangepassword extends StatefulWidget {
  const Mobilechangepassword({super.key, required this.index});
  final int index;

  @override
  State<Mobilechangepassword> createState() => _MobilechangepasswordState();
}

class _MobilechangepasswordState extends State<Mobilechangepassword> {
  final passwordcontroller=TextEditingController();

  final repasswordcontroller=TextEditingController();

  final _formkey = GlobalKey<FormState>();

  String ques1="";

  String ques2="";

  String password="";
  late List<String> detail;
  trysubmit(BuildContext context)async{
    final isvalid=_formkey.currentState!.validate();
    if (isvalid){
      _formkey.currentState!.save();
      final shareprovider=Provider.of<ShareProvider>(context,listen: false);
      detail[1]=password;
      shareprovider.changepassword(index: widget.index, list: detail, context: context);

    }else{
      // print("error");
    }
  }
  getdetail()async{
    detail=await Provider.of<ShareProvider>(context,listen: false).getuserdetails(index:widget.index);
  }
  @override
  void initState() {
    super.initState();
    getdetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Recovery questions",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Birth Place",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Please Enter";
                        }else if(detail[2]!=value){
                          return "Please Enter A Correct Answer.";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        ques1 = newValue.toString().trim();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Pet Name",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Please Enter";
                        }else if(detail[3]!=value){
                          return "Please Enter A Correct Answer.";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        ques2 = newValue.toString().trim();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration:InputDecoration(
                        hintText: "Enter New Password",
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
                        hintText: "Conform New Password",
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: ElevatedButton(
                          onPressed: () {
                            trysubmit(context);
                          },
                          child: const Text("Change Password")),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
