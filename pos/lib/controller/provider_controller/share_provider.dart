
import 'package:flutter/material.dart';
import 'package:pos/layout/mobile/mobilechangepassword.dart';
import 'package:pos/layout/mobile/mobileloginpage.dart';
import 'package:pos/widgets/alertbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/sharekeys.dart';
import '../../layout/mobile/mobilepageview.dart';

class ShareProvider with ChangeNotifier{
 late int _noofuser;
 late String businessname;
 late String address;
 late String ponenumber;
 late String publishdate;
 bool isloading=true;
 Future<int> getnoofuser() async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   if(prefs.getInt(Sharekeys.noofuser)==null){
    prefs.setInt(Sharekeys.noofuser, 0);
    _noofuser=0;
    return _noofuser;
   }else{
    _noofuser=prefs.getInt(Sharekeys.noofuser)!.toInt();
    return _noofuser;
   }
 }
 Future<int> increasenoofuser() async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
  _noofuser=prefs.getInt(Sharekeys.noofuser)!;
  _noofuser++;
  prefs.setInt(Sharekeys.noofuser, _noofuser);
   return _noofuser;
 }
 setbusinessdetail({required String date,required String name,required String address1,required String ponenumber1})async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   prefs.setString(Sharekeys.businessname, name);
   prefs.setString(Sharekeys.address, address1);
   prefs.setString(Sharekeys.ponenumber, ponenumber1);
   prefs.setString(Sharekeys.datetime,date);
 }
 updatebusinessdetail({required String name,required String address1,required String ponenumber1,required List<String> adminname})async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   prefs.setString(Sharekeys.businessname, name);
   prefs.setString(Sharekeys.address, address1);
   prefs.setString(Sharekeys.ponenumber, ponenumber1);
   prefs.setStringList("user1", adminname);
 }
 getbusinessdetail()async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   businessname=prefs.getString(Sharekeys.businessname)!.toString();
   address=prefs.getString(Sharekeys.address)!.toString();
   ponenumber=prefs.getString(Sharekeys.ponenumber)!.toString();
   publishdate=prefs.getString(Sharekeys.datetime)!.toString();
   return businessname;
 }
 addnewadmin({required String adminname,required String password,required String question1,required String question2})async{
    increasenoofuser();
   final SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setStringList("user$_noofuser", [adminname,password,question1,question2]);
 }
 checklogin({required String adminname,required String password,required BuildContext context})async{
   bool access=false;
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   for(int i=1;i<=_noofuser;i++){
    List<String> temp=prefs.getStringList("user$i")!;
    // print(temp);
    if(temp[0]==adminname){
      // print(temp[0]);
      if(temp[1]==password){
      // print(temp[1]);
        access=true;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Mobilepageview(),));
        break;
      }else{
      }
    }

  }
   if(access==false){
   showalertbox(context: context,title: "Alert box",message: "Some thing error.Please try again.");
   }
 }
 haveauser({required String name,required BuildContext context})async{
   bool access=false;
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   for(int i=1;i<=_noofuser;i++){
     List<String> temp=prefs.getStringList("user$i")!;
     if(name==temp[0]){
       access=true;
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mobilechangepassword(index: i,),));
        break;
     }
   }
   if(access==false){
   showalertbox(context: context, title: "Alert Box", message: "user id not present.please enter correct one.");
   }
 }
 getuserdetails({required int index})async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   List<String> temp=prefs.getStringList("user$index")!;
   return temp;
 }
 changepassword({required int index,required List<String> list,required BuildContext context})async{
   final SharedPreferences prefs =await SharedPreferences.getInstance();
   prefs.setStringList("user$index",list);
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileLoginpage(),));
 }

}
