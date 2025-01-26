import 'package:flutter/material.dart';
import 'package:pos/controller/provider_controller/share_provider.dart';
import 'package:pos/pages/responsive.dart';
import 'package:provider/provider.dart';

class OnboardingOrHome extends StatefulWidget {
  const OnboardingOrHome({super.key, required this.mobilebody, required this.desktopbody, required this.mobileonboarding, required this.desktoponboarding});
  final Widget mobilebody;
  final Widget desktopbody;
  final Widget mobileonboarding;
  final Widget desktoponboarding;
  @override
  State<OnboardingOrHome> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<OnboardingOrHome> {
  late int choice;
  bool isloading=true;
  check()async{
    final shareprovider=Provider.of<ShareProvider>(context,listen: false);
    choice=await shareprovider.getnoofuser();
    // print("choice: $choice");
    isloading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    check();
  }
  @override
  Widget build(BuildContext context) {
    return  isloading? const Scaffold(
      body: Center(child: CircularProgressIndicator()),)
        :choice==0?Responsivelayout(mobilebody: widget.mobileonboarding,desktopbody: widget.desktoponboarding,):Responsivelayout(mobilebody: widget.mobilebody,desktopbody: widget.desktopbody,);
}
}